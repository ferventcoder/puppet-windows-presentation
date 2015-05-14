Puppet On Windows
==================================

## Presentation

In the `Presentation` directory.

## Demo Prerequisites

 * [Vagrant 1.5.4](http://downloads.vagrantup.com/tags/v1.5.4) or greater.
 * [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads) or VMWare Fusion 5
    * If you want to use VMWare Fusion you will also need the vagrant-vmware-fusion plugin for vagrant (which is not free). You also want the latest version (at least 0.8.5).
 * Vagrant-Windows
 * At least 20GB free on the host box.
 * Vagrant Sahara plugin for sandboxing.

## Demo - System Setup

 1. Install/upgrade Vagrant to 1.5.4 or greater. I recommend 1.6.5 or any version of Vagrant at or past the `.z` of `3` (as in `1.7.3`).
 1. Install/upgrade VirtualBox/VMWare to versions listed above.
 1. Install/upgrade required plugins for vagrant (if using VMWare you will need the non-free vagrant-vmware-fusion or equivalent).
 1. Vagrant 1.5.4 (and below) - Install/upgrade vagrant-windows vagrant plugin. Open terminal/command line and type `vagrant plugin install vagrant-windows`
 1. Install/upgrade `sahara` vagrant plugin - `vagrant plugin install sahara`.
 1. Find a Windows 2012 x64 vagrant basebox. [Atlas has some](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=&q=windows) - If you have the VMWare plugin, you can take a look at [these](https://atlas.hashicorp.com/opentable/). Follow the instructions for what to update in the VagrantFile to take advantage of using that box.

## Demo

### Exercise 0 - Vagrant Box Prep

 1. From a command line on the host system, navigate to the `Demo` folder.
 1. Call `vagrant up` and wait for it to download the box and run the shell provisioner.
   1. This is the step that takes quite awhile if you don't already have the box down. Once you see this working, I would shift gears to something else for awhile.
 1. Once everything finishes, we need to call `vagrant sandbox on` to turn on snapshotting.
 1. In `Demo/Vagrantfile` please comment out the shell provisioner and change `puppet.manifest_file` to `provision.pp` (it should be found as `empty.pp`).
 1. This is it for Exercise 0. This is also the same state the demo starts in.

Notes:
 * To suspend a box, you use `vagrant suspend`. To shut down a box, you use `vagrant halt`. To remove a box, you use `vagrant destroy`.
 * If any point you want to reset the sandbox VM to the end of exercise 0, you can use `vagrant sandbox rollback` to reset the box.
 * Look over `Demo/VagrantFile`

### Exercise 1 - Puppet apply

 1. Open up `Demo/puppet/manifests/provision.pp` and take a look at it.
 1. Run `vagrant provision`. Note the changes that are made.
 1. Run `vagrant provision` again. Not that Puppet reports nothing changes.
 1. Play around with some of the resources, making changes, running `vagrant provision` and note how they change the files on the system.
 1. Change things on the file system and note how Puppet fixes configuration drift automatically.
 1. This concludes Exercise 1.

### Exercise 2 - Chocolatey Simple Server
 1. Open up `Demo/puppet/modules/chocolatey_server/manifests/init.pp` and take a look at it (no changes necessary).
 1. In `Demo/puppet/manifests/provision.pp` uncomment the line `include chocolatey_server`.
 1. Open up an internet browser on the host (not the guest VM) and navigate to `http://localhost:8080/`. Note that is it not a working url.
 1. Run `vagrant provision`.
 1. Note what changes are happening on the system as it installs and sets up everything for you.
 1. Reload the url `http://localhost:8080/`. Note what is now available.
 1. This concludes Exercise 2.

### Exercise 3 - More Resources
 1. Discovery - Open a command line on the guest system (the VM) and type `puppet resource user`. Try this for other resource types.
 1. Implement a scheduled task resource to open notepad on Mondays at 2PM every week.
 1. Implement a host resource to set `puppetmaster` to an IP address.
 1. Hook the Windows 2012 box up to a Puppet Master.

