variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}

variable "project" {
  description = "The name of the DLRM project, this will feature in resource names."
  type        = string
}
