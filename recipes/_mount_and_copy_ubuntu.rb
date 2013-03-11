# Make sure it's unmounted before we possibly format it
directory node['ii-usb']['ubuntu-mountpoint']

mount node['ii-usb']['ubuntu-mountpoint'] do
  device node['ii-usb']['ubuntu-iso']['src']['cache']
  options 'loop'
  not_if "cat /proc/mounts | grep #{node['ii-usb']['ubuntu-mountpoint']}"
end

# on 12.04.2 (and later?).... the EFI directory is uppercase
ubuiso = search('ubuntu',"version:#{node['ii-usb']['ingredients']['ubuntu']['version']} AND arch:x86_64 flavor:desktop").first
efi_boot = Chef::VersionConstraint.new(">= 12.04.2").include?(ubuiso['semantic_version']) ?   '/EFI/BOOT' : '/efi/boot'

directory "#{node['ii-usb']['target-mountpoint']}#{efi_boot}" do
  recursive true
end

boot_files = Chef::VersionConstraint.new(">= 12.04.2").include?(ubuiso['semantic_version']) ? ['BOOTx64.EFI','grubx64.efi'] : ['bootx64.efi']
boot_files.each do |boot_file|
  file "#{node['ii-usb']['target-mountpoint']}#{efi_boot}/#{boot_file}" do
    content "#{node['ii-usb']['ubuntu-mountpoint']}#{efi_boot}/#{boot_file}"
    backup false
    provider Chef::Provider::File::Copy
  end
end

# execute "grub-install --boot-directory=#{node['ii-usb']['target-mountpoint']}/boot/grub/i386-pc #{node['ii-usb']['target-device']}" do
#   creates "#{node['ii-usb']['target-mountpoint']}/boot/grub/i386-pc/grubenv"
# end

['boot/grub/x86_64-efi','boot/grub','.disk'].each do |dir|
  directory "#{node['ii-usb']['target-mountpoint']}/#{dir}" do
    recursive true
  end
  Dir["#{node['ii-usb']['ubuntu-mountpoint']}/#{dir}/*"].each do |file_to_copy|
    next if file_to_copy =~ /.*grub.cfg$/ # omit grub.cfg
    afile = File.basename(file_to_copy)
    afile_src = File.join(node['ii-usb']['ubuntu-mountpoint'],dir,afile)
    afile_target = File.join(node['ii-usb']['target-mountpoint'],dir,afile)
    if File.file? afile_src
      file afile_target do
        backup false
        content afile_src
        provider Chef::Provider::File::Copy
      end
    end
  end
end

