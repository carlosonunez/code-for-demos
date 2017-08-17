execute 'yum update' do
  command 'sudo yum -y update'
end

execute 'enable EPEL' do
  command 'sudo yum -y install epel-release'
end
