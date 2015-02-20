pe-master-vagrant
=================
Vagrant project that spins up a puppet master and agent(s) bootstrapped to it
***
Instructions
* Install VirtualBox
* Install Vagrant
* <pre><code>git clone git@prodgithub01.wwt.com:Operations/pe-master-vagrant.git</code></pre>
* 'vagrant up' without arguments creates all 4. To start selected VMs, add them as arguments
* <pre><code>vagrant up puppetmaster {apache-1} {jenkins-master} {jenkins-slave} </code></pre>
* View the Enterprise console at https://localhost:4443/
  
  admin/test123!

* Get to the puppetmaster (or any specfic vm) with the following command:
<pre><code>vagrant ssh puppetmaster</code></pre>

* Now you're ready to start using r10k (on the puppetmaster.) 

execute:

<pre><code>sudo su -
cd /etc/puppetlabs/puppet/
r10k deploy environment sandbox -p -v -c r10k.yaml
</code></pre>

* In order to continue emulating our real environment, you'll want to create the same classfications on your puppetmaster:

<pre><code>/vagrant/files/create_classifiers.sh</code></pre>

