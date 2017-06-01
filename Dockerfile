FROM resin/rpi-raspbian:jessie

RUN apt-get update \
    && apt-get install -y binutils libexpat1-dev libc6 wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PMS_VERSION 1.7.2.3878-8088811b8

RUN wget https://downloads.plex.tv/plex-media-server/${PMS_VERSION}/plexmediaserver-ros6-binaries-annapurna_${PMS_VERSION}_armel.deb -O plex.deb \
  && mkdir -p /usr/lib/plexmediaserver \
  && ar p plex.deb data.tar.gz | tar -xzf - -C /usr/lib/plexmediaserver/ --strip-components=4 ./apps/plexmediaserver-annapurna/Binaries \
  && rm /usr/lib/plexmediaserver/config.xml \
  && rm plex.deb

COPY scripts/start_pms /usr/sbin/start_pms

RUN chmod +x /usr/sbin/start_pms

CMD ["sh", "-c", "/usr/sbin/start_pms"] 
