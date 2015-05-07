
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Puppet Master 
  config.vm.define "puppetmaster", primary: true do |puppetmaster| 

    puppetmaster.vm.box = "centos-6.4-x86_64"
    puppetmaster.vm.hostname = "puppetmaster"
    puppetmaster.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"
    puppetmaster.vm.box_download_insecure = true

    # Stop iptables, they're screwing things up
    puppetmaster.vm.provision :shell, :inline => "sudo chkconfig iptables off"
    puppetmaster.vm.provision :shell, :inline => "sudo service iptables stop"

    puppetmaster.vm.network "private_network", ip: "10.10.10.10"

    # Port forwarding for installer app, boosandrap app, and console app
    puppetmaster.vm.network "forwarded_port", guest: 3000, host: 3001
    puppetmaster.vm.network "forwarded_port", guest: 8140, host: 8141
    puppetmaster.vm.network "forwarded_port", guest: 443, host: 4443
    puppetmaster.vm.network "forwarded_port", guest: 81, host: 80

    puppetmaster.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 4
    end

    # Install helpers - Taking them out to increase speed
    # puppetmaster.vm.provision :shell, :inline => "sudo yum install lsof -y"
    # puppetmaster.vm.provision :shell, :inline => "sudo yum install telnet -y "
    # puppetmaster.vm.provision :shell, :inline => "sudo yum install mlocate -y"
    #
    # Install keys for github
    puppetmaster.vm.provision :shell, :inline => "sudo mkdir /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/id_rsa* /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/known_hosts /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo chmod 700 ~/.ssh/id_rsa "

    # Download and install Puppet Enterprise
    puppetmaster.vm.provision :shell, :inline => "cd /vagrant; wget http://stuff.com/file.gz -o /dev/null"
    puppetmaster.vm.provision :shell, :inline => "cd /vagrant; tar xzf puppet-enterprise-3.7.1-el-6-x86_64.tar.gz"
    puppetmaster.vm.provision :shell, :inline => "sudo /vagrant/puppet-enterprise-3.7.1-el-6-x86_64/puppet-enterprise-installer -a /vagrant/files/puppetmaster.answers"

    # Turn on cert autosign
    puppetmaster.vm.provision :shell, :inline => "sudo echo '*' >> /etc/puppetlabs/puppet/autosign.conf"

    # Turn on environments
    puppetmaster.vm.provision :shell, :inline => "sudo echo 'environmentpath = $confdir/environments' >> /etc/puppetlabs/puppet/puppet.conf"
    puppetmaster.vm.provision :shell, :inline => "sudo echo 'basemodulepath = $confdir/modules:/opt/puppet/share/puppet/modules' >> /etc/puppetlabs/puppet/puppet.conf"

    # Install r01k
    # puppetmaster.vm.provision :shell, :inline => "sudo gem update --system "
    puppetmaster.vm.provision :shell, :inline => "sudo yum install -y git"
    puppetmaster.vm.provision :shell, :inline => "sudo gem install r10k"

    # Configure r10k
    puppetmaster.vm.provision :shell, :inline => "sudo git clone somegitrepo /etc/puppetlabs/puppet/some-master-configuration"
    puppetmaster.vm.provision :shell, :inline => "sudo ln -sf /etc/puppetlabs/puppet/some-master-configuration/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo ln -sf /etc/puppetlabs/puppet/some-master-configuration/r10k.yaml /etc/puppetlabs/puppet/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo r10k deploy environment sand -p -v -c /etc/puppetlabs/puppet/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo /etc/puppetlabs/puppet/some-master-configuration/vagrant_create_classifiers.sh"
  end

  (1..4).each do |i|
     config.vm.define "sandmongodb0#{i}" do |node|
       node.vm.box = "centos-6.4-x86_64"
       node.vm.hostname = "sandmongodb0#{i}.test.local"
       node.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"
       node.vm.box_download_insecure = true
       node.vm.network "private_network", ip: "10.10.10.10#{i}"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.10  puppetmaster' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.101 sandmongodb01.test.local' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.102 sandmongodb02.test.local' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.103 sandmongodb03.test.local' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.104 sandmongodb04.test.local' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo echo '10.10.10.105 sandmongodbarb01.test.local' >> /etc/hosts"
       node.vm.provision :shell, :inline => "sudo chkconfig iptables off"
       node.vm.provision :shell, :inline => "sudo service iptables stop"
       node.vm.provision :shell, :inline => "sudo curl -k https://puppetmaster:8140/packages/current/install.bash | sudo bash"
     end
  end

  config.vm.define "sandmongodbarb01" do |node|
    node.vm.box = "centos-6.4-x86_64"
    node.vm.hostname = "sandmongodbarb01.test.local"
    node.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"
    node.vm.box_download_insecure = true
    node.vm.network "private_network", ip: "10.10.10.105"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.10  puppetmaster' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.101 sandmongodb01.test.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.102 sandmongodb02.test.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.103 sandmongodb03.test.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.104 sandmongodb04.test.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.105 sandmongodbarb01.test.local' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo chkconfig iptables off"
    node.vm.provision :shell, :inline => "sudo service iptables stop"
    node.vm.provision :shell, :inline => "sudo curl -k https://puppetmaster:8140/packages/current/install.bash | sudo bash"
  end

end

