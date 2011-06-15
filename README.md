This script will delete all lyrics (:USLT) tags from the current playing track
in Amarok 2 and writes a new one containing amaroks the cached lyrics.

The purpose is to display lyrics on an iPod (touch, whatever has a display and
supports this.

The script uses the http://id3lib-ruby.rubyforge.org/ library. 
Install like (example for Ubuntu):

  sudo aptitude install libid3-dev ruby-dev g++
  sudo gem install id3lib-ruby

It uses dbus to connect to amarok and therefore uses the ruby-dbus library:
  sudo aptitude install libdbus-ruby libdbus-ruby1.8 libglib2-ruby1.8

