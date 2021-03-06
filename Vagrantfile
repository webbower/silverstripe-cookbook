Vagrant.configure('2') do |config|
  # Plugin-specific configurations

  # Detects vagrant-cachier plugin
  if Vagrant.has_plugin?('vagrant-cachier')
    puts 'INFO:  Vagrant-cachier plugin detected. Optimizing caches.'
    config.cache.auto_detect = true
    config.cache.enable :chef
    config.cache.enable :apt
  else
    puts 'WARN:  Vagrant-cachier plugin not detected. Continuing unoptimized.'
  end

  # Detects vagrant-omnibus plugin
  if Vagrant.has_plugin?('vagrant-omnibus')
    puts 'INFO:  Vagrant-omnibus plugin detected.'
    config.omnibus.chef_version = :latest
  else
    puts "FATAL: Vagrant-omnibus plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-omnibus' from any other directory\n       before continuing."
    exit
  end

  # Detects vagrant-berkshelf plugin
  if Vagrant.has_plugin?('berkshelf')
    # The path to the Berksfile to use with Vagrant Berkshelf
    puts 'INFO:  Vagrant-berkshelf plugin detected.'
    config.berkshelf.berksfile_path = './Berksfile'
  else
    puts "FATAL: Vagrant-berkshelf plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-berkshelf' from any other directory\n       before continuing."
    exit
  end

  config.vm.box = "oc-raring64"
  
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.04_chef-provisionerless.box"
  
  # config.vm.share_folder("v-root", "/vagrant", ".", :extra => 'dmode=775,fmode=775')

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      'modifyvm', :id,
      '--memory', '512',
      '--cpus', '1',
    ]
  end

  config.ssh.forward_agent = true
  config.vm.network :private_network, :ip => '33.33.33.50'
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.forward_port 80, 51742

  config.vm.provision :chef_solo do |chef| 
    chef.json = {
      "mysql" => {
        "server_root_password" => "",
        "server_debian_password" => "",
        "server_repl_password" => ""
      }
    }

    chef.run_list = [
      'recipe[silverstripe_cookbook::default]'
    ]
  end
end