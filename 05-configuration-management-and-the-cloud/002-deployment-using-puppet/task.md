# Lab 2: Finish a Puppet Deployment

## Part 1

***Task***

Install specific package on machines in the fleet, based on its operating system.

The name of the `manifest` is `init.pp` and can be inspected using commands below.

```shell
cd /etc/puppet/code/environments/production/modules/packages
```

```shell
cat manifests/init.pp
```

Change the permission of the file  

```shell
sudo chmod 646 manifests/init.pp
```

***Solution***

The complete `init.pp`

```puppet
class packages {
  package { 'python-requests':
    ensure => installed,
  }
  if $facts[os][family] == "Debian" {
    package { 'golang':
      ensure => installed,
    }
  }
  if $facts[os][family] == "RedHat" {
    package { 'nodejs':
      ensure => installed,
    }
  }
}
```

Connect to the node VM via SSH. To do that, it is necessary to check the public IP address of node VM

```shell
gcloud compute instances describe linux-instance --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

Next, run the Puppet client manually

```shell
sudo puppet agent -v --test
```

As the OS of the node is Debian, as per rule, the `golang` package will be installed. To check whether the package has been successfully installed.  

```shell
apt policy golang
```

## Part 2

***Task***  

Fetch machine information and use templates to manage the content of configuration files.  

```shell
cd /etc/puppet/code/environments/production/modules/machine_info
```

```shell
cat manifests/init.pp
```

Change the permission of the file  

```shell
sudo chmod 646 manifests/init.pp
```

***Solution***  

The complete `init.pp`  

```puppet
class machine_info {
  if $facts[kernel] == "windows" {
      $info_path = "C:\Windows\Temp\Machine_Info.txt"
  } else {
      $info_path = "/tmp/machine_info.txt"
  }
  file { 'machine_info':
      path    => $info_path,
      content => template('machine_info/info.erb'),
  }
}
```

Check the content of template file  

```shell
cat templates/info.erb
```

Change the permission before editing.  

```shell
sudo chmod 646 templates/info.erb
```

The completed `info.erb` file  

```none
Machine Information
-------------------
Disks: <%= @disks %>
Memory: <%= @memory %>
Processors: <%= @processors %>
Network Interfaces: <%= @interfaces %>
}
```

Next, SSH to the node VM and run the Puppet client manually

```shell
sudo puppet agent -v --test
```

Verify the `machine_info` contains the same structure as the template.  

```shell
cat /tmp/machine_info.txt
```

## Part 3

***Task***  

Create a new module named `reboot` to perform node reboot if the node has been online for more than 30 days.  

***Solution***  

Create a new directory named `reboot` and `init.pp` inside `manifests` folder.  

```shell
sudo mkdir -p /etc/puppet/code/environments/production/modules/reboot/manifests
```

```shell
cd /etc/puppet/code/environments/production/modules/reboot/manifests
```

```shell
sudo touch init.pp
```

```shell
sudo nano init.pp
```

The complete `init.pp`  

```puppet
class reboot {
  if $facts[kernel] == "windows" {
    $cmd = "shutdown /r"
  } elsif $facts[kernel] == "Darwin" {
    $cmd = "shutdown -r now"
  } else {
    $cmd = "reboot"
  }
  if $facts[uptime_days] > 30 {
    exec { 'reboot':
      command => $cmd,
    }
  }
}
```

To ensure all resources are included, it is required to modify the `site.pp` file.  

```shell
sudo nano /etc/puppet/code/environments/production/manifests/site.pp 
```

The complete `site.pp`

```puppet
node default {
   class { 'packages': }
   class { 'machine_info': }
   class { 'reboot': }
}
```

Finally, SSH to node VM and run the client manually and ensure it is working.  

```shell
sudo puppet agent -v --test
```
