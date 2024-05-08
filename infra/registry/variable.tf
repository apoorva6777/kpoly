variable "compartment_id" {
  description = "Display name used for compartment"
  type        = string
  default     = "ocid1.compartment.oc1..aaaaaaaafujaxb5oanlmpe4nuyzxjircz6cfm75pqp5b2cjqbri6de4qy7gq"
}

##################################################
# registry variables
##################################################

variable "oci_artifacts_container_repository_display_name" {
  description = "Display name for the Oracle Cloud Infrastructure (OCI) Artifacts Container Repository."
  type        = string
  default     = "nodetest"
}

variable "oci_artifacts_container_repository_display_name_two" {
  description = "Display name for the Oracle Cloud Infrastructure (OCI) Artifacts Container Repository."
  type        = string
  default     = "djangotest"
}
variable "oci_artifacts_container_repository_display_name_three" {
  description = "Display name for the Oracle Cloud Infrastructure (OCI) Artifacts Container Repository."
  type        = string
  default     = "springtest"
}

variable "oci_artifacts_container_repository_is_public" {
  description = "Indicates whether the OCI Artifacts Container Repository is public or private."
  type        = bool
  default     = false
}

variable "oci_artifacts_container_repository_is_immutable" {
  description = "Indicates whether the OCI Artifacts Container Repository is immutable."
  type        = bool
  default     = false
}

variable "oci_artifacts_container_repository_readme_content" {
  description = "Content of the README file for the OCI Artifacts Container Repository."
  type        = string
  default     = "kj-test-registry"
}

variable "oci_artifacts_container_repository_readme_format" {
  description = "Format of the README file for the OCI Artifacts Container Repository."
  type        = string
  default     = "text/plain"
}

##################################################
# tags variables
##################################################

variable "free_form_tag_key" {
  description = "A free-form tag key that can be used to categorize resources. This key is customizable based on your organization's tagging conventions."
  type        = string
  default     = "Department"
}

variable "free_form_tag_value" {
  description = "A free-form tag value associated with the specified tag key. This value provides additional information about the resource, such as its department or purpose."
  type        = string
  default     = "kj"
}

