FROM phusion/baseimage:focal-1.2.0

# Install dependencies:
RUN apt-get update \
 && apt-get install -y \
    bash curl sudo wget \
	python-is-python3 \
    python3 unzip sed unrar \
    python3-pip p7zip-full git \
    systemd golang \
 && pip3 install requests setuptools pynzbget chardet six guessit
 
RUN pip3 install apprise==0.9.7

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Clean up APT:
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set work dir:
WORKDIR /home

# Install NZBGET and gclone:
RUN wget https://nzbget.net/download/nzbget-latest-bin-linux.run \
 && bash nzbget-latest-bin-linux.run \
 && curl -s https://raw.githubusercontent.com/oneindex/script/master/gclone.sh | sudo bash

# Create required dirs:
RUN mkdir -p /home/nzbget/maindir/ \
 && mkdir -p /home/.config/rclone/

# Copy files:
COPY start /home/
COPY gclone_pp.py /home/nzbget/scripts/
COPY ping.py /home/
COPY accounts/* /home/accounts/
RUN git clone https://github.com/nzbget/VideoSort.git /home/nzbget/scripts/Videosort

# Run NZBGET:
CMD bash /home/start
