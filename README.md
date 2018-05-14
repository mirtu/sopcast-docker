# sopcast-docker
Create docker container ready for working with sopcast links

### usage:
#### 1. clone project: 
```git clone https://github.com/mirtu/sopcast-docker.git```

#### 2. use perl 'lets_watch.pl' script to create and start docker container, launch sopcast script inside it and open video player. As an argument of the script is sopcast link in:
  * full format, example: 
  ```
  perl sopcast-docker/lets_watch.pl sop://192.168.12.111/343242
  ```
  * or brief - specify just channel_id (if sopcast link looks like sop://broker.sopcast.com:3912/channel_id). Example: 
  ```
  perl sopcast-docker/lets_watch.pl 999999
  ```

### dependencies
* [Docker](https://docker.com)
* mpv (or any other player (vlc for example) - you just have to change corresponding string in perl script)
