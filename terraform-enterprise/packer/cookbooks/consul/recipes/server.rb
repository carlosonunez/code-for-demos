cookbook_file "/etc/consul.d/config.json" do
  source "server_config.json"
  action :create
end
