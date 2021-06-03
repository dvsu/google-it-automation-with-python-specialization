# Week 2: Deploying Puppet

## Deploying Puppet Locally

---

## 2.1.1 Intro to Module 2: Deploying Puppet

Three most important Puppet resources

1. `package`
2. `files`
3. `service`

## 2.1.2 Applying Rules Locally

Installing Puppet on Ubuntu

```shell
sudo apt install puppet-master
```

**_Manifest_**

> File that stores rules that want to be applied, ends with `.pp` extension.

**_Example of simple Puppet rule to install `htop` package_**

```puppet
package { 'htop':
  ensure => present,
}
```

**_What it does?_**

The rule will load the `fact`, compile the catalog, apply current configuration, then install the requested package (`htop`); ff the package is not available, the rule will start the installation process.

Command to apply Puppet rule, assuming the rule is stored in `example.pp`

```shell
sudo puppet apply -v example.pp
```

`-v` flag indicates verbose output

**_Catalog_**

> The list of rules that are generated for one specific computer once the server has evaluated all variables, conditionals, and functions.

## 2.1.3 Managing Resource Relationships

Example of resource relationships in `ntp.pp`

```puppet
class ntp {
  package { 'ntp':
    ensure => latest,
  }
  file { '/etc/ntp.conf':
    source  => '/home/user/ntp.conf',
    replace => true,
    require => Package['ntp'],
    notify  => Service['ntp'],
  }
  service { 'ntp':
    enable  => true,
    ensure  => running,
    require => File['/etc/ntp.conf'],
  }
}

include ntp
```

**_What it does?_**

- The configuration file requires the NTP package and the service requires the configuration file.
- Before starting the service, the configuration file needs to be correctly set
- Before sending the configuration file, the package needs to be installed
- NTP service should be notified if the configuration file changes; if additional changes are added, the service will be reloaded with new settings.
- `include` will tell Puppet that we want to apply the rules described in a class. `include` is typically written in separate file.

**_Puppet Syntax_**

> Resource types are in **_lowercase_** when declaring them, but **_capitalize_** them when referring to them from another resource's attribute.  
> See `package` resource and `Package['ntp']` relationship above.

## 2.1.4 Oraganizing Your Puppet Modules

In Puppet, manifests are organized into modules.

**_Module_**

> A collection of manifests and associated data

Typical directories in a module

1. Manifests  
   Stores `manifest`
2. Files  
   Includes files that are copied into the client machines without any changes, e.g. `.conf` file
3. Templates  
   Includes files that are preprocessed before copying into client machines

Examples of `ntp` module

```none
modules/
└── ntp
     ├── files
     │    └── ntp.conf
     └── manifests
          └── init.pp
```

Installing Apache module provided by Puppet Labs

```shell
sudo apt install puppet-module-puppetlabs-apache
```

After installation has been completed, similar directory structure can be inspected by executing the command below.

```shell
tree /usr/share/puppet/modules.available/puppetlabs-apache/
```

`init.pp` is stored in `manifests` directory and will always be the first file read by Puppet when a module gets included.

**_How to include an installed module?_**

Assuming the `apache` module has been installed, it can be easily included as shown below.

`webserver.pp`

```puppet
include ::apache
```

Double colon `::` before the module name indicates the module is a global module.

Execute the `webserver.pp` using the same command

```shell
sudo puppet apply -v webserver.pp
```

## 2.1.5 More Information about Deploying Puppet Locally

[The Puppet Language Style Guide](https://puppet.com/docs/puppet/latest/style_guide.html)  
[Installing Puppet Server](https://puppet.com/docs/puppetserver/latest/install_from_packages.html)

## 2.1.6 Quiz

**_Question 1_**

Puppet evaluates all functions, conditionals, and variables for each individual system, and generates a list of rules for that specific system. What are these individual lists of rules called?  
`( )` Manifest  
`( )` Dictionaries  
`(✓)` Catalogs _(The catalog is the list of rules for each individual system generated once the server has evaluated all variables, conditionals, and functionals in the manifest and then compared them with facts for each system)_  
`( )` Modules

**_Question 2_**

After we install new modules that were made and shared by others, which folder in the module's directory will contain the new functions and facts?  
`( )` files  
`( )` manifests  
`(✓)` lib _(New functions added after installing a new module can be found in the lib folder in the directory of the new module)_  
`( )` templates

**_Question 3_**

What file extension do manifest files use?  
`( )` .cfg  
`( )` .exe  
`(✓)` .pp _(Manifest files for Puppet will end in the extension .pp)_  
`( )` .man

**_Question 4_**

What is contained in the `metadata.json` file of a Puppet module?  
`( )` Manifest files  
`(✓)` Additional data about the module _(Metadata is data about data, and in this case, often takes the form of installation and compatibility information)_  
`( )` Configuration information  
`( )` Pre-processed data

**_Question 5_**

What does Puppet syntax dictate we do when referring to another resource attribute?  
`( )` Enter the package title before curly braces  
`( )` Follow the attribute with a semicolon  
`(✓)` Capitalize the attribute _(When defining resource types, we write them in lowercase, then capitalize them when referring to them from another resource attribute)_  
`( )` Type the attribute in lowercase

## Deploying Puppet to Clients

---

## 2.2.1 Puppet Nodes

**_Node_**

> Any system where we can run a Puppet agent

When setting up Puppet, we usually have a default node definition that lists the classes that should be included for all the nodes.

**_Example_**

```puppet
node default {
  class { 'sudo': }
  class { 'ntp':
    servers => ['ntp1.example.com', 'ntp2.example.com']
  }
}
```

The default node is including two classes, the `sudo` class and the `ntp` class.

Similarly, additional settings can be applied to specific nodes using FQDN (Fully Qualified Domain Names).

```puppet
node webserver.example.com {
  class { 'sudo': }
  class { 'ntp':
    servers => ['ntp1.example.com', 'ntp2.example.com']
  }
  class { 'apache': }
}
```

In this example, `webserver.example.com` is the **_node definition_**

Node definitions are typically stored in a file called `site.pp` _(not part of any module)_

## 2.2.2 Puppet's Certificate Infrastructure

Puppet uses **_Public Key Infrastructure (PKI)_** to establish secure connections between server and clients.

The public key technology used by Puppet is **_Secure Socket Layer (SSL)_**

How do machines know which public keys to trust?  
A **_Certificate Authority (CA)_** verifies the identity of the machine and creates a certificate stating that the public key goes with that machine.

**_The purpose of the Certificate Authority (CA)_**

To validate the identity of each machine. _(the CA either queues a certificate request for manual validation, or uses pre-shared data to verify before sending the certificate to the agent)_

## 2.2.3 Setting Up Puppet Clients and Servers

How to set up automatic sign for certificate requests

```shell
sudo puppet config --section master set autosign true
```

The best practice is to sign the requests manually or implement a proper validating script.

Command to install Puppet client _(performed on Puppet agent)_

```shell
sudo apt install puppet
```

Puppet client setup so the Puppet agent is able to communicate with Puppet master _( performed on Puppet agent)_.

```shell
sudo puppet config set server ubuntu.example.com
```

`ubuntu.example.com` is the server name.

To check connection between agent and master _(performed on Puppet agent)_.

```shell
sudo puppet agent -v --test
```

Create node definitions on Puppet master using `Vim`.

```shell
vim /etc/puppet/code/environments/production/manifests/site.pp
```

The content of `site.pp`

```puppet
node webserver.example.com {
  class {'apache':}
}

node default {}
```

`webserver.example.com` is the **_Fully Qualified Domain Name (FQDN)_** of the Puppet agent.

After `site.pp` has been updated on Puppet master side, run the exact command on the Puppet agent.

```shell
sudo puppet agent -v --test
```

This time, the Puppet agent connected to the Puppet master and got a catalog that told it to install and configure the Apache package. This included setting up a bunch of different services. Up to now, we've been doing manual runs of the Puppet agent for testing purposes.

By using `systemctl` on Puppet agent, the `run` can be performed automatically.

Enable Puppet service on reboot

```shell
sudo systemctl enable puppet
```

To start the Puppet service

```shell
sudo systemctl start puppet
```

To check the Puppet service whether it is actually running

```shell
sudo systemctl status puppet
```

## 2.2.4 More Information about Deploying Puppet to Clients

[Puppet SSL Explained](https://www.masterzen.fr/2010/11/14/puppet-ssl-explained/)

## 2.2.5 Quiz

**_Question 1_**

When defining nodes, how do we identify a specific node that we want to set rules for?  
`( )` By using the machine’s MAC address  
`(✓)` By specifying the node's Fully Qualified Domain Names (FQDNs) _(A FQDN is a complete domain name for a specific machine that contains both the hostname and the domain name)_  
`( )` User-defined names  
`( )` Using XML tags

**_Question 2_**

When a Puppet agent evaluates the state of each component in the manifest, it uses gathered facts about the system to decide which rules to apply. What tool can these facts be "plugged into" in order to simplify management of the content of our Puppet configuration files?  
`( )` Node definitions  
`( )` Certificates  
`(✓)` Templates _(Templates are documents that combine code, system facts, and text to render a configuration output fitting predefined rules)_  
`( )` Modules

**_Question 3_**

at is the first thing that happens after a node connects to the Puppet master for the first time?  
`( )` The node identifies an open port.  
`( )` The Puppet-master requests third-party authentication.  
`(✓)` The node requests a certificate. _(After receiving a certificate, the node will reuse it for subsequent logins)_  
`( )` The user can immediately add modules.

**_Question 4_**

What does FQDN stand for, and what is it?  
`( )` Feedback Query Download Noise, which is extraneous data in feedback queries  
`( )` Far Quantum Data Node, which is a server node utilizing quantum entanglement  
`( )` Fairly Quantized Directory Network, which is a network consisting of equitable counted folders  
`(✓)` Fully Qualified Domain Name, which is the full address for a node _(A fully qualified domain name (FQDN) is the unabbreviated name for a particular computer, or server. There are two elements of the FQDN: the hostname and the domain name)_

**_Question 5_**

What type of cryptographic security framework does Puppet use to authenticate individual nodes?  
`( )` Single Sign On (SSO)  
`(✓)` Public Key Infrastructure (PKI)  
`( )` Fully Qualified Domain Name (FQDN)  
`( )` Token authentication _(Puppet uses an Secure Sockets Layer (SSL) Public Key Infrastructure to authenticate both nodes and masters)_

## Updating Deployments

---

## 2.3.1 Modifying and Testing Manifests

**_rspec tests_**

> Test manifests automatically by setting the facts involved different values and check that the catalog ends up stating what we wanted it to.

```puppet
describe 'gksu', :type => :class do
  let (:facts) { { 'is_virtual' => 'false' } }
  it { should contain_package('gksu').with_ensure('latest') }
end
```

**_Question_**

What does the **_puppet parse validate_** command do?  
`(✓)` Checks the syntax of the manifest _(The `puppet parser validate` command checks the syntax of the manifest to make sure it's correct)_  
`( )` Runs full No Operations simulations  
`( )` Tests automatically using facts we set to evaluate the resulting catalog  
`( )` Forcibly applies manifests locally

## 2.3.2 Safely Rolling Out Changes and Validating Them

**_Production_**

> The parts of the infrastructure where a service is executed and served to its users.

How to roll out changes safely

1. Run through **_test environment_** first
2. Push the changes in batches, i.e. to canaries (early adopters)
3. Changes are small and self-contained, so if something breaks, it is easier to figure out the problem

**_Question_**

What is the purpose of using multiple environments?  
`(✓)` To fully isolate the configurations that agents see _(By creating separate directories for different purposes, such as testing and production, we can ensure changes don't affect end users)_  
`( )` To automate testing  
`( )` To add variety  
`( )` To detect potential issues before they reach the other computers

## 2.3.3 More Information about Updating Deployments

[rspec tutorial](https://rspec-puppet.com/tutorial/)  
[Puppet linting](http://puppet-lint.com/)

## 2.3.4 Quiz

**_Question 1_**

What is a production environment in Puppet?  
`( )` The software used for software development such as IDEs  
`(✓)` The parts of the infrastructure where a service is executed, and served to its users _(Environments in Puppet are used to isolate software in development from software being served to end users)_  
`( )` A cloud service for commercial production  
`( )` A Virtual Machine reserved for beta software

**_Question 2_**

What is the --noop parameter used for?  
`( )` Passing a variable called noop to Puppet  
`( )` Adding conditional rules to manifests  
`( )` Defining what operations not to perform in a manifest  
`(✓)` Simulating manifest evaluation without taking any actions _(No Operations mode makes Puppet simulate what it would do without actually doing it)_

**_Question 3_**

What do rspec tests do?  
`( )` Checks that nodes can connect to the puppet master correctly  
`( )` Check the specification of the current node  
`(✓)` Check the manifests for specific content _(We can test our manifests automatically by using rspec tests. In these tests, we can verify resources exist and have attributes set to specific values)_  
`( )` Checks that the node is running the correct operating system

**_Question 4_**

How are canary environments used in testing?  
`( )` To store unused code  
`(✓)` As a test environment to detect problems before they reach the production environment _(If we can identify a problem before it reaches all the machines in the production environment, we’ll be able to keep the problem isolated)_  
`( )` As a repository for alternative coding methods for a particular problem  
`( )` As a test environment for final software versions

**_Question 5_**

What are efficient ways to check the syntax of the manifest?  
`[✓]` Run full No Operations simulations _(In order to perform No Operations simulations, we must use the --noop parameter when running the rules)_  
`[✓]` Run rspec tests _(To test automatically, we need to run rspec tests, and fix any errors in the manifest until the RSpec tests pass)_  
`[ ]` Test manually  
`[✓]` `puppet parser validate` _(Using the puppet parser validate command is the simplest way to check that the syntax of the manifest is correct)_
