
directory node['kibana3']['install_dir'] do
  recursive true
  owner 'ubuntu'
  mode "0750"
end

include_recipe 'ark::default'

ark 'kibana' do
  url node['kibana3']['install_zip_url']
  path node['kibana3']['install_dir']
  owner 'ubuntu'
  action :put
end

template "#{node['kibana3']['install_dir']}/config.js" do
  source 'config.js.erb'
  cookbook 'kibana3'
  mode "0750"
  owner 'ubuntu'
end

apt_package "nginx" do
  action :install
end

template "/etc/nginx/sites-available/default" do
  source 'kibana-nginx.conf.erb'
  cookbook 'kibana3'
  notifies :reload, "service[nginx]"
  variables(
    :install_dir       => node['kibana3']['install_dir'],
    :listen_port      => node['kibana3']['nginx']['listen_port'],
  )
  mode "0750"
  owner 'ubuntu'
end
