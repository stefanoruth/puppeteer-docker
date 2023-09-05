FROM ubuntu:22.04

ENV NODE_VERSION v18.13.0
ENV YARN_VERSION v1.22.19
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install \
    curl \
    wget \
    gnupg

# Install Yarn
RUN mkdir /opt/yarn &&\
    curl -OLSs https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz &&\
    tar xzf yarn-${YARN_VERSION}.tar.gz -C /opt/yarn &&\
    ln -s /opt/yarn/yarn-${YARN_VERSION} /opt/yarn/current &&\
    ln -s /opt/yarn/current/bin/yarn /bin/yarn &&\
    rm yarn-${YARN_VERSION}.tar.gz

# Install NodeJS
RUN mkdir /opt/nodejs &&\
    curl -OLSs https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz &&\
    tar xzf node-${NODE_VERSION}-linux-x64.tar.gz -C /opt/nodejs &&\
    ln -s /opt/nodejs/node-${NODE_VERSION}-linux-x64 /opt/nodejs/current &&\
    ln -s /opt/nodejs/current/bin/node /bin/node &&\
    rm node-${NODE_VERSION}-linux-x64.tar.gz

RUN echo "node $(node -v)\nyarn $(yarn -v)\ncache $(yarn cache dir)"

# Install Puppeteer
ENV PUPPETEER_SKIP_DOWNLOAD true
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg &&\
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' &&\
    apt-get update &&\
    apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 --no-install-recommends &&\
    rm -rf /var/lib/apt/lists/* 


# CMD ["google-chrome-stable --headless --dump-dom https://icanhazip.com --no-sandbox"]

WORKDIR /code

COPY . .

RUN yarn install


# RUN useradd dev -d /code -s /bin/bash && echo "dev:saterist" | chpasswd && adduser dev sudo

# RUN chown -R dev:dev /code && chmod 755 /code
# RUN chmod -R o+rwx node_modules/puppeteer/.local-chromium

RUN groupadd -r dev
RUN useradd -r -g dev -G audio,video dev
RUN mkdir -p /home/dev
RUN chown -R dev:dev /home/dev
RUN chown -R dev:dev /code

USER dev