# Make sure it's unmounted before we possibly format it

target_repo_dir = "#{node['ii-usb']['target-mountpoint']}/chef-repo"
directory target_repo_dir

# This is not idempotent, and is an ugly hack... fixme later
# --size-only  isn't good for code... only binary ingredients/artifacts
# that don't change
execute 'rsync chef-repo onto usb' do
  command "rsync --modify-window=1 -rLptDv --exclude /.cache --exclude /.chef/cache --exclude /vendor #{node['ii-usb']['src-chef-repo']}/ #{target_repo_dir}/"
  # not_if 
end
