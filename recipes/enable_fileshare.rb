#
# Cookbook Name:: fileshare
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Removes the default website.
include_recipe 'iis::remove_default_site'

# Creates the default directory for the software repo
directory node[:fileshare][:repopath] do
	action :create
end

# Creates sub-directories, defined in the attributes\default.rb file
node[:directories][:add].each do |subdir|
	directory subdir do
		path "#{node[:fileshare][:repopath]}\\#{subdir}"
		action :create
	end
end

# Creates the logfile directory.
directory node[:fileshare][:logpath] do
  	action :create
end

# Creates a new application pool
iis_pool node[:fileshare][:name] do
	runtime_version node[:fileshare][:dotnet]
	pipeline_mode :Integrated
	pool_identity :ApplicationPoolIdentity
	action :add
end

# Creates a new website
iis_site node[:fileshare][:name] do
	path node[:fileshare][:repopath]
	log_directory node[:fileshare][:logpath]
	application_pool node[:fileshare][:name]
	bindings node[:fileshare][:hostheader]
	action [:add,:start] 
end

# Creates web.config file from template, setting up directory browsing.
template 'D:\softwarerepo\web.config' do
	path "#{node[:fileshare][:repopath]}\\web.config"
	source 'web.config.erb'
end

# Sets Hidden file attribute on web.config too prevent it appearing in Directory-Browse
powershell_script 'Set hidden attribute on web.config file' do
	code <<-EOH
	$file = get-childitem "#{node[:fileshare][:repopath]}\\web.config" -Hidden
	$file.attributes="Hidden"
	EOH
	guard_interpreter
	not_if 'Test-Path "#{node[:fileshare][:repopath]}\\web.config"'
end