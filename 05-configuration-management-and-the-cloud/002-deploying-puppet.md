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
    source => '/home/user/ntp.conf',
    replace => true,
    require => Package['ntp'],
    notify => Service['ntp'],
  }
  service { 'ntp':
    enable => true,
    ensure => running,
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



## 2.2.2 Puppet's Certificate Infrastructure

## 2.2.3 Setting Up Puppet Clients and Servers

## 2.2.4 More Information about Deploying Puppet to Clients

## 2.2.5 Quiz

## Updating Deployments

---

## 2.3.1 Modifying and Testing Manifests

## 2.3.2 Safely Rolling Out Changes and Validating Them

## 2.3.3 More Information about Updating Deployments

## 2.3.4 Quiz
