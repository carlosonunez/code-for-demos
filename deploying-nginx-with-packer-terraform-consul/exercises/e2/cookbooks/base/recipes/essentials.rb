node[:base][:essential_packages].each do |package|
  execute "Installing package #{package}" do
    command "sudo yum -y install #{package}"
  end
end
