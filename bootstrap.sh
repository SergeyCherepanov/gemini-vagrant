#!/bin/bash
DIR=$(dirname $(readlink -f $0))

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

sudo apt-get update
# update packages
sudo apt-get install -q -y curl build-essential chrpath libssl-dev libxft-dev \
 libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev

# install node.js
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs

# Install PhantomJS
PHANTOMJS_DIR="/usr/lib/phantomjs"
mkdir -p ${PHANTOMJS_DIR}
echo "Installing PhantomJS to: "${PHANTOMJS_DIR}
wget "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2" -O "phantomjs.tar.bz2"
tar -xjf phantomjs.tar.bz2 -C /tmp/
mv /tmp/phantomjs-1.9.8-linux-x86_64 ${PHANTOMJS_DIR}
rm phantomjs.tar.bz2
echo "PhantomJS Installed Successfully"

npm install -g gemini

# clean up
for SERVICE in "chef-client" "puppet"; do
    /usr/sbin/update-rc.d -f $SERVICE remove
    rm /etc/init.d/$SERVICE
    pkill -9 -f $SERVICE
done
sudo apt-get autoremove -y chef puppet
sudo apt-get clean
sudo rm -f \
  /home/vagrant/*.sh       \
  /home/vagrant/.vbox_*    \
  /home/vagrant/.veewee_*  \
  /var/log/messages   \
  /var/log/lastlog    \
  /var/log/auth.log   \
  /var/log/syslog     \
  /var/log/daemon.log \
  /var/log/docker.log
sudo rm -rf  \
  /var/log/chef       \
  /var/chef           \
  /var/lib/puppet

rm -f /home/vagrant/.bash_history  /var/mail/vagrant

sudo cat <<HOSTNAME > /etc/hostname
localhost
HOSTNAME

cat <<EOF  >> /home/vagrant/.bashrc
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export LC_CTYPE=C.UTF-8
lsb_release -a
EOF

