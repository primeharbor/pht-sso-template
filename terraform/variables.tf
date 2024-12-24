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


variable "default_session_duration" {
  description = "Session Duration (PT8H)"
  type        = string
  default     = "PT8H"
}

variable "default_permissions_boundary_policy_name" {
  description = "If set, this policy (name) will applied as a permission boundary to all assignments. The Policy must exist in assigned accounts."
  type        = string
  default     = ""
}

variable "sso_assignments" {
  description = "Map of all the AWS Account Assignments"
  default     = {}
}

variable "groups" {
  description = "Map of Identity Center Groups to create manually (not via SCIM)"
  default     = {}
}

variable "include_root" {
  description = "Include the Org Management account when using the account id keywork 'ALL' "
  type        = bool
  default     = false
}