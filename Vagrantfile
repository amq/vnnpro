VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.ssh.insert_key = false

    config.vm.box = "centos/7"

    config.vm.network :private_network, ip: "192.168.20.20"

    # Changing the main guest directory will break things
    config.vm.synced_folder ".", "/home/vagrant/sync",
       type: "nfs", mount_options: ['rw', 'vers=3', 'udp', 'fsc', 'actimeo=1']

    config.vm.provider "virtualbox" do |vb|
        vb.customize ['modifyvm', :id, '--memory', '2048']
        vb.customize ["modifyvm", :id, "--cpus", "2"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    end

    config.vm.provision :shell, path: "vagrant-bootstrap/install.sh"

    config.vm.provision :shell, inline: "php-engine.sh hhvm", run: "always" # hhvm, php55, php70
    config.vm.provision :shell, inline: "vnnpro-startup.sh", run: "always"

end
