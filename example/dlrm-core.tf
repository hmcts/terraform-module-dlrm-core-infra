module "core-infra" {
  source = "./.."
  env    = "sbox"
  common_tags = {
    "product"   = "dlrm"
    "component" = "core"
  }
  project = "dlrm-project-a"
}
