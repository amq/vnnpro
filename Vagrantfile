VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "vnnpro"
    config.vm.box_url = "http://nnpro.at/vagrant/vnnpro/"

    config.vm.network :private_network, ip: "192.168.20.20"

    # Changing the main guest directory will break things
    config.vm.synced_folder ".", "/home/vagrant/sync",
       type: "nfs", mount_options: ['rw', 'vers=3', 'udp', 'fsc', 'actimeo=1']

    # If you don't want to move the site directory, map it (or use symlinks)
    # config.vm.synced_folder "/home/dev/site.com", "/home/vagrant/sync/site.com/htdocs",
    #   type: "nfs", mount_options: ['rw', 'vers=3', 'udp', 'fsc', 'actimeo=1']

    config.vm.provider "virtualbox" do |vb|
        vb.customize ['modifyvm', :id, '--memory', '2048']
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end

    config.persistent_storage.enabled = true
    config.persistent_storage.location = "mysql-storage.vdi"
    config.persistent_storage.size = 5000
    config.persistent_storage.mountname = 'mysql'
    config.persistent_storage.filesystem = 'ext4'
    config.persistent_storage.mountpoint = '/var/lib/mysql'
    config.persistent_storage.volgroupname = 'vnnpro'

    config.vm.provision :shell, inline: "php-engine.sh hhvm", run: "always" # hhvm, php55, php70
    config.vm.provision :shell, inline: "vnnpro-startup.sh", run: "always"

end
