FROM --platform=linux/amd64 ubuntu:22.04

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install \
    wget \
    gnupg

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg 
RUN sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 --no-install-recommends 
RUN rm -rf /var/lib/apt/lists/* 
RUN groupadd -r pptruser && useradd -rm -g pptruser -G audio,video pptruser

USER pptruser

# CMD ["google-chrome-stable --headless --dump-dom https://icanhazip.com --no-sandbox"]
