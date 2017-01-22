FROM ubuntu:14.04

MAINTAINER version: 0.2

ENV USER            "bot"
ENV GROUP           "bot"
ENV TS3BOT_DIR      "/opt/tsbot"
ENV TS3_CLIENTDIR   "$TS3BOT_DIR/TeamSpeak3-Client-linux_amd64"
ENV YTDL_BIN        "/usr/local/bin/youtube-dl"
ENV YTDL_FILE       "https://yt-dl.org/downloads/latest/youtube-dl"
ENV TS3_CLIENT      "http://teamspeak.gameserver.gamed.de/ts3/releases/3.0.19.4/TeamSpeak3-Client-linux_amd64-3.0.19.4.run"
ENV BOT_URL         "https://www.sinusbot.com/dl/sinusbot-beta.tar.bz2"
ENV TERM            "xterm"

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN apt-get -q update && apt-get -q install -y \
sudo \
x11vnc \
xvfb \
libxcursor1 \
ca-certificates \
bzip2 \
wget \
curl \
libglib2.0-0 \
nano \
python 

RUN groupadd -g 3000 -r "$USER"
RUN useradd -u 3000 -r -g "$GROUP" -d "$TS3BOT_DIR" "$USER"

RUN wget -q -O "$YTDL_BIN" "$YTDL_FILE"
RUN chmod a+rx "$YTDL_BIN"

RUN mkdir -p "$TS3BOT_DIR" "$TS3_CLIENTDIR"
RUN wget -q -O - "$BOT_URL" | tar -xjf - -C "$TS3BOT_DIR"

RUN cp "$TS3BOT_DIR/config.ini.dist" "$TS3BOT_DIR/config.ini"

RUN sed -i "s|SampleInterval = .*|SampleInterval = 500|g" "$TS3BOT_DIR/config.ini"
RUN sed -i "s|TS3Path = .*|TS3Path = \"$TS3_CLIENTDIR/ts3client_linux_amd64\"|g" "$TS3BOT_DIR/config.ini"
RUN sed -i "s|YoutubeDLPath = .*|YoutubeDLPath = \"$YTDL_BIN\"|g" "$TS3BOT_DIR/config.ini"

RUN wget -q -O - "$TS3_CLIENT" | tail -c +25000 | tar xzf - -C "$TS3_CLIENTDIR"
RUN cp "$TS3BOT_DIR/plugin/libsoundbot_plugin.so" "$TS3_CLIENTDIR/plugins"

RUN chown -R "$USER":"$GROUP" "$TS3BOT_DIR"
RUN chmod 775 "$TS3BOT_DIR/sinusbot"


RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["$TS3BOT_DIR/data"]
EXPOSE 8087
ENTRYPOINT ["/entrypoint.sh"]
