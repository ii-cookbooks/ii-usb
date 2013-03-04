directory Chef::Config[:file_cache_path]
#['ubuntu-iso','chef-deb'].each do |rf|
['ubuntu-iso'].each do |rf|
  remote_file node['ii-usb'][rf]['src']['cache'] do
    source node['ii-usb'][rf]['src']['url']
    checksum node['ii-usb'][rf]['src']['checksum']
    backup false
    not_if {File.exists? node['ii-usb'][rf]['src']['cache']}
  end
end

cc = search('chef',"*:*")
node.normal['chef_client']['version']=cc.map{|v| v['version']}.flatten.uniq.sort.last
search_string = "os_#{node.platform}:#{node.platform_version} AND version:#{node['chef_client']['version']} AND arch:#{node.kernel.machine}"
chef_package = search('chef',search_string).first
node.normal['chef_client']['package'] = chef_package

chef_package_cached = File.join(Chef::Config[:file_cache_path],chef_package['filename'])
remote_file chef_package_cached do
  source chef_package['source']
  checksum chef_package['checksum']
  backup false
  not_if {File.exists? chef_package_cached}
end
