# mueue
A BGM player.

## Getting Started
Install [VLC media player](http://www.videolan.org/vlc/).  
On Ubuntu:
```
sudo apt-get install vlc
```

Clone the repository and install dependencies.
```
git clone git@github.com:igjit/mueue.git
cd mueue/
bundle install
```

Setup the DB.
```
bin/rake db:migrate
```

Configure the application. Copy `settings.yml` to `settings.local.yml` and write your Google API key. (Ensure that you enable YouTube Data API for your project.)
```
cp config/settings.yml config/settings.local.yml
vi config/settings.local.yml
```

Start VLC and the application.
```
vlc --extraintf rc --rc-host localhost:4536
bin/rails server
```

If VLC failed to play a YouTube video, try to update `youtube.lua`.  
On Ubuntu:
```
sudo rm /usr/lib/vlc/lua/playlist/youtube.luac
sudo wget -O /usr/lib/vlc/lua/playlist/youtube.lua https://raw.githubusercontent.com/videolan/vlc/master/share/lua/playlist/youtube.lua
```

## License
[MIT License](http://www.opensource.org/licenses/MIT)
