FROM debian:jessie

MAINTAINER version: 0.1

ENV USER            "bot"
ENV GROUP           "bot"
ENV TS3BOT_DIR      "/opt/ts3bot"
ENV TS3_CLIENTDIR   "$TS3BOT_DIR/TeamSpeak3-Client-linux_amd64"
ENV YTDL_BIN        "/usr/local/bin/youtube-dl"
ENV TS3_CLIENT      "http://dl.4players.de/ts/releases/3.0.19.4/TeamSpeak3-Client-linux_amd64-3.0.19.4.run"
ENV BOT_URL         "https://www.sinusbot.com/pre/sinusbot-0.9.12.3-36fce3c.tar.bz2"
ENV TERM            "xterm"

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN echo "Updating&Installing Packages"
RUN apt-get -q update && apt-get -q install -y sudo x11vnc xvfb libxcursor1 ca-certificates bzip2 wget curl libglib2.0-0 nano python

RUN echo "Adding user $USER:$GROUP -> $TS3BOT_DIR"
RUN groupadd -g 3000 -r "$USER"
RUN useradd -u 3000 -r -g "$GROUP" -d "$TS3BOT_DIR" "$USER"

RUN echo "Creating Folders -> $TS3BOT_DIR && $TS3_CLIENTDIR"
RUN mkdir -p "$TS3BOT_DIR" "$TS3_CLIENTDIR"

RUN echo "Downloading SinusBot"
RUN wget -q -O - "$BOT_URL" | tar -xjf - -C "$TS3BOT_DIR"

RUN echo "Setting config file Sinusbot"
RUN cp "$TS3BOT_DIR/config.ini.dist" "$TS3BOT_DIR/config.ini"

RUN echo "Setting SampleInterval to 500 preventing weird delays"
RUN sed -i "s|SampleInterval = .*|SampleInterval = \"500\"|g" "$TS3BOT_DIR/config.ini"

RUN echo "Setting TS3 Client Path"
RUN sed -i "s|TS3Path = .*|TS3Path = \"$TS3_CLIENTDIR/ts3client_linux_amd64\"|g" "$TS3BOT_DIR/config.ini"

RUN echo "Setting YTDL_BIN Path"
RUN sed -i "s|YoutubeDLPath = .*|YoutubeDLPath = \"$YTDL_BIN\"|g" "$TS3BOT_DIR/config.ini"

RUN echo "Downloading TS3 Client"
RUN wget -q -O - "$TS3_CLIENT" | tail -c +25000 | tar xzf - -C "$TS3_CLIENTDIR"

RUN echo "Installing Teamspeak Plugin"
RUN cp "$TS3BOT_DIR/plugin/libsoundbot_plugin.so" "$TS3_CLIENTDIR/plugins"

RUN echo "Installing yt-dl"
RUN wget -q -O "$YTDL_BIN" "https://github.com/rg3/youtube-dl/releases/download/2016.08.28/youtube-dl"

RUN echo "setting permissions yt-dl"
RUN chmod 755 "$YTDL_BIN"

RUN echo "Setting permissions $TS3BOT_DIR to $USER"
RUN chown -R "$USER":"$GROUP" "$TS3BOT_DIR"

RUN echo "Grant execute access to $USER"
RUN chmod 775 "$TS3BOT_DIR/sinusbot"

RUN echo "Cleaning up tmp files"
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["$TS3BOT_DIR/data"]

EXPOSE 8087

ENTRYPOINT ["/entrypoint.sh"]
