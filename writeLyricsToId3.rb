require 'rubygems'
require 'id3lib'
require 'dbus'

def writeLyrics(amarok_player)
        # get the current songs metadata
        metadata = amarok_player.GetMetadata
        lyrics = metadata[0]["lyrics"]
        filename = metadata[0]["location"]

        if lyrics == nil
            p "No lyrics received from amarok."
            return false
        end

        filename = filename[7,filename.length]
        filename = filename.gsub("%20", " ")
        if File.extname(filename) != ".mp3"
          p "Writing the lyrics tag failed because it's no mp3 file."
          return false
        end

        # Load a tag from a file
        tag = ID3Lib::Tag.new(filename)

        # Remove all lyrics frames
        tag.delete_if{ |frame| frame[:id] == :USLT }

        # prepare lyrics tag
        lyricsTag = {
          :id          => :USLT,
          :textenc     => 0, # gives ISO-8859-1
          :language    => 'eng',
          :description => '',
          :text        => lyrics
        }

        # add lyrics
        tag << lyricsTag

        # apply changes
        tag.update!
         
        p "Wrote lyrics to " + filename
        return true
end

# Catch ctrl+c and exit displaying some statistics
numSuccess = 0
numFailed  = 0
trap("SIGINT") {
    puts "\n"
    if numSuccess > 0
        print "\nWrote lyrics for " + numSuccess.to_s + " songs. "
    else
        print "\nNo lyrics written. "
    end

    if numFailed > 0
        print "\nFailed writing lyrics on " + numFailed.to_s + " song."
    end
    puts "\nBye!"
    exit
}

# Connect to Amarok via dbus
bus = DBus::SessionBus.instance
amarok_service = bus.service("org.kde.amarok")
amarok_player = amarok_service.object("/Player")
amarok_player.introspect
amarok_player.default_iface = "org.freedesktop.MediaPlayer" 
#puts amarok_player.to_yaml

p "Registered to the amarok dbus service."
amarok_player.on_signal("TrackChange") do |u|
    p "The track changed lets look for lyrics..."

    # Give amarok some time to fetch the lyrics
    sleep(3)

    # write the lyrics to the tag
    if writeLyrics amarok_player
      numSuccess = numSuccess + 1
    else
      numFailed = numSuccess + 1
    end
end

loop = DBus::Main.new
loop << bus
loop.run


