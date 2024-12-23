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
# Create the permission set, and attach any managed or custom policies
#
resource "aws_ssoadmin_permission_set" "permission_set" {
  name             = var.permission_set_name
  description      = var.description
  instance_arn     = local.instance_arn
  relay_state      = "https://s3.console.aws.amazon.com/s3/home?region=us-east-1#"
  session_duration = var.session_duration

}

resource "aws_ssoadmin_permission_set_inline_policy" "custom_permission_set_policy" {
  count              = var.json_policy_file != "" ? 1 : 0
  depends_on         = [aws_ssoadmin_permission_set.permission_set]
  inline_policy      = file(var.json_policy_file)
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "managed_policy_attachments" {
  for_each           = var.managed_policy_arns
  depends_on         = [aws_ssoadmin_permission_set.permission_set]
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  managed_policy_arn = each.value
}
