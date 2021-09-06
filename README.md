# aws-promo-terraform
## What is this repo?
This repo contains the underlying infrastructure for the Promo site migration on Shared Services and Heritage AWS account.

## The Groups of Terraform

### groups/promo-proxy
Contains the resources that build the ALB for Finance proxies.  Note - this is a temporary solution to replace the proxies from the promo server until the proxied services themselves get migrated.

### groups/infrastructure
Contains the resources that build the S3 web hosting for static and dynamic content and redirects and CloudFront service.