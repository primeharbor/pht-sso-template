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

ifndef env
$(error env is not set)
endif


#
# Terraform
#
tf-init:
	cd terraform && $(MAKE) tf-init

tf-plan:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-plan

tf-apply:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-apply

tf-output:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-output

tf-refresh:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-refresh

# Does a terraform apply w/o making a plan
tf-force:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-force

tf-show:
	@./scripts/safety-check.sh $(env)
	@cd terraform && $(MAKE) tf-show

tf-plan-fetch:
	@./scripts/safety-check.sh $(env)
	@cd terraform && $(MAKE) tf-plan-fetch

tf-plan-save:
	@./scripts/safety-check.sh $(env)
	@cd terraform && $(MAKE) tf-plan-save

tf-execute: tf-plan tf-apply

tf-destroy:
	@./scripts/safety-check.sh $(env)
	cd terraform && $(MAKE) tf-destroy
