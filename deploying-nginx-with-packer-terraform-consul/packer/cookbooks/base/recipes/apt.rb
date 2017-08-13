execute 'yum update' do
  command 'sudo yum update'
end

execute 'enable EPEL' do
  command 'sudo yum install epel-release'
end
