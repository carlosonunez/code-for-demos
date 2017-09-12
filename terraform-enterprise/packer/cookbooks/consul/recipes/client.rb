cookbook_file "/etc/consul.d/config.json" do
  source "client_config.json"
  action :create
end
