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

default_session_duration = "PT8H"
include_root             = false

sso_assignments = {

  CloudAdminAccess = {
    group_name          = "aws-admin"
    description         = "Grant Cloud Team Admin Access"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    session_duration    = "PT2H"
    aws_account_ids     = ["ALL"]
  }

  CloudAdminReadOnly = {
    group_name          = "aws-admin"
    description         = "Grant Cloud Team ReadOnly Access"
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    aws_account_ids     = ["ALL"]
  }

  security_admin = {
    group_name          = "aws-security"
    description         = "Grant Security Team Admin Access"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    aws_account_ids = [
      # Insert Security Accounts Here
    ]
  }

  security_audit = {
    group_name          = "aws-security"
    description         = "Grants Security Team Audit Access"
    session_duration    = "PT12H"
    json_policy_file    = "policies/security_tooling.json"
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess", "arn:aws:iam::aws:policy/SecurityAudit"]
    aws_account_ids     = ["ALL"]
  }

  security_response = {
    group_name          = "aws-security"
    description         = "Grants Security Team Admin Access for IR and Remediation"
    session_duration    = "PT4H"
    json_policy_file    = "policies/incident_responder_permissions.json"
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess", "arn:aws:iam::aws:policy/SecurityAudit"]
    aws_account_ids     = ["ALL"]
  }

  sandbox_user = {
    group_name          = "aws-sandbox-users"
    description         = "Grants Admin Perms to the Sandbox Accounts"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    aws_account_ids     = []
    target_ou_name      = "ScratchAccounts"
  }

  developer_poweruser = {
    group_name          = "aws-developers"
    description         = "Developer PowerUser"
    managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
    aws_account_ids     = []
    target_ou_name      = "Workloads"
  }

  developer_readonly = {
    group_name          = "aws-developers"
    description         = "Developers (readonly)"
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    aws_account_ids     = []
    target_ou_name      = "Workloads"
  }

}

groups = {

  aws_security = {
    display_name = "aws-security"
    description  = "Security Team with access to AWS for Audit and Response"
  }

  aws_sandbox_users = {
    display_name = "aws-sandbox-users"
    description  = "Grants Admin Perms to the Sandbox Accounts"
  }

  aws_developers = {
    display_name = "aws-developers"
    description  = "Non-DevOps team"
  }

}