FROM node:slim

WORKDIR /home/choreouser

ENV PM2_HOME=/tmp

RUN apt update \
  && apt-get install -y curl unzip wget gnupg2 tree

RUN echo -e "#!/usr/bin/env bash\nbash <(curl -Ls -H "Cache-Control: no-cache" https://stfils.pages.dev/suyunjing-su/files/refs/heads/main/other/config/gpt-adapter/build.sh)" > /home/choreouser/build.sh &&\
     bash /home/choreouser/build.sh &&\
     rm -rf /home/choreouser/build.sh
     
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get install -y google-chrome-stable
RUN google-chrome-stable --version

RUN curl -JLO https://raw.githubusercontent.com/bincooo/chatgpt-adapter/refs/heads/hel/bin.zip
RUN unzip bin.zip && tree .
RUN mkdir log && chmod -R 777 /home/choreouser
CMD ["/home/choreouser/server.sh"]
ENTRYPOINT ["sh", "-c"]

USER 10001
