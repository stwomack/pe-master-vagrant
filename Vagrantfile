# -*- mode: ruby -*-
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
    puppetmaster.vm.provision :shell, :inline => "sudo service iptables stop"

    puppetmaster.vm.provision :shell, :inline => "sudo echo '10.10.10.100  agent-1.local' >> /etc/hosts"

    puppetmaster.vm.network "private_network", ip: "10.10.10.10"

    # Install helpers
    puppetmaster.vm.provision :shell, :inline => "sudo yum install lsof -y"
    puppetmaster.vm.provision :shell, :inline => "sudo yum install telnet -y "
    puppetmaster.vm.provision :shell, :inline => "sudo yum install mlocate -y"

    # Install keys for github
    puppetmaster.vm.provision :shell, :inline => "sudo mkdir /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/id_rsa* /root/.ssh "
    puppetmaster.vm.provision :shell, :inline => "sudo cp /vagrant/keys/known_hosts /root/.ssh "
    
    # Download and install Puppet Enterprise
    puppetmaster.vm.provision :shell, :inline => "cd /vagrant; wget http://fill-me-in-with-loc-to-pe-bits"
    puppetmaster.vm.provision :shell, :inline => "cd /vagrant; tar xzf puppet-enterprise-3.7.1-el-6-x86_64.tar.gz"
    puppetmaster.vm.provision :shell, :inline => "sudo /vagrant/puppet-enterprise-3.7.1-el-6-x86_64/puppet-enterprise-installer -a /vagrant/puppetmaster.answers"

    #Turn on cert autosign
    puppetmaster.vm.provision :shell, :inline => "sudo echo '*' >> /etc/puppetlabs/puppet/autosign.conf"

    #Turn on environments
    puppetmaster.vm.provision :shell, :inline => "sudo echo 'environmentpath = $confdir/environments' >> /etc/puppetlabs/puppet/puppet.conf"
    puppetmaster.vm.provision :shell, :inline => "sudo echo 'basemodulepath = $confdir/modules:/opt/puppet/share/puppet/modules' >> /etc/puppetlabs/puppet/puppet.conf"

    # Install r01k
    puppetmaster.vm.provision :shell, :inline => "sudo yum install git -y "
    puppetmaster.vm.provision :shell, :inline => "sudo gem install r10k -y "

    #Configure r10k
    puppetmaster.vm.provision :shell, :inline => "sudo echo 'sources:' >> /etc/puppetlabs/puppet/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo echo '  control:' >> /etc/puppetlabs/puppet/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo echo '    basedir: \"etc/puppetlabs/puppet/environments\"' >> /etc/puppetlabs/puppet/r10k.yaml"
    puppetmaster.vm.provision :shell, :inline => "sudo echo '    remote: \"git@your-git-project.git\"' >> /etc/puppetlabs/puppet/r10k.yaml"

    # Port forwarding for installer app, bootstrap app, and console app
    puppetmaster.vm.network "forwarded_port", guest: 3000, host: 3001
    puppetmaster.vm.network "forwarded_port", guest: 8140, host: 8141
    puppetmaster.vm.network "forwarded_port", guest: 443, host: 4443

    puppetmaster.vm.provider "virtualbox" do |vb|
      vb.memory = 5068
      vb.cpus = 4
    end
  end
  
  config.vm.define "agent-1" do |node|
    node.vm.box = "centos-6.4-x86_64"
    node.vm.hostname = "agent-1.wwt.local"
    node.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"
    node.vm.box_download_insecure = true
    
    node.vm.network "private_network", ip: "10.10.10.100"

    node.vm.provision :shell, :inline => "sudo echo '10.10.10.10  puppetmaster' >> /etc/hosts"

    node.vm.provision :shell, :inline => "sudo service iptables stop"
    node.vm.provision :shell, :inline => "sudo yum install lsof -y"
    node.vm.provision :shell, :inline => "sudo yum install mlocate -y"
    node.vm.provision :shell, :inline => "sudo yum install telnet -y "
    node.vm.provision :shell, :inline => "sudo curl -k https://puppetmaster:8140/packages/current/install.bash | sudo bash"
    node.vm.provision :shell, :inline => "sudo sed 's/production/sandbox/g;' /etc/puppetlabs/puppet/puppet.conf > /etc/puppetlabs/puppet/puppet.conf.new; mv /etc/puppetlabs/puppet/puppet.conf.new /etc/puppetlabs/puppet/puppet.conf -f"

    node.vm.network "forwarded_port", guest: 8081, host: 8080
  end 

end

#(1..2).each do |i|
#config.vm.define "node-#{i}" do |node|
#node.vm.hostname = "node-#{i}"

