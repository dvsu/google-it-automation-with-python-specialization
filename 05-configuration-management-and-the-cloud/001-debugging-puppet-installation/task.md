# Lab 1: Debugging Puppet Installation

## Part 1

**_Issue_**

Main directories used for executing binaries in Linux are missing (`/bin` and `/usr/bin`). As the directories are missing, basic commands such as `ls`, `cd`, `mkdir`, `rm` are not available.

**_Solution_**

Add directories that contain executing binaries (`/bin` and `/usr/bin`) to environment variable `$PATH`

```shell
export PATH=/bin:/usr/bin
```

To confirm the updated environment variable

```shell
echo $PATH
```

Check one of the commands is working

```shell
ls /
```

## Part 2

**_Issue_**

Puppet rule in `init.pp` overwrites the `PATH` variables

```puppet
content => "PATH=/java/bin\n"
```

**_Solution_**

Instead of overwriting the `PATH` variables, the rule should append new variables.

```puppet
content => "PATH=\$PATH:/java/bin\n"
```

Update and save the `init.pp` content.

```shell
sudo nano init.pp
```

Trigger the Puppet agent

```shell
sudo puppet agent -v --test
```

Check the final `PATH` variables on second SSH connection

```shell
echo $PATH
```

The output may be similar to this  

```shell
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/java/bin
```
