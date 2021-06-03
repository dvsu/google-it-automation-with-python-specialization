# Week 1: Automating with Configuration Management

## Introduction to Puppet

---

## 1.2.1 What is Puppet?

***Puppet***

> Puppet is the current industry standard for managing the configuration of computers in a fleet of machines.  

***Client*** -> Puppet agent  

***Service*** -> Puppet master

> The agent connects to the master and sends a bunch of facts that describe the computer to the master.  
>
> The master then processes the information, generates the list of rules that need to be applied on the device, and sends the list back to the agent.

## 1.2.2 Puppet Resources

***Example of `sudo` package***  

```puppet
class sudo {
  package { 'sudo':
    ensure => present,
  }
}
```

Resource type: `package`  
This keyword is used to declare a package resource.

***Resources***

> The basic unit for modeling the configuration that we want to manage. Example of resources: `user`, `group`, `file`, `service`, `package`

***Example of file resource***  
*(this resource type is used for managing files and directories)*

```puppet
class sysctl {
  # Make sure the directory exists, some  distros don't have it
  file { '/etc/sysctl.d':
    ensure => directory,
  }
}
```

***What it does?***  

Make sure `/etc/sysctl.d` exists and it is a `directory`  

***Structure breakdown***  

| Name | Corresponding Name | Description |
|---|---|---|
| Resource type | `file` | The resource is written inside a block of curly braces `{ }` |
| Resource title | `/etc/sysctl.d` | The title of resource is followed by a colon `:` |
| Attribute | `ensure` |
| Attribute value | `directory` |

***Example of using file resource to configure the contents of `/etc/timezone`***

```puppet
class timezone {
  file { '/etc/timezone':
    ensure => file,
    content => "UTC\n",
    replace => true,
  }
}
```

***What it does?***

* The resource type is a `file`  
* set the content of the file to UTC timezone, and  
* replace the content of the file even if the file already exists.

How do the rules turn into changes in our computers?  

When a resource is declared in puppet rules, the desired state of the resource in the system is defined. The `puppet agent` then turns the desired state into reality using `provider`. The `provider` will depend on the resource defined and the environment where the agent is running. Puppet will detect it automatically without having to do anything special.

## 1.2.3 Puppet Classes

***Example of a class with three resources***

```puppet
class ntp {
  package { 'ntp':
    ensure => latest,
  }
  file { '/etc/ntp.conf':
    source => 'puppet:///modules/ntp/ntp  conf'
    replace => true,
  }
  service { 'ntp':
    enable => true,
    ensure => running,
  }
}
```

***Question***

What is the advantage of grouping related resources into a single class?  
`(✓)` To ensure efficiency and convenience for future changes *(by grouping related resources together, we can more easily understand the configuration and make changes in the future)*  
`(  )` It is required by Puppet  
`(  )` To keep computer clocks synchronized  
`(  )` To prevent errors  

## 1.2.4 Puppet Resources

[Puppet Resources](https://puppet.com/docs/puppet/7/lang_resources.html)  
[Bolt Examples](https://puppet.com/docs/bolt/latest/bolt_examples.html#deploy-a-package-with-bolt-and-chocolatey)

## 1.2.5 Quiz

***Question 1***

A Puppet agent inspects `/etc/conf.d`, determines the OS to be Gentoo Linux, then activates the Portage package manager. What is the provider in this scenario?  
`(  )` `/etc/conf.d`  
`(✓)` Portage *(Portage package manager used by Gentoo Linux is the provider called by the Puppet agent)*  
`(  )` Gentoo Linux  
`(  )` The Puppet agent  

***Question 2***

Which of the following examples show proper Puppet syntax?  

```puppet
class AutoConfig {
  package { 'Executable':
    ensure => latest,
  }
  file { 'executable.cfg':
    source => 'puppet:///modules/executable/Autoconfig/executable.cfg'
    replace => true,
  }
  service { 'executable.exe':
    enable  => true,
    ensure  => running,
  }
}
```

***Question 3***

What is the benefit of grouping resources into classes when using Puppet?  
`(  )` Providers can be specified  
`(✓)` Configuration management is simplified *(Grouping a collection of related resources into a single class simplifies configuration management by, for one example, allowing us to apply a single class to each host rather than having to specify every resource for each host separately and possibly missing some.)*  
`(  )` The title is changeable  
`(  )` Packages are not required  

***Question 4***

What defines which provider will be used for a particular resource?  
`(✓)` Puppet assigns providers based on the resource type and data collected from the system. *(Puppet assigns providers according to predefined rules for the resource type and data collected from the system such as the family of the underlying operating system.)*  
`(  )` A menu allows you to choose providers on a case-by-case basis.  
`(  )` The user is required to define providers in a config file.  
`(  )` Puppet uses an internet database to decide which provider to use.  

***Question 5***

In Puppet’s file resource type, which attribute overwrites content that already exists?  
`(  )` Purge  
`(  )` Overwrite  
`(✓)` Replace *(Puppet has many useful attributes. "Replace" set to True tells Puppet to replace files or symlinks that already exist on the local system but whose content doesn’t match what the source or content attribute specifies.)*  
`(  )` Save  

## The Building Blocks of Configuration Management

---

## 1.3.1 What are Domain-Specific Languages?

***Domain-Specific Language (DSL)***

> A programming language that's more limited in scope

Puppet's DSL includes

1. variables
2. conditional statements
3. functions

***Puppet Facts***

> Variables that represent the characteristics of the system; a hash that stores information about the details of a particular system.

***Example of a piece of Puppet code that makes use of one of the built-in facts***

```puppet
if $facts['is_virtual'] {
  package { 'smartmontools':
    ensure => purged,
  }
} else {
  package { 'smartmontools':
    ensure => installed,
  }
}
```

| Name | Corresponding Name | Description |
|---|---|---|
| Variable name | `facts` | Always preceded by a dollar sign `$`. Puppet variable is also known as `hash` in Puppet DSL *(equivalent to dictionary in Python)*|
| Hash key | `is_virtual` | Enclosed by square bracket `[ ]` |
| Conditional statement | `if else` | Each conditional block is enclosed with curly braces `{ }` |
| Package resource | `package {...}` | Content inside each conditional block |
| Value assignment | `=>` | To assign value to the attribute. Value ends with a comma `,` |

## 1.3.2 The Driving Principles of Configuration Management

***Idempotent***

> An idempotent action can be performed over and over again without changing the system after the first time the action was performed, and with no unintended side effects.

***Example of file resource***

```puppet
file { '/etc/issue':
  mode => '0644',
  content => "Internal system \l \n",
}
```

***What it does?***

This resource ensures the `/etc/issue` file has a set of permission and a specific line in it. Fulfilling this requirement is an idempotent operation. If the file already exists and has the desired content, then Puppet will understand that no action has to be taken. Otherwise, Puppet will create it. If contents or permissions don't match, Puppet will fix them. No matter how many times the agent applies the rule, the end result, the file will have the requested contents and permissions. (If the script is idempotent, it can fail halfway through its task and be run again without problematic consequences.)

However, `exec` resource, which runs commands, is ***not*** idempotent.

***Example of `exec` resource is not idempotent***

Executing an action of moving file. If a file has been move to a specific directory, executing the same action/ command again will lead to an error.

To ensure the `exec` resource is idempotent, the ***action*** has to be idempotent as well.

The workaround is to use `onlyif` attribute.

```puppet
exec { 'move example file':
  command => 'mv /home/user/example.txt /home/user/Desktop',
  onlyif => 'test -e /home/user/example.txt',
}
```

***What it does?***

The command should be executed only if the file exists. It means the file will be moved if it exists and nothing will happen if it does not.

> Puppet is stateless.

It means there is no state being kept between runs of the agent. Each run is independent.

## 1.3.3 More Information about Configuration Management

[Domain-specific Language](https://en.wikipedia.org/wiki/Domain-specific_language)  
[The Puppet Design Philosophy](http://radar.oreilly.com/2015/04/the-puppet-design-philosophy.html)  

## 1.3.4 Quiz

***Question 1***

How is a declarative language different from a procedural language?  
`(✓)` A declarative language defines the goal; a procedural language defines the steps to achieve a goal. *(In a declarative language, it's important to correctly define the end state we want to be in, without explicitly programming steps for how to achieve that state.)*  
`(  )` Declarative languages are object-based; procedural languages aren’t.  
`(  )` Declarative languages aren’t stateless; procedural languages are stateless.  
`(  )` A declarative language defines each step required to reach the goal state.  

***Question 2***

Puppet facts are stored in hashes. If we wanted to use a conditional statement to perform a specific action based on a fact value, what symbol must precede the facts variable for the Puppet DSL to recognize it?  
`(  )` @  
`(  )` #  
`(✓)` $  
`(  )` &  

***Question 3***

What does it mean that Puppet is stateless?  
`(  )` Puppet retains information between uses.  
`(  )` An action can be performed repeatedly without changing the system after the first run.  
`(✓)` There is no state being kept between runs of the agent. *(Stateless means there is no record of previous interactions, and each interaction request has to be handled based entirely on information that comes with it.)*  
`(  )` Actions are taken only when they are necessary to achieve a goal.  

***Question 4***

What does the "test and repair" paradigm mean in practice?  
`(  )` There is no state being kept between runs of the agent.  
`(  )` We should plan to repeatedly fix issues.  
`(  )` We need to test before and after implementing a fix.  
`(✓)` We should only take actions when testing determines they need to be done to reach the requested state *(By checking to see if a resource requires modification first, we can avoid wasting precious time.)*  

***Question 5***

Where, in Puppet syntax, are the attributes of a resource found?  
`(✓)` Inside the curly braces after the resource type  
`(  )` In brackets after the if statement  
`(  )` After ensure =>  
`(  )` After the dollar sign ($)  
