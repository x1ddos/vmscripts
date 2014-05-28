#!/bin/bash

META_URL=http://metadata/computeMetadata/v1/instance/attributes

function get_file_from_meta {
    curl -s -H 'Metadata-Flavor: Google' $META_URL/$1 > $2
}


apt-get update
apt-get install -y nodejs ruby git mysql-client vim bzip2 nginx fcgiwrap
ln -s /usr/bin/nodejs /usr/bin/node
cd /tmp
curl http://registry.npmjs.org/npm/-/npm-1.4.7.tgz | tar xzf -
cd /tmp/package && node cli.js install -g -f
npm install -g forever grunt-cli bower
gem install --no-ri --no-rdoc compass

mkdir -p /apps/bin
useradd -d /apps -s /bin/bash apps
chown -R apps /apps

chmod +x /apps/bin/update.sh

chmod +x /apps/bin/github-push-to-deploy.js
echo 'www-data ALL=(ALL) NOPASSWD: /apps/bin/update.sh' >> /etc/sudoers

service nginx restart
sudo -u apps /apps/bin/update.sh
