require 'rubygems'
require 'id3lib'
require 'dbus'

# Connect to Amarok via dbus
bus = DBus::SessionBus.instance
amarok_service = bus.service("org.kde.amarok")
amarok_player = amarok_service.object("/Player")
amarok_player.introspect
amarok_player.default_iface = "org.freedesktop.MediaPlayer" 
#puts amarok_player.to_yaml

# get the current songs metadata
metadata = amarok_player.GetMetadata

# extract lyrics
p lyrics = metadata[lyrics]
# extract filname
p filename = metadata[locatioin]

# Load a tag from a file
tag = ID3Lib::Tag.new(location)

# Get the number of frames
tag.length  #=> 7

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
