Puppet On Windows
==================================

## Prerequisites

 * [Vagrant 1.2.7](http://downloads.vagrantup.com/tags/v1.2.7) - I'm pretty sure you'll need the latest version (we've tried 1.2.2 and it didn't work)
 * [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads) or VMWare Fusion 5
    * If you want to use VMWare Fusion you will also need the vagrant-vmware-fusion plugin for vagrant (which is not free). You also want the latest version (at least 0.8.5).
 * Vagrant-Windows 1.2.0 - included here in SetupFiles directory
 * At least 20GB free on the host box.
 * Vagrant Sahara plugin for sandboxing

## Setup

 1. Install/upgrade Vagrant to 1.2.7.
 1. Install/upgrade VirtualBox/VMWare to versions listed above.
 1. Install/upgrade required plugins for vagrant (if using VMWare you will need the non-free vagrant-vmware-fusion or equivalent).
 1. Install/upgrade vagrant-windows vagrant plugin. Open terminal/command line, head to the directory where the plugin is `vagrant plugin install vagrant-windows-1.2.0.gem`
 1. Install/upgrade `sahara` vagrant plugin - `vagrant plugin install sahara`.
 1. Download [Sql Server Express 2012 Installer](http://download.microsoft.com/download/8/D/D/8DD7BDBA-CEF7-4D8E-8C16-D9F69527F909/ENU/x64/SQLEXPRWT_x64_ENU.exe) to `Demo/resources/SQLServer/SQLEXPRWT_x64_ENU.exe`. It's about 230 MB so it might take a minute.

## Presentation

The presentation is in keynote but there are other formats in the `Presentation` directory.

## Demo

### Exercise 0 - Vagrant Box Prep

 1. In `Demo/Vagrantfile` comment out the puppet provisioner. 
 1. Call `vagrant up` and wait for it to download the box and run the shell provisioner.
   1. This is the step that takes quite awhile if you don't already have the box down. Once you see this working, I would shift gears to something else for awhile.
 1. Call `vagrant halt`.
 1. Call `vagrant up --no-provision` to bring the box back up.
 1. Now we are ready to grab a snapshot from which to start from `vagrant sandbox on`
 1. In `Demo/Vagrantfile` please comment out the shell provisioner and uncomment the puppet provisioner that you commented out in step 1.
 1. This is it for exercise 0.

 **NOTE:** When performing a `vagrant sandbox rollback` please remember to also run `vagrant reload` to reset shared folders.
