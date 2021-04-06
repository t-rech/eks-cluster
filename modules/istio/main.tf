resource "null_resource" "cluster" {
  triggers = {
    istio_operator_sha1 = sha1(file("istio-operator.yaml"))
  }

  provisioner "local-exec" {
    command = "bash install_istio.sh"
  }
}

resource "null_resource" "destroy_istio" {
  provisioner "local-exec" {
     when = destroy
     command = "bash delete_istio.sh"
    }
}
