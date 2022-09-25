## Copyright 2022 Gabriel Mandatti
## Licensed under the Apache License, Version 2.0 (the "License");

FROM alpine:latest
# Maintainer's Github
LABEL maintainer="github.com/mandatti"

# Set the environment value for FXServer's version
ENV   FXSERVER_VER="5901-5db768d8bbb973ba27c81e424aea2910144a3100"

# Exposing ports
# 40120 - txAdmin
# 30120 - FXServer
# 30110 - FiveM Servers Heartbeat
EXPOSE 40120
EXPOSE 30120
EXPOSE 30110

# Installing nedded software and libs
RUN apk add --no-cache libgcc libstdc++ curl ca-certificates npm unzip wget
# Creating FiveM directory inside the container
RUN mkdir /opt/FiveM
# Get latest txAdmin version and saving it into a zip file
RUN LOCATION=$(curl -s https://api.github.com/repos/tabarra/txAdmin/releases/latest \
| grep "tag_name" \
| awk '{print "https://github.com/tabarra/txAdmin/archive/" substr($2, 2, length($2)-3) ".zip"}') \
; curl -L -o monitor.zip $LOCATION
# Get FXServer version using pre-defined ENV value
RUN curl https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FXSERVER_VER}/fx.tar.xz | tar xJ -C /opt/FiveM
# Extracting txAdmin into FXServer's directory
RUN unzip -o monitor.zip -d /opt/FiveM/alpine/opt/cfx-server/citizen/system_resources/monitor
# Installing FXServer
RUN npm install -g fvm-installer
# Setting Container's Entrypoint
ENTRYPOINT ["sh", "/opt/FiveM/run.sh"]