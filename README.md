wwt-pe-master-vagrant
=================
Vagrant project that spins up a puppet master running **version 3.8.0**
***
Instructions
* Install VirtualBox. https://www.virtualbox.org/wiki/Downloads
* Install Vagrant. https://www.vagrantup.com/downloads.html
* Create or Choose a directory for the project
* Download it
* <pre><code>git clone git@github.com/stwomack/wwt-pe-master-vagrant.git</code></pre>
* <pre><code>cd wwt-pe-master-vagrant</code></pre>
* Create a topic branch relative to the body of work.  Example: <pre><code>git checkout -b apache</code></pre>
* Edit the Vagrantfile and define a config for a development vm.  Example:
<pre><code>
  config.vm.define "apache" do |node|
    node.vm.box = "rhel-server-6.5-x86_64"
    node.ssh.pty = true
    node.vm.hostname = "apache"
    node.vm.box_url = "http://vagrant.wwt.com/rhel-server-6.5-x86_64.box"
    node.vm.box_download_insecure = true
    node.vm.network "private_network", ip: "10.10.10.105"
    node.vm.provision :shell, :inline => "sudo echo '10.10.10.10  puppetmaster' >> /etc/hosts"
    node.vm.provision :shell, :inline => "sudo curl -k https://puppetmaster:8140/packages/current/install.bash | sudo bash"
  end</code></pre>
* 'vagrant up' without arguments creates the puppetmaster and whatever vm define you included per the last step.
* <pre><code>vagrant up</code></pre>
* or
* <pre><code>vagrant up puppetmaster [apache]</code></pre>
* This can take up to 30 minutes. Be patient
* View the Enterprise console at https://localhost:4443/
  
  admin/test123!

* Use 'vagrant status' at any time to show the state of the VMs and options for additional provisioning
* Get to the puppetmaster (or any specfic vm) with the following command:
<pre><code>vagrant ssh puppetmaster [apache]</code></pre>

* The classification script, createClassifiers.rb, and r10k will both be executed intially, but you can re-run at any time.  Refer to the Vagrantfile for usage examples.
