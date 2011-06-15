require 'rubygems'
require 'id3lib'
require 'dbus'

def writeLyrics(amarok_player)
        # get the current songs metadata
        metadata = amarok_player.GetMetadata
        metadata
        lyrics = metadata[0]["lyrics"]
        filename = metadata[0]["location"]

        if lyrics == nil
            exit(1)
        end

        filename = filename[7,filename.length]
        filename = filename.gsub("%20", " ")
        if File.extname(filename) != ".mp3"
          exit(1)
        end

        # Load a tag from a file
        tag = ID3Lib::Tag.new(filename)

        # Remove all lyrics frames
        tag.delete_if{ |frame| frame[:id] == :USLT }

        # prepare lyrics tag
        lyrics = {
          :id          => :USLT,
          :textenc     => 0, # gives ISO-8859-1
          :language    => 'eng',
          :description => '',
          :text        => lyrics
        }

        # add lyrics
        tag << lyrics

        # apply changes
        tag.update!

        p "Wrote lyrics to " + filename
end

# Connect to Amarok via dbus
bus = DBus::SessionBus.instance
amarok_service = bus.service("org.kde.amarok")
amarok_player = amarok_service.object("/Player")
amarok_player.introspect
amarok_player.default_iface = "org.freedesktop.MediaPlayer" 
#puts amarok_player.to_yaml

p "Registered to the amarok dbus service"

amarok_player.on_signal("TrackChange") do |u|
    p "The track changed lets look for lyrics..."

    # Give amarok some time to fetch the lyrics
    sleep(10)

    # write the lyrics to the tag
    writeLyrics amarok_player
end

loop = DBus::Main.new
loop << bus
loop.run

