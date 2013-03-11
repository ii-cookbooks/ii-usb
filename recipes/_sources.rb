directory Chef::Config[:file_cache_path]

node['ii-usb']['ingredients'].each do |data_bag,attrs|
  # getting all the the artifacts may be expensive
  # only retrieve if it hasn't been set in a role
  if not node['ii-usb']['ingredients'][data_bag]['version']
    all_artifacts = search(data_bag,"*:*")
    node.default['ii-usb']['ingredients'][data_bag]['version']=all_artifacts.map{|v|
      v['version']}.flatten.uniq.sort.last
  end
  search(data_bag,"version:#{node['fileserver']['ingredients'][data_bag]['version']}").each do |ing|

    cache_file = File.join(Chef::Config[:file_cache_path], ing['filename'])
    # Populate the cache and checksums
    chksumf="#{cache_file}.checksum"
    rf = remote_file cache_file do
      source ing['source']
      checksum ing['checksum']
      not_if do
        (::File.exists? chksumf) && (open(chksumf).read == ing['checksum'])
      end
    end
    rf.run_action :create

    cs=file "#{cache_file}.checksum" do
      content ing['checksum']
    end
    cs.run_action :create
  end
end


# go ahead and point to the version of ubuntu we want
ubiso = search('ubuntu',"version:#{node['ii-usb']['ingredients']['ubuntu']['version']} AND arch:x86_64 flavor:desktop").first
node.default['ii-usb']['ubuntu-iso']['src'] = {
  'url' => ubiso['source'],
  'checksum' => ubiso['checksum'],
  'cache' => File.join(Chef::Config[:file_cache_path],ubiso['filename'])
}

# go ahead and point to the version of ubuntu we want
chef_client = search('chef',"version:#{node['ii-usb']['ingredients']['chef']['version']} AND arch:x86_64 AND os_ubuntu:12.04").first
node.default['ii-usb']['chef-deb']['src'] = {
  'url' => chef_client['source'],
  'checksum' => chef_client['checksum'],
  'cache' => File.join(Chef::Config[:file_cache_path],chef_client['filename'])
}

# used in template
node.default['chef_client']['package']['filename'] = chef_client['filename']
