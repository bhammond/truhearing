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

