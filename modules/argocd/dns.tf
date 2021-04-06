data "kubernetes_service" "kube_svc" {
  metadata {
    name      = var.kube_service_name
    namespace = var.kube_service_namespace
  }
}

data "aws_route53_zone" "zone" {
  name = var.hosted_zone
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.service_subdomain}.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = 60
  records = [data.kubernetes_service.kube_svc.load_balancer_ingress.0.hostname]
}
