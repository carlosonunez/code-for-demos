# What is this?

This will let you provision your own Vagrant VMWare instances from boxes stored within Artifactory.

# How to test it

You will need the following:

- Vagrant
- vagrant_vmware_workstation Vagrant plugin
- VMware Workstation (Windows) or Fusion (Mac)

1. Download Vagrant from Hashicorp. (If you have a Windows workstation,
[install Chocolatey](https://chocolatey.com) (admin privileges required), then
restart Powershell and run `choco install vagrant`. If you have a Mac,
[download Homebrew](https://homebrew.io) (root required) and run
`brew install vagrant`.

2. Install the Vagrant VMware Workstation provider: 
`vagrant plugin install vagrant-vmware-workstation`

(If you're on a Mac, install the Fusion provider instead: `vagrant plugin vagrant-vmware-fusion`)

3. Install VMware Workstation:
  a. Windows: `choco install vmware_workstation`
  b. Mac: `brew install vmware_workstation`

4. Install the license for the Vagrant VMware Workstation provider:
`vagrant  plugin license vagrant-vmware-workstation C:\path\to\license.lic`

5. Confirm that the plugin is now listed: `vagrant plugin list | grep vmware`

6. Create a file called `vagrant_conf.yml` in the `conf` directory. An example is provided.

7. From this directory, run: `vagrant up`

This will query Artifactory for the most recent box available,
download its box file and tell Vagrant to initialize it in VMware workstation.
If you want to fetch a different OS, set LINUX_FLAVOR in your environment.
