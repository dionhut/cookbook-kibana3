
directory node['kibana3']['install_dir'] do
  recursive true
  mode "0755"
end

include_recipe 'ark::default'

ark 'kibana3' do
  url node['kibana3']['install_zip_url']
  path node['kibana3']['install_dir']
  action :put
end

template "#{node['kibana3']['install_dir']}/kibana3/config.js" do
  source 'config.js.erb'
  cookbook 'kibana3'
  variables(
    :es_host      => node['kibana3']['es_host'],
  )
  mode "0755"
end

package "nginx" do
  action :install
end

template "/etc/nginx/sites-available/default" do
  source 'kibana-nginx.conf.erb'
  cookbook 'kibana3'
  variables(
    :install_dir       => node['kibana3']['install_dir'],
    :listen_port      => node['kibana3']['nginx']['listen_port'],
  )
  mode "0755"
end

service "nginx" do
  action :restart
end