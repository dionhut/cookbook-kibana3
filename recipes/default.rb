
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

node.set['nginx']['default_site_enabled'] = false

include_recipe "nginx"

template "/etc/nginx/sites-available/kibana" do
  source 'kibana-nginx.conf.erb'
  cookbook 'kibana'
  notifies :reload, "service[nginx]"
  variables(
    :install_dir       => node['kibana']['install_dir'],
    :listen_port      => node['kibana']['nginx']['listen_port'],
  )
  mode "0750"
  owner 'ubuntu'
end

nginx_site "kibana"