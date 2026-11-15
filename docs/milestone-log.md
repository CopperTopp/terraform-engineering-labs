# Milestone Log

This log records completed work and supporting evidence.
Planned work belongs in the learning roadmap.

## Repository Setup — 2026-11-04

### Completed

- Created the terraform-engineering-labs GitHub repository.
- Cloned the repository locally.
- Created docs, labs, and troubleshooting directories.
- Created the roadmap, milestone log, and terminology files.

### Evidence

- Repository setup commit: add link after committing.

## Lab 01 — Configuration and Types

### Verified the starting configuration and transferred local state

- Established a clean baseline in the original EKS lab with
  `terraform fmt -check`, `terraform validate`, and a no-change plan.
- Copied the configuration, provider lock file, and local state into
  Lab 01. Verified a no-change plan from the new location and designated
  Lab 01 as the active configuration for those AWS resources.
- Verified Git exclusions for Terraform state and generated files.
  Added a repository line-ending policy through `.gitattributes`.

### Refactored existing AWS resources without replacement

- Consolidated repeated subnet settings into a local value and verified
  a no-change plan.
- Replaced separate subnet and route-table association blocks with
  chained `for_each` resources. Used `moved` blocks to preserve the
  existing AWS objects while changing their Terraform addresses.
- Applied tag updates after identifying and correcting an unintended
  IAM role replacement in the plan.
- Diagnosed a mistyped source address in `moved.tf`. The configuration
  passed validation, but the plan proposed creation and destruction.
  Corrected the address and applied the two association moves with
  zero resources added, changed, or destroyed.

### Added validated inputs and expanded the network

- Defined subnet inputs as a typed map of objects and separated the
  environment values into `lab.env.tfvars`. Updated `.gitignore` to
  allow versioning non-secret `*.env.tfvars` files.
- Exercised custom validation errors for malformed IPv4 CIDRs,
  fractional AZ indexes, and indexes outside the available AZ range.
- Replaced numeric AZ indexes with suffix matching based on subnet
  keys. Added separate validation messages for zero and multiple
  matches.
- Applied subnet `c` and its route-table association by adding an entry
  to the environment inputs. The existing resource blocks handled both
  additions.

### Defined network outputs

- Added and committed outputs for the VPC ID and public subnet IDs
  keyed by subnet identifier.

## Lab 02 — Modules and Environments

### Extracted the reusable network module

- Created a child network module with its own provider requirement,
  typed subnet inputs, validation rules, and outputs.
- Created a separate root configuration that supplies subnet settings,
  configures the AWS provider, and exposes the child module's outputs.
- Verified a fresh-state plan with 9 to add, 0 to change, 0 to destroy,
  and exit code 2. This was a plan-only checkpoint.
- Verified two root configurations could import the network module,
  with separate input variables and states.

### Parameterized VPC address ranges by environment

- Replaced the shared network module's hardcoded VPC CIDR with a
  required input supplied by each root configuration.
- Verified that lab plans a `10.0.0.0/16` VPC with three subnets
  and test plans a `10.1.0.0/16` VPC with two subnets.
- Both plans reused the same module and proposed zero changes
  or destroys.

### Parameterized Environment Name in Name Tags

- Added environment variable to lab and test root main.tf files, and
  network module's variables.tf file.
- Set environment variable to "lab" in lab.env.tfvars and "test" in
  test.env.tfvars.
- Validated that environment variable was picked up in Name Tags.
- Added Validation to new variable environment.
- Updated Validation to show the failed value(s) in error_messages.

## Lab 03 — State, Import, and Recovery

### Preserved resource identity during a rename

- Renamed `terraform_data.example` to `terraform_data.renamed` and
  observed that the initial plan proposed one creation and one destruction.
- Added and applied a `moved` block with zero resources added, changed,
  or destroyed.
- Verified that state listed the new address with the original ID and
  that the follow-up plan reported no changes with exit code `0`.
- Removed `terraform_data.renamed` then imported again.  Same Id created but
  `renamed` is otherwise empty. terraform plan showed `renamed` will be changed 
  with the value in main.tf.  terraform apply restored `renamed` values.

### Transferred a resource between local state files

- Used `terraform state mv` to transfer a resource from a working copy
  of the backup into a separate scratch state file.
- Verified that the destination preserved the saved `input` and `output`
  before any apply. The earlier CLI import restored only the supplied ID.

### Restored state from backed up state file

- Created new folder to replicate current lab terraform state.
- Created backup of state file, a copy of the lab state file with renamed state.
- Ran init to create new blank state file and verified missing state with state
  list and plan commands.
- Restored backup of state file with file copy.
- Ran state list and show, then plan to verify state had been restored.

### Drift detection

- Create drift.tf creating a file.  Apply.
- Manually delete file.
- Run `terraform plan -refresh-only`.
  - Note that the missing file is acknowledged, but will not be created.
  - Running `terraform apply -refresh-only` would update the state file to remove
    the deleted file, getting state in sync with the real world changes.
- Run `terraform plan`.
  - Note that the missing file is acknowledged, and is noted that it will be created.
  - Running `terraform apply` will create the file, geting the real world in sync
    with the state file.
- Summary
  - Without `-refresh-only`, resources are put in the state of the state file.
  - With `-refresh-only`, the state file is updated to reflect the curent state of the resources.

### Remote state file restore

- Create S3 Bucket to later store state file in.  IaC for bucket in backend-bootstrap folder.
- Migrated Lab 03 state to an S3 backend with bucket versioning and native state locking.
- Resolved a stale migration lock after identifying missing s3:DeleteObject permission on the lock object.
- Recreated the deliberately deleted local file and verified a no-change plan against remote state.
