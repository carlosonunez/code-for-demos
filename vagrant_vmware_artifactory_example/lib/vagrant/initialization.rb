#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

def set_default_vagrant_provider_to_vmware!
  provider_to_set = 'vmware_fusion'
  if ENV['OS'] == 'Windows_NT'
    provider_to_set = 'vmware_workstation'
  end
  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_workstation'
end

def vmware_plugin_missing?
  vmware_plugin_to_find = 'vagrant-vmware-fusion'
  if ENV['OS'] == 'Windows_NT'
    vmware_plugin_to_find = 'vagrant-vmware-workstation'
  end 
  plugin_retrieval_command_result = `vagrant plugin list`
  matching_vmware_plugins_found = 
    plugin_retrieval_command_result.split("\n").select do |plugin_name|
      plugin_name.start_with? vmware_plugin_to_find
    end
  matching_vmware_plugins_found.empty?
end

def configuration_file_exists?
  config_file_path = get_configuration_file_path
  config_file_path_alternate_filetype = config_file_path.gsub /\.yaml/,'.yml'
  (File.exist? config_file_path) || 
    (File.exist? config_file_path_alternate_filetype)
end


require 'yaml'
def get_vagrant_configs
  yaml = YAML.load_file(get_configuration_file_path)
  yaml['config']
end

def get_configuration_file_path
  this_path = File.expand_path File.dirname(__FILE__)
  "#{this_path}/../../conf/vagrant_config.yaml"
end
