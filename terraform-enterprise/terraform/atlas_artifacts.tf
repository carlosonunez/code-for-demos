data "atlas_artifact" "consul_image" {
  name = "carlosonunez/consul"
  type = "amazon.image"

  // You can version your Atlas artifacts, just like anything else!
  build = "latest"
}

data "atlas_artifact" "nginx_image" {
  name = "carlosonunez/nginx"
  type = "amazon.image"
  build = "latest"
}
