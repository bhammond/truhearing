package "php5-pgsql" do
    action :install
end

package "postgresql-contrib" do
    action :install
end

package "postgresql-client-common" do
    action :install
end

package "postgresql-plpython-9.3" do
    action :install
end

package "smbfs" do
    action :install
end

package "php5-cli" do
    action :install
end

package "php5-curl" do
    action :install
end

package "php5-intl" do
    action :install
end

package "php5-mcrypt" do
    action :install
end

package "python-cjson" do
    action :install
end

package "cakephp-scripts" do
    action :install
end

execute "update-tzdata" do
  command "dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

file "/etc/timezone" do
  owner "root"
  group "root"
  mode "00644"
  content "US/Mountain"
  notifies :run, "execute[update-tzdata]"
end

package "tzdata" do
  action :install
end

pg_user "securetruhearing" do
    privileges :superuser => true, :createdb => true, :login => true
    password "tXTV2aYqmdc7"
end

pg_database "securetruhearing_sprint5" do
    owner "securetruhearing"
    encoding "utf8"
    template "template0"
    locale "en_US.UTF8"
end

pg_database_extensions "securetruhearing_sprint5" do
    languages ["plpgsql", "plpythonu"]
    extensions ["hstore"]
end

pg_database_extensions "postgres" do
    languages ["plpythonu"]
    extensions ["hstore"]
end

include_recipe "apache2"


web_app "t3" do
    server_name "t3.dev"
    server_aliases ["www.t3.dev"]
    docroot "/var/www/t3/src/t3/"
end

bash "add_custom_aliases" do
    user "root"
    cwd "/tmp"
    code <<-EOT
    echo "
alias t3='cd /var/www/t3/src/t3'
alias db='cd /var/www/t3/databaseScripts'
alias migrate='/var/www/t3/src/cake/console/cake migration'
alias migrate_up='/var/www/t3/src/cake/console/cake migration up'
alias migrate_down='/var/www/t3/src/cake/console/cake migration down'
alias migrate_add='/var/www/t3/src/cake/console/cake migration add'

alias ..='cd ..'
alias ...='cd ../..'

alias ls='ls -alF'
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls
    " >> $HOME/.bashrc
    EOT
end

file "/home/vagrant/.vimrc" do
  owner "vagrant"
  group "vagrant"
  mode "0777"
  action :create_if_missing
  content <<-EOT
set backspace=indent,eol,start
set nocompatible
EOT
end

bash "run database" do
    user "root"
    cwd "/var/www/t3/databaseScripts"
    code <<-EOT
        ./refreshdatabase.sh
        echo "Database has been refreshed."
    EOT
end

bash "copy Lanes database scripts to tmp dir" do
    user "root"
    cwd "/var/www/t3_db"
    code <<-EOT
        cp /var/www/t3_db/install_db_scripts.bash /tmp
        chmod 777 /tmp/install_db_scripts.bash
    EOT
end

bash "install lanes scripts" do
    user "postgres"
    cwd "/tmp"
    code <<-EOT
        ./install_db_scripts.bash securetruhearing_sprint5
        echo "Installed Lanes Database scripts"
    EOT
end

