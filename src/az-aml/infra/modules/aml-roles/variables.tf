variable "rg_name" {
  type        = string
  description = "Name of the existing RG"
}

variable "group_name" {
  #type        = list(string)
  type        = string
  description = "Display Name of AD Group to apply roles against"
  # fixing type 
}
#variable "roles" {
#  type        = list(string)
#  description = "List of roles to grant the groups"
#}
