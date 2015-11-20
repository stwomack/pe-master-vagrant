
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Puppet Master 
  config.vm.define "puppetmaster", primary: true do |puppetmaster| 

    puppetmaster.vm.box = "rhel-server-6.5-x86_64"
    puppetmaster.ssh.pty = true
    puppetmaster.vm.hostname = "puppetmaster"
    puppetmaster.vm.box_url = "http://vagrant.nothing.com/rhel-server-6.5-x86_64.box"
    puppetmaster.vm.box_download_insecure = true
    puppetmaster.vm.network "private_network", ip: "10.10.10.10"

    # Port forwarding for installer app and console app
    puppetmaster.vm.network "forwarded_port", guest: 3000, host: 3001
    puppetmaster.vm.network "forwarded_port", guest: 8140, host: 8141
    puppetmaster.vm.network "forwarded_port", guest: 443, host: 4443
    puppetmaster.vm.network "forwarded_port", guest: 81, host: 80

    puppetmaster.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 4
    end

    # Install keys for github
    puppetmaster.vm.provision :shell, :inline => "sudo mkdir /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/id_rsa* /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/known_hosts /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo chmod 700 ~/.ssh/id_rsa "
    puppetmaster.vm.provision :shell, :inline => "sudo yum install -y git"

    # Download and install Puppet Enterprise
    puppetmaster.vm.provision :shell, :inline => "if [ ! -f /vagrant/puppet-enterprise-2015.2.3-el-6-x86_64.tar.gz ]; then cd /vagrant; wget http://puppetfiles.nothing.com/puppet-enterprise-2015.2.3-el-6-x86_64.tar.gz -o /dev/null; fi"
    puppetmaster.vm.provision :shell, :inline => "if [ ! -d puppet-enterprise-2015.2.3-el-6-x86_64 ]; then cd /vagrant; tar xzf puppet-enterprise-2015.2.3-el-6-x86_64.tar.gz; fi"
    puppetmaster.vm.provision :shell, :inline => "sudo /vagrant/puppet-enterprise-2015.2.3-el-6-x86_64/puppet-enterprise-installer -a /vagrant/files/puppetmaster-2015.2.3-answers"

    # Turn on cert autosign
    puppetmaster.vm.provision :shell, :inline => "sudo echo '*' >> /etc/puppetlabs/puppet/autosign.conf"

    # Install ruby gems for classifier.rb
    puppetmaster.vm.provision :shell, :inline => "sudo /opt/puppetlabs/puppet/bin/gem install puppetclassify"
    puppetmaster.vm.provision :shell, :inline => "sudo /opt/puppetlabs/puppet/bin/gem install mongo"

    # Create pe-git user to mimick prd
    # Copy temporary r10k.yaml in order to deploy production
    # Import classifications from MongoDB
    # Perform puppet run to apply production profiles
    puppetmaster.vm.provision :shell, :inline => "sudo /usr/sbin/useradd -d /home/pe-git -g wheel -G pe-puppet -s /bin/bash -m -u 1986 pe-git"
    puppetmaster.vm.provision :shell, :inline => "sudo /bin/sed -i -e '108s/# //g' /etc/sudoers"
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/files/r10k.yaml /etc/puppetlabs/r10k/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo /usr/local/bin/r10k deploy environment production -p -v -c /etc/puppetlabs/r10k/r10k.yaml"
    #until hunner-hiera can be fixed to install the puppetserver gem for us
    puppetmaster.vm.provision :shell, :inline => "sudo /opt/puppetlabs/bin/puppetserver gem install hiera-eyaml"
    puppetmaster.vm.provision :shell, :inline => "sudo /opt/puppetlabs/puppet/bin/ruby /vagrant/files/classifications.rb -i"
    puppetmaster.vm.provision :shell, :inline => "sudo /usr/local/bin/puppet agent -t || true"
    
    # profile::nothing_hiera generates keys upon force puppet run above; trash these
    # copy insecure vagrant eyaml private/public keys
    puppetmaster.vm.provision :shell, :inline => "sudo cp -f /vagrant/keys/*.pem /etc/puppetlabs/code/keys"

    #Add PATH to gem, ruby, puppetserver
    puppetmaster.vm.provision :shell, :inline => "sudo /bin/sed -i '/^PATH/c PATH=\$PATH:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/puppet/bin:/etc/puppetlabs/code/environments/production:/opt/puppetlabs/bin:/vagrant/files/' /root/.bash_profile"
  end

end
