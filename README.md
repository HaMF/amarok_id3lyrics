Purpose
=======
This script will delete all lyrics (:USLT) tags from the current playing track
in Amarok 2 and writes a new one containing amaroks the cached lyrics.

Unfortunately it turns out that it's quite impossible to accomplish with an 
Amarok 2 script due to limitations of the api. See
http://forum.kde.org/viewtopic.php?f=117&t=90708

The purpose is to display lyrics on an iPod (touch, whatever has a display and
supports this).


Warning
=======
This script modifies your mp3s (and only mp3s, it does nothing when it 
encounters an file with another extension as .mp3)!
It overwrites any lyrics tags that may be present in the file.

As I don't have a clue what I'm doing here: Use at your own risk.

Help
=======
Wanna help? I'd be glad if you fork the repository and correct the code as this 
is my very first ruby script and my first encounter with dbus.

Install
=======
The script uses http://id3lib-ruby.rubyforge.org/ to write the id3v2 tags and 
the ruby-dbus library (http://trac.luon.net/data/ruby-dbus/tutorial/index.html) 
to connect to amarok via dbus.


Install them  like (example for Ubuntu):

    sudo aptitude install libid3-dev ruby-dev g++ libdbus-ruby libdbus-ruby1.8 libglib2-ruby1.8
    sudo gem install id3lib-ruby
