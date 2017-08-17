remote_file '/tmp/consul.zip' do
  download_url_parts = [
    'consul',
    node[:consul][:version],
    "consul_#{node[:consul][:version]}_linux_amd64.zip"
  ]
  download_url = "https://releases.hashicorp.com/#{download_url_parts.join('/')}"

  source download_url
  action :create
end
