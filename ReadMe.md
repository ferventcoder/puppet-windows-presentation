Puppet On Windows
==================================

## Presentation

In the `Presentation` directory. You will need Keynote or something that can open Keynote. There are also PDF files of past presentations.

## Demo Prerequisites

 * [Vagrant 1.5.4](http://downloads.vagrantup.com/tags/v1.5.4) or greater.
 * [VirtualBox 4.2.16](https://www.virtualbox.org/wiki/Downloads) or greater (or VMWare Fusion 5+).
    * If you want to use VMWare Fusion you will also need the vagrant-vmware-fusion plugin for vagrant (which is not free). You also want the latest version (at least 0.8.5).
 * Vagrant-Windows (if you are using a Vagrant version less than 1.6.0).
 * At least 20GB free on the host box.
 * Vagrant Sahara plugin for sandboxing.

## Demo - System Setup
 1. Install/upgrade Vagrant to 1.5.4 or greater. I recommend 1.8.x or any version of Vagrant at or past the `.z` of `3` (as in `1.7.3`).
 1. Install/upgrade VirtualBox/VMWare to versions listed above.
 1. Install/upgrade required plugins for vagrant (if using VMWare you will need the non-free vagrant-vmware-fusion or equivalent).
 1. Vagrant 1.5.4 (and below) - Install/upgrade vagrant-windows vagrant plugin. Open terminal/command line and type `vagrant plugin install vagrant-windows`
 1. Install/upgrade `sahara` vagrant plugin - `vagrant plugin install sahara`.
 1. Use the provided Atlas box or find a Windows 2012 x64 vagrant basebox. [Atlas has some](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=&q=windows) - If you have the VMWare plugin, you can take a look at [these](https://atlas.hashicorp.com/opentable/). Follow the instructions for what to update in the VagrantFile to take advantage of using that box. A couple of box choices have been added to the Vagrantfile in comments.

## Demo - Offline Setup
 1. Complete the steps above.
 1. Download all packages referenced in `puppet/manifests/provision.pp` to `resources/packages`.
 1. Download the installers to `resources/packages/installers` and edit the packages to point to that location.
 1. Then uncomment the resource default source for Package (Chocolatey) in `provision.pp`.
 1. You must have internet to bring up the box through Exercise 0 below (at least the first time). After that you won't need internet.

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
 * Look over `Demo/VagrantFile`.

### Exercise 1 - Puppet apply
 1. Open up `Demo/puppet/manifests/provision.pp` and take a look at it.
 1. Run `vagrant provision`. Note the changes that are made.
 1. Run `vagrant provision` again. Note that Puppet reports nothing changes.
 1. Play around with some of the resources, making changes, running `vagrant provision` and note how they change the files on the system.
 1. Change things on the file system and note how Puppet fixes configuration drift automatically.
 1. This concludes Exercise 1.

### Exercise 2 - Chocolatey Simple Server
 1. Open up `Demo/puppet/modules/chocolatey_server/manifests/init.pp` and take a look at it (no changes necessary).
 1. In `Demo/puppet/manifests/provision.pp` uncomment the line `include chocolatey_server` (or the lines below it for offline).
 1. Open up an internet browser on the host (not the guest VM) and navigate to `http://localhost:8090/`. Note that is it not a working url.
 1. Run `vagrant provision`.
 1. Note what changes are happening on the system as it installs and sets up everything for you.
 1. Reload the url `http://localhost:8090/`. Note what is now available.
 1. Also click on the link for packages. Note that it is mostly empty (no packages are being served yet).
 1. You've set up a custom package repository.
 1. This concludes Exercise 2.

### Exercise 3 - Update/Push a Package
 1. From the Windows box, navigate to `C:\vagrant\resources\packages` and copy `chocolatey.server.0.1.1.nupkg` out to `c:\vagrant\resources`. Rename it to `chocolatey.server.zip`.
 1. Extract it and delete `[Content_Types].xml`, `_rels` folder, and `package` folder. These are packaging related items that must be removed to repack.
 1. Open the `nuspec` and change version to `0.1.2`.
 1. Open `tools\chocolateyInstall.ps1` and find line 44. We need to fix a packaging issue. It should be `Copy-Item $webToolsDir\* $webInstallDir -recurse -force`.
 1. Open `tools\chocolatey.server\Default.aspx`. Find the `h2` tag and add ` v2` to the end to signify something has changed.
 1. Save and close those files.
 1. On a command line, navigate to `c:\vagrant\resources\chocolatey.server` and run `choco pack`.
 1. Run `choco list -s http://localhost/chocolatey`. Note that there are 0 packages.
 1. Run `choco push -s http://localhost`. Note that it denies the request, asking for an API key. That can be retrieved (and changed) from `c:\tools\chocolatey.server\Web.config` at about line 73.
 1. Now run `choco push -s http://localhost -k APIKeyYouRetrieved`. Note how it pushes the package.
 1. Run `choco list -s http://localhost/chocolatey`. Note that there is 1 package listed.
 1. Open up an internet browser on the host (not the guest VM) and navigate to `http://localhost:8090/Packages`. Note now there is more information available as a package has been pushed.
 1. You've now taken an existing package, updated it, and pushed it to an internal package repository.
 1. This concludes Exercise 3.

 NOTE: Alternatively, you can just copy the nupkg file to `C:\tools\chocolatey.server\App_Data\Packages`. However it is recommended to get the first way to work as it represents a real-world scenario for pushing packages once tested, approved and ready for production (or the next environment).

### Exercise 4 - Puppet Install of Updated Package
 1. The chocolatey_server module isn't quite right on the package. It should ensure latest but it currently doesn't. I've made the adjustment locally already, so this is FYI. In `Demo/puppet/modules/chocolatey_server/manifests/init.pp` around line 40, a change was made from `ensure => installed` to `ensure => latest`.
 1. In `Demo/puppet/manifests/provision.pp`, find `class 'chocolatey_server'` and update it to `server_package_source => 'http://localhost/chocolatey'`.
 1. Open up an internet browser on the host (not the guest VM) and navigate to `http://localhost:8090`. Note that the heading doesn't include `v2`.
 1. Run `vagrant provision`.
 1. Reload `http://localhost:8090`. Note that the heading now includes `v2`.
 1. You've installed the updated package.
 1. This concludes Exercise 4.

### Exercise 5 - More Resources
 1. Discovery - Open a command line on the guest system (the VM) and type `puppet resource user`. Try this for other resource types.
 1. Implement a scheduled task resource to open notepad on Mondays at 2PM every week.
 1. Implement a host resource to set `puppetmaster` to an IP address.
 1. Hook the Windows 2012 box up to a Puppet Master.
 1. Create a package - see https://github.com/ferventcoder/puppet-chocolatey-presentation#exercise-1---create-a-package for details.


