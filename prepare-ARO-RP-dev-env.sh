#!/bin/bash

cd $PWD; /usr/bin/wget https://go.dev/dl/go1.17.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $PWD/go1.17.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
/usr/bin/echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo /usr/bin/yum install -y python36 vim python3-setuptools git gcc jq
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

/usr/bin/echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

sudo /usr/bin/yum install -y azure-cli
sudo /usr/bin/yum install -y gpgme-devel libassuan-devel openssl

sudo yum install -y yum-utils; sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

docker ps

/usr/bin/az login

cd $PWD; /usr/bin/git clone https://github.com/Azure/ARO-RP.git -b master
cd $PWD/ARO-RP

/usr/bin/make az

# grep -q 'dev_sources' ~/.azure/config || cat >>~/.azure/config <<EOF
SECRET_SA_ACCOUNT_NAME=rharosecretsdev /usr/bin/make secrets

/usr/bin/cp env.example env
echo "" >> env
echo "export RP_MODE=development" >> env
echo "export USER=srini" >> env
