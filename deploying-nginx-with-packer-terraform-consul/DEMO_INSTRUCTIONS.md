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

Deployment
==========

If you're starting from scratch, you'll need to create a VPC and subnet that can access the internet.

Here is a snippet on how you can do this with awscli.

```
aws ec2 create-vpc --cidr-block "10.1.0.0/16"
aws ec2 create-subnet --cidr-block "10.1.1.0/24" --vpc-id vpc-dfe6bfa6
aws ec2 attach-internet-gateway --internet-gateway-id igw-39aaaf5f --vpc-id vpc-dfe6bfa6
aws ec2 create-route-table --vpc-id vpc-dfe6bfa6
aws ec2 create-route --gateway-id igw-39aaaf5f --route-table-id rtb-db9a68a0 --destination-cidr-block "0.0.0.0/0"
aws ec2 associate-route-table --route-table-id rtb-db9a68a0 --subnet-id subnet-ed4aabd2
```

Once finished, deploy using `./build.sh`:

```
$> ./build.sh ./nginx-centos-7-x86-64.json vpc-dfe6bfa6 subnet-ed4aabd2
```

To destroy your temporary VPC, undo what you just did:
