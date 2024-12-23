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
# Group ID - Terrform requires the GUID for the group rather than the name
#
data "aws_identitystore_group" "group" {
  identity_store_id = local.identity_store_id
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.group_name
    }
  }
}

#
# Assign this permission set to all the explictly listed AWS accounts
#
resource "aws_ssoadmin_account_assignment" "account_group_assignment" {
  for_each           = var.aws_account_ids
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.group.id
  target_id          = each.value
  target_type        = "AWS_ACCOUNT"
}

#
# Assign this permission set to all the AWS accounts that are part of
# var.target_ou_name
#
resource "aws_ssoadmin_account_assignment" "ou_group_assignment" {
  for_each           = local.target_ou_accounts
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.group.id
  target_id          = each.value
  target_type        = "AWS_ACCOUNT"
}

#
# Special handling in order to get the AWS accounts in an OU
#

# First define the org
data "aws_organizations_organization" "org" {}

# Get a list of all under the root, this includes nested OUs.
data "aws_organizations_organizational_unit_descendant_organizational_units" "all_ous" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# Turn that into a map of name => id
locals {
  ou_name_to_id_map = {
    for ou in data.aws_organizations_organizational_unit_descendant_organizational_units.all_ous.children :
    ou.name => ou.id
  }
}

# Now get a list of AWS Account IDs from that OU.
data "aws_organizations_organizational_unit_descendant_accounts" "target_ou_accounts" {
  count     = var.target_ou_name != null ? 1 : 0
  parent_id = local.ou_name_to_id_map[var.target_ou_name]
}

# Turn that into a set of account IDs to pass to the foreach variable.
# Or pass an empty set if the var.target_ou_name is not defined
locals {
  target_ou_accounts = var.target_ou_name != null ? toset([
    for a in data.aws_organizations_organizational_unit_descendant_accounts.target_ou_accounts[0].accounts :
    a.id
  ]) : toset([])
}


