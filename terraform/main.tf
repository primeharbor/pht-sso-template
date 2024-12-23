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
# Configure Terraform & the providers
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82"
    }
  }

  required_version = ">= 1.9"

  backend "s3" {
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  default_tags {
    tags = {
      Application = "AWS Identity Center"
      ManagedBy   = "Enter GitHub Repo Here"
    }
  }
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