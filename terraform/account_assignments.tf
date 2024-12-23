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
# Create and Assign the Permission Set to a Group for a list of accounts
#
module "permission_set_assignment" {
  for_each            = var.sso_assignments
  source              = "./modules/permission_set"
  permission_set_name = each.key
  group_name          = each.value["group_name"]
  description         = each.value["description"]
  session_duration    = lookup(each.value, "session_duration", var.default_session_duration)
  json_policy_file    = lookup(each.value, "json_policy_file", "")
  managed_policy_arns = lookup(each.value, "managed_policy_arns", [])
  aws_account_ids     = each.value["aws_account_ids"] == ["ALL"] ? local.active_account_ids : each.value["aws_account_ids"]
  target_ou_name      = lookup(each.value, "target_ou_name", null)
}