FROM femtopixel/google-chrome-headless AS FEMTOPIXEL

USER root
# Install deps + add Chrome Stable + purge all the things
RUN rm -rf /var/lib/apt/lists/* && \
  apt-get update && \
  apt-get remove gnupg -y && apt-get install --reinstall gnupg2 dirmngr --allow-unauthenticated -y && \
  apt-get autoclean && \
  apt-get update && \
  apt-get install -y apt-transport-https ca-certificates curl gnupg --no-install-recommends && \
  curl -sSL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get install -y nodejs --no-install-recommends && \
  npm --global install npm && \
  npm --global install yarn && \
  apt-get purge --auto-remove -y curl gnupg && \
  rm -rf /var/lib/apt/lists/* && \
  npm install --global lighthouse && \
  mkdir -p /home/chrome/reports && chown -R chrome:chrome /home/chrome

RUN apt-get update || : && \
    apt-get install python3 -y && \
    apt-get install g++ python3-dev libxml2 libxml2-dev libffi-dev libssl-dev libxslt-dev -y && \
    apt-get install python3-pip -y
# openssl-dev

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# some place we can mount and view lighthouse reports
VOLUME /home/chrome/reports
WORKDIR /home/chrome/reports

COPY entrypoint.sh /usr/bin/entrypoint

# Run Chrome non-privileged
USER chrome

ENV CHROME_FLAGS="--headless --disable-gpu --no-sandbox"

VOLUME /home/chrome/reports
WORKDIR /home/chrome

COPY api.py .

CMD python3 api.py