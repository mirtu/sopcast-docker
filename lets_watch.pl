#!/usr/bin/perl
# Create docker container with sopcast-script, ready for working with sopcast links
#
# See usage
#

# Parse command line arguments - get channel id or url
    my $SOPCAST_BASE_URL="sop://broker.sopcast.com:3912/";
    my $channel=shift;
    usage() unless $channel;
    my $sopURL= (channel=~/^\d+$/) ? "$SOPCAST_BASE_URL$channel" : $channel;

# Internal sopcast port (in container)
    my $SOPCAST_INTERNAL_PORT=31000;

# Command to check if port is free. You can use nc insead
    my $CHECK_PORT_COMMAND="sudo netstat -an | grep _PORT_ | grep LISTEN";

# Docker image & container names
    my $DOCKER_NAME="sopcast";
    my $DOCKER_CONTAINER_NAME="sopcast_cnt";

# Command - checking eistance of our docker image
    my $CHECK_DOCKER_IMAGE_EXISTS="sudo docker images | grep \"$DOCKER_NAME\"";

# Command - building image
    my $DOCKER_IMAGE_BUILD="sudo docker build -t $DOCKER_NAME .";

# Command - start our docker image
    my $DOCKER_IMAGE_RUN="sudo docker run --rm --name $DOCKER_CONTAINER_NAME -p _PORT_:30000 $DOCKER_NAME";

# Command to check if container successfully started
    my $CHECK_CONTAINER_STARTED="sudo docker ps | grep $DOCKER_CONTAINER_NAME";


my $cmd, $rez;
# Determine first free port (from 30000 till 40000)
    print "\nSearching for free port\n";
    my $port=30000;
    while (1)
    {
        $cmd=$CHECK_PORT_COMMAND;
        $cmd=~s/_PORT_/$port/;
        $rez=`$cmd`;
        last unless $rez;
        die "Something wrong with port check!\n" if $port>40000;
        $port++;
    }
    print "port $port is free. Will use it!\n";
    
# Create docker image if it does not exist
    print "\nBuilding the image\n";
    $rez=`$CHECK_DOCKER_IMAGE_EXISTS`;
    `$DOCKER_IMAGE_BUILD` unless ($rez);
    $rez=`$CHECK_DOCKER_IMAGE_EXISTS`;
    die "Can not build docker image!\n" unless $rez;
    print "it seems, container has built successfully\n";

# Start docker container
    print "\nStarting the container\n";
    die "container is already running" if `$CHECK_CONTAINER_STARTED`;
    $cmd=$DOCKER_IMAGE_RUN;
    $cmd=~s/_PORT_/$port/;
    $cmd="$cmd $sopURL $SOPCAST_INTERNAL_PORT 30000 &";
    print "exec cmd: $cmd\n";
    system ($cmd);
    sleep 5;
    print "Check container with: '$CHECK_CONTAINER_STARTED'\n";
    $rez=`$CHECK_CONTAINER_STARTED`;
    die "container failed to start\n" unless $rez;
    
# sleep a bit and start mpv (vlc)
    sleep 5;
    print "\n\nOK. start VIDEO PLAYER --------------------------\n\n";
    # Replace mpv with corresponding video player, ex. 
    # `vlc http://localhost:$port/tv.asf`;
    `mpv http://localhost:$port/tv.asf`;
    

######################
sub usage
{
    die qq#
Wrong usage. Use: $0 {URL | channel_id}
    Where   URL - sopcast url (eq. sop://broker.sopcast.com:3912/XXXXXX)
            channel_id - number of channel ( if link looks like sop://broker.sopcast.com:3912/channel_id )
#;
}
