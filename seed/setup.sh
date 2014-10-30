#!/bin/bash

if [ $(grep -c '^deb http://pkg.obiba.org unstable/' /etc/apt/sources.list) -eq 0 ];
then
	wget -q -O - http://pkg.obiba.org/obiba.org.key | sudo apt-key add -
	sudo sh -c 'echo "deb http://pkg.obiba.org unstable/" >> /etc/apt/sources.list'
fi

sudo apt-get update
sudo apt-get install -y opal-python-client mica-python-client