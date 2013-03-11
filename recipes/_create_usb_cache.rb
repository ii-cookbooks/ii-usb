usb_cache_dir = "#{node['ii-usb']['target-mountpoint']}/cache"
directory usb_cache_dir

# This is not idempotent, and is an ugly hack... fixme later
execute 'rsync cache onto usb' do
  command "rsync --modify-window=1 -rLptDv #{node['ii-usb']['src-chef-repo']}/.chef/cache/ #{usb_cache_dir}/"
  # not_if 
end

# ['ubuntu-iso'].each do |cf|
#   target_file = File.join(node['ii-usb']['target-mountpoint'],'cache',
#     File.basename(node['ii-usb'][cf]['src']['cache']))
#   file target_file do
#     content node['ii-usb'][cf]['src']['cache']
#     provider Chef::Provider::File::Copy
#     backup false
#     not_if {File.file?(target_file) && File.size(target_file) > 10*100*100 }
#   end
# end
