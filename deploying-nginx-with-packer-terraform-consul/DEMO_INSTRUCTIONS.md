Installing Packer
==================

See $HOME/.bash_packer_specific for installation instructions.

Creating the Packer build template
====================================

1. Start with the 'builder' section. Use 'amazon-ebs' if demo-ing with EC2 or 
'virtualbox' if demo-ing with Vagrant.

2. Move onto the 'provisioner' section. Use 'ansible' if deploying with Ansible or 
'chef-solo' if deploying with Chef.

3. Create a dummy 'post-provisioner' to demonstrate how post-provisioners work.

Creating the Chef cookbook
============================

1. Download the chef-dk. See the downloads page: https://packages.chef.io/files/stable/chefdk/2.1.11/ubuntu/16.04/chefdk_2.1.11-1_amd64.deb. 
Apparently, one can download it from rubygems; I haven't tried it, however.

2. Create a directory called 'cookbooks' in the root directory.

3. `cd` into 'cookbooks', then use `knife cookbook create` to create the `base` and `nginx` 
recipes.
