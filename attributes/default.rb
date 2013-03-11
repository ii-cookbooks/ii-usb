# default['ii-usb']['ubuntu-iso']['src'] = {
#   'url' => 'http://releases.ubuntu.com/precise/ubuntu-12.04.1-desktop-amd64.iso',
#   'checksum' => 'd942fd8a056f635062899b58e9e875eb89eaec9be09a0fefa713f4e162bb647e',
#   'cache' => File.join(Chef::Config[:file_cache_path],'ubuntu-12.04.1-desktop-amd64.iso')
# }

# default['ii-usb']['chef-deb']['src'] = {
#   'url' => 'https://opscode-omnitruck-release.s3.amazonaws.com/ubuntu/11.04/x86_64/chef_10.16.2-1.ubuntu.11.04_amd64.deb',
#   'checksum' => '52a9c858cf11d6d815e419906d7a7debf3460973d3967f9c0ff7a4f9fbac5afd',
#   'cache' => File.join(Chef::Config[:file_cache_path],'chef_10.16.2-1.ubuntu.11.04_amd64.deb')
# }

default['ii-usb']['target-device']='/dev/null'
default['ii-usb']['target-mountpoint']='/media/ii-usb'
default['ii-usb']['ubuntu-mountpoint']='/media/ubuntu-iso'
default['ii-usb']['volume-name']='ii-usb'
# -1 means as big as possible, otherwise positive integers in MB
# -1 also means no restore partition
default['ii-usb']['partition-size']='-1'
  

default['ii-usb']['target-user']['login']='user'
default['ii-usb']['target-user']['password']='user'
default['ii-usb']['chvt']['sleep']='10'


default['ii-usb']['ingredients']['ubuntu']['desc']='Ubuntu ISO'
default['ii-usb']['ingredients']['windows']['desc']='Windows ISO'
default['ii-usb']['ingredients']['virtualbox']['desc']='Virtualbox'
default['ii-usb']['ingredients']['chef']['desc']='Chef Client'
default['ii-usb']['ingredients']['chef_server']['desc']='Chef Server'
default['ii-usb']['ingredients']['vagrant']['desc']='Vagrant'
default['ii-usb']['ingredients']['emacs']['desc']='Emacs'
default['ii-usb']['ingredients']['vim']['desc']='Vim'
default['ii-usb']['ingredients']['sublimetext']['desc']='Sublime Text'
default['ii-usb']['ingredients']['git']['desc']='Git'

# mac versions of git are usually newer, pin at most recent release of both
default['ii-usb']['ingredients']['git']['version']='1.8.1.2'
# I'm not ready for newer versions of Ubuntu... yet
default['ii-usb']['ingredients']['ubuntu']['version']='12.04.2'
# If I want to list multiple version of windows, this could get interesting
# Let's focus on 2008r2 for now
default['ii-usb']['ingredients']['windows']['version']='7601'
