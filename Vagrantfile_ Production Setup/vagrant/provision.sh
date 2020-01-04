#! /bin/bash     
base_dir="/vagrant"
. "$base_dir/utils.sh"

apt-get update
apt-get upgrade -y
apt-get install -y git

#install python 3
apt-get install -y python3-dev
apt-get install -y build-essential python3-setuptools python3-pip libffi-dev libssl-dev  python-pip
apt-get install -y npm
pip3 install ansible


#install mariadb and configure
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.ubuntu-tw.org/mirror/mariadb/repo/10.3/ubuntu xenial main'
apt-get upgrade -y
echo "mariadb-server-10.3 mysql-server/root_password password $(getProperty mariadb.password rand0m123)" > /tmp/selections
echo "mariadb-server-10.3 mysql-server/root_password_again password $(getProperty mariadb.password rand0m123)" >> /tmp/selections
debconf-set-selections  /tmp/selections
apt-get install mariadb-server-10.3 -y
apt-get install libmysqlclient-dev -y
sed '/\[mysqld\]/a character-set-client-handshake = FALSE\ncharacter-set-server = utf8mb4\ncollation-server = utf8mb4_unicode_ci'  /etc/mysql/my.cnf| sed '/\[mysql\]/ a default-character-set = utf8mb4 ' > /tmp/my.cnf
mv /tmp/my.cnf /etc/mysql/my.cnf 
systemctl restart mariadb
systemctl enable mariadb


#install ngnix redis nodejs and yarn
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

apt-get install -y redis-server 
systemctl start redis-server
systemctl enable redis-server

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update 
apt-get install -y yarn


#install wkhtmltopdf
apt-get install -y libxrender1 libxext6 xfonts-75dpi xfonts-base
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar -xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /opt
sudo ln -s /opt/wkhtmltox/bin/wkhtmltopdf /usr/bin/wkhtmltopdf
sudo ln -s /opt/wkhtmltox/bin/wkhtmltoimage /usr/bin/wkhtmltoimage


#create bench user and setup frappe and erpnext with that user
groupadd bench
useradd bench  -m -d /opt/bench -g bench -G sudo


#create frappe user and setup frappe and erpnext with that user
echo "bench:$(getProperty bench.password bench)" | chpasswd
su - bench -c /vagrant/bench_provision.sh 
su - bench -c /vagrant/bench_production.sh

