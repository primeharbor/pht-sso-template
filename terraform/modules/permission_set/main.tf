# Copyright 2024 Chris Farris <chris@primeharbor.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Module Variables
#
variable "group_name" {
  description = "Name of the Identity Center Group to be bound up with this permission set"
  type        = string
  default     = null
}

variable "group_id" {
  description = "ID of a Group defined in Terraform"
  type        = string
  default     = null
}

variable "permission_set_name" {
  description = "Name of the Permission Set to Create"
  type        = string
}

variable "aws_account_ids" {
  description = "List of Account IDs that this Group/Permission Set will be applied to"
  type        = set(string)
}

variable "description" {
  description = "Verbose description for resources"
  type        = string
}

variable "session_duration" {
  description = "Default Session Duration"
  type        = string
  default     = "PT8H"
}

variable "permission_boundary" {
  description = "If set, this policy (name for customer-managed or arn for aws-mananged) will applied as a permission boundary. The a customer policy must already exist in assigned accounts."
  type        = string
  default     = ""
}

variable "json_policy_file" {
  description = "(optional) Path to a custom json file with special policy statements"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "List of Managed Policy Arns to apply to the permission set"
  type        = set(string)
  default     = []
}

variable "relay_state" {
  description = "Console URL to direct the user to upon login."
  type        = string
  default     = null
}

variable "target_ou_name" {
  description = "If specified, all accounts under this target OU will be assigned the permission set"
  type        = string
  default     = null
}

#
# AWS SSO Instance Data
#
# This allows terraform to reference attributes of the AWS SSO Identity Storey
#
data "aws_ssoadmin_instances" "identity_store" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.identity_store.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.identity_store.arns)[0]
}


