pe-master-vagrant
=================
Vagrant project that spins up a puppet master and agent(s) bootstrapped to it
***
Instructions
* Install VirtualBox
* Install Vagrant
* <pre><code>git clone https://github.com/stwomack/vagrant-puppet-enterprise-master.git</code></pre>
* <pre><code>vagrant up</code></pre>
* View the Enterprise console at https://localhost:4443/
  
  admin/test123!


* Get to the puppetmaster with the following command:
<pre><code>vagrant ssh puppetmaster</code></pre>

* Change file permissions on private key
<pre><code>chmod 600 ~./ssh/id_rsa</code></pre>
* To get to the agent, do 
<pre><code>vagrant ssh agent-1</code></pre>

* Now you're ready to start using r10k (on the puppetmaster.) 

execute:

<pre><code>sudo su -
cd /etc/puppetlabs/puppet/
r10k deploy environment sandbox --puppetfile -c r10k.yaml
</code></pre>
