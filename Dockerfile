FROM ubuntu

# Install the dependencies
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y libstdc++5:i386 && \
    apt-get install -y wget

WORKDIR /opt

# Install sopcast
RUN wget http://download.sopcast.com/download/sp-auth.tgz && \
    tar -xzf sp-auth.tgz

# make image lightweight
RUN apt-get remove -y wget && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/opt/sp-auth/sp-sc-auth"]
