data "aws_route53_zone" "this" {
  zone_id      = var.zone_id
  private_zone = var.zone_id == "private" ? true : false
}

module "this_role" {
  count  = var.create_role ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${var.cluster_name}-eks-dns"
  attach_external_dns_policy    = var.create_role
  external_dns_hosted_zone_arns = [data.aws_route53_zone.this.arn]
  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.service_account}"]
    }
  }
}

resource "kubernetes_service_account" "service-account" {
  count = var.create_service_account ? 1 : 0
  metadata {
    name      = var.service_account
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name" = var.service_account
    }
    annotations = {
      "eks.amazonaws.com/role-arn" : module.this_role.0.iam_role_arn
    }
  }
}

resource "helm_release" "dns" {
  count      = var.create_deployment ? 1 : 0
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = var.namespace
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.zoneType"
    value = var.zone_type
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "txtOwnerId"
    value = var.owner_id
  }

  set {
    name  = "domainFilters[0]"
    value = data.aws_route53_zone.this.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account
  }

  set {
    name  = "aws.region"
    value = var.region
  }

  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }

  set {
    name  = "podSecurityContext.runAsUser"
    value = "0"
  }
}
