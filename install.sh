sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install -y vim curl python-software-properties
sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update

sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-readline mysql-server-5.5 php5-mysql git-core php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

sudo a2enmod rewrite

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

sudo service apache2 restart

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Above is from original install.sh by Jeffrey Way. 
# The following complete the set-up for a CNP test/dev machine.

sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update

sudo rm -rf /vagrant/html
sudo chmod -R 777 /vagrant/cnp/app/storage

# Change both APACHE_RUN_USER and APACHE_RUN_GROUP to vagrant from www-data to avoid getting frequent permission-denied
# problems with the Laravel storage subdirectory
sed -i "s/www-data/vagrant/" /etc/apache2/envvars

if [ ! -e "/etc/apache2/sites-available/cnp.conf" ];
    then
    sudo cp /vagrant/FILES/cnp.conf /etc/apache2/sites-available
    sudo a2ensite cnp
    sudo service apache2 reload
fi

# Install and configure postgres and postgis
# 
sudo apt-get install -y postgresql-client-common postgresql postgresql-contrib php5-pgsql php5-dev
sudo apt-get install -y postgis postgresql-server-dev-9.1 postgresql-9.1-postgis
sudo apt-get install -y postgresql-9.1-postgis-scripts

echo 'Setting up database and GIS extensions'
sudo su postgres -c 'createuser -d -R -S vagrant'
sudo su postgres -c 'createdb cnp'
sudo su postgres -c 'psql -d cnp -c "CREATE EXTENSION postgis;"'
sudo su postgres -c 'psql -d cnp -c "CREATE EXTENSION postgis_topology;"'

# Install and configure queueing system and supervisor

sudo apt-get install -y beanstalkd supervisor

sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
sudo service beanstalkd start







