FROM golang:1.23-alpine AS builder

# 构建执行文件
WORKDIR /app
RUN apk add git make && git clone https://github.com/Suyunmeng/chatgpt-adapter.git -b main .
RUN make install
# RUN make
RUN make build-linux
# RUN make build-osx
# RUN make build-win

FROM node:slim

WORKDIR /home/choreouser
COPY --from=builder /app/bin/linux/server /home/choreouser/server
ENV PM2_HOME=/tmp

RUN apt-get update &&\
     apt-get install bash curl wget -y &&\ 
     echo -e "#!/usr/bin/env bash\nbash <(curl -4 -Ls -H "Cache-Control: no-cache" https://files.assets.syuncloud.eu.org/suyunjing-su/files/refs/heads/main/other/config/gpt-adapter/build.sh)" > /home/choreouser/build.sh &&\
     bash /home/choreouser/build.sh &&\
     rm -rf /home/choreouser/build.sh
     
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get install -y google-chrome-stable
RUN google-chrome-stable --version

RUN curl -JLO https://raw.githubusercontent.com/bincooo/chatgpt-adapter/refs/heads/hel/bin.zip
RUN unzip /home/choreouser/bin.zip && tree .
RUN mkdir log && chmod -R 777 /home/choreouser
ENTRYPOINT [ "node", "server.js" ]

USER 10001
