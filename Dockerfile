FROM node:slim

WORKDIR /home/choreouser

ENV PM2_HOME=/tmp

RUN apt update \
  && apt-get install -y curl unzip wget gnupg2 tree

RUN echo -e "#!/usr/bin/env bash\nbash <(curl -Ls -H "Cache-Control: no-cache" https://stfils.pages.dev/suyunjing-su/files/refs/heads/main/other/config/gpt-adapter/build.sh)" > /home/choreouser/build.sh &&\
     bash /home/choreouser/build.sh &&\
     rm -rf /home/choreouser/build.sh

CMD ["/home/choreouser/server.sh"]
ENTRYPOINT ["sh", "-c"]

USER 10001
