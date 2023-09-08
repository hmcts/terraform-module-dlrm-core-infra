module "core-infra" {
  source = "git::https://github.com/hmcts/terraform-module-dlrm-core-infra.git?ref=main"
  env    = "sbox"
  common_tags = {
    "product"   = "dlrm"
    "component" = "core"
  }
  project = "dlrm-project-a"
}
