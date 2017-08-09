FROM resin/rpi-raspbian:jessie

RUN apt-get update \
    && apt-get install -y binutils libexpat1-dev libc6 wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG PLEX_TOKEN

RUN wget "https://plex.tv/downloads/latest/1?channel=8&build=linux-annapurnatrans-arm7&distro=readynas6&X-Plex-Token=${PLEX_TOKEN}" -O plex.deb \
  && mkdir -p /usr/lib/plexmediaserver \
  && ar p plex.deb data.tar.gz | tar -xzf - -C /usr/lib/plexmediaserver/ --strip-components=4 ./apps/plexmediaserver-annapurna/Binaries \
  && rm /usr/lib/plexmediaserver/config.xml \
  && rm plex.deb

COPY scripts/start_pms /usr/sbin/start_pms

RUN chmod +x /usr/sbin/start_pms

CMD ["sh", "-c", "/usr/sbin/start_pms"] 
