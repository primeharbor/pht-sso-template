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

# Fetch the root Organizational Unit (OU)
data "aws_organizations_organization" "org" {}

# Get List of all Accounts
locals {

  # A delegated admin account cannot modify permission sets assigned in the org management account
  # By setting the include_root flag, we can _try_ to exclude that account from being
  # manipulated when using the ALL keyword.
  active_account_ids = var.include_root == false ? [
    for account in data.aws_organizations_organization.org.non_master_accounts :
    account.id if account.status == "ACTIVE"
    ] : [
    for account in data.aws_organizations_organization.org.accounts :
    account.id if account.status == "ACTIVE"
  ]

  management_account_id = data.aws_organizations_organization.org.master_account_id
}
