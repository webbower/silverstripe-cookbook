#
# Cookbook Name:: silverstripe_cookbook
# Recipe:: default
#
# Copyright (C) 2014 Matt Bower
# 
# All rights reserved - Do Not Redistribute
#

# Auto-disable default Apache site
node.default['apache']['default_site_enabled'] = false

# System MySQL connection info
mysql_connection_info = {
  :host   => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# App MySQL user connection info
silverstripe_db_connection_info = {
  :host   => 'localhost',
  :username => node['silverstripe']['db_user'],
  :password => node['silverstripe']['db_pass']
}

include_recipe "apt"
include_recipe "openssl"
include_recipe "php::package"
include_recipe "php::module_gd"
include_recipe "php::module_mysql"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_headers"
include_recipe "database::mysql"
include_recipe "mysql::server"

# Add vagrant user to www-data
group "www-data" do
  append true
  members "vagrant"
end

# Set up php.ini file
cookbook_file "/etc/php5/apache2/php.ini" do
  source "php.ini"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[apache2]"
end

# TODO: Necessary?
# Create webroot folder if it doesn't exist
directory node['silverstripe']['web_root'] do
  action :create
  # mode "0755"
  # owner ""
end

# Create app apache conf file
template "/etc/apache2/sites-available/silverstripe" do
  source "silverstripe.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[apache2]"
end

# Enable app site conf
apache_site "silverstripe" do
  enable true
  notifies :restart, "service[apache2]"
end

### Database

# Create app DB user
database_user node['silverstripe']['db_user'] do
  connection mysql_connection_info
  password   node['silverstripe']['db_pass']
  provider   Chef::Provider::Database::MysqlUser
  action     :create
end

# Grant perms to app DB user
mysql_database_user node['silverstripe']['db_user'] do
  connection    mysql_connection_info
  database_name node['silverstripe']['db_name']
  password      node['silverstripe']['db_pass']
  action        :grant
end

# Create app DB
mysql_database node['silverstripe']['db_name'] do
  connection mysql_connection_info
  action :create
end

# Load DB dump if one is set
if node['silverstripe']['db_dump']
  mysql_database node['silverstripe']['db_name'] do
    connection silverstripe_db_connection_info
    sql { ::File.open("/vagrant/#{node['silverstripe']['db_dump']}").read }
    action :query
  end
end
