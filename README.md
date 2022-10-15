# terraform-aws-eks-external-dns

A terraform module for provisioning an external DNS controller to an EKS cluster

## Usage

### Using module defaults

The following will create an external-dns controller in an EKS cluster

```HCL
module "external-dns" {
  source            = "KongHQ-CX/eks-external-dns/aws"
  zone_id           = var.zone_id
  zone_type         = "public"
  oidc_provider_arn = module.cluster-1.0.oidc_provider_arn
  region            = var.region
  vpc_id            = module.vpc.vpc_id
}
```

## Misc

This module uses the IRSA policies from [this](https://github.com/terraform-aws-modules/terraform-aws-iam)
TF AWS module and the bitnami helm
[chart](https://artifacthub.io/packages/helm/bitnami/external-dns) to configure
and deploy external-dns
