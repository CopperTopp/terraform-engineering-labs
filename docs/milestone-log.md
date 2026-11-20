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
- Verified S3 state locking blocks concurrent operations and that canceling the owning operation releases
  the lock; confirmed a subsequent no-change plan.

### Snapshot comparison

- Compared S3 state snapshots with matching lineage and serials 1 and 2.
- Confirmed terraform_data.renamed retained its ID.
- Found that local_file.drift_demo retained its filename but had different
  recorded content and IDs.
- Serial 1 recorded the original content containing a typo.
- Corrected the configured content from "Mangfed by Terraform." to
  "Managed by Terraform."
- Applying the correction replaced local_file.drift_demo; serial 2
  records the corrected content and changed ID.
- Established that an older state snapshot must be assessed against both
  configuration and actual resources before restoration.
- Attempted to push serial 1 over remote serial 2 without force.
- Terraform rejected the stale snapshot with exit code 1.
- Completed remote-state recovery using a verified backup.
- Demonstrated stale-serial and equal-serial/different-content safeguards.
- Used a deliberate forced restore after comparing lineage and resource
  attributes; verified recovery with a no-change plan and exit code 0.

## Lab 04 - Automated Validation and CI
- Established Lab 04's credential-free Terraform validation baseline
  using typed service definitions and built-in terraform_data resources.
- Verified formatting and configuration validation locally.

## Instituted Tests at Lab End
- Decided to point this training at getting Terraform's Certification.
- Instituted the following
  - At the end of each lab, a test of the quality of the certification 
    exam will be given regarding the content of that lab.
  - Further, questions regarding previous labs will be added to reinforce 
    retention.
  - Any failed questions will require redoing the entire lab, going back 
    as far as the lab the failed question came from.
  - Using ChatGPT, questions will never repeat to prevent mere 
    memorization.
- At the end of all labs, pre-tests will be taken under exam conditions.
- Depending on the failures, the entire set of labs may be redone.

## Lab 01 - Retake
- Started Lab End tests with Lab 01.
  - Failed 2 of 12 questions due to wording.
  - Still a failure due to learning industry terminology and understanding.
- Redoing Lab 01
  - Lesson Targets
    - Explain how Terraform combines configuration files into a module.
    - Distinguish resource types, local labels, arguments, attributes, 
      and instance addresses.
    - Define input contracts using primitive and collection types.
    - Separate supplied inputs from values derived through locals.
    - Select environment values using variable-definition files.
    - Transform and filter collections with expressions.
    - Write validation conditions and useful error messages.
    - Manage resource instances using stable for_each keys.
    - Refactor resource addresses while preserving their identity.
    - Interpret formatting, validation, plan results, and exit codes.
    - Explain provider version constraints and dependency-lock-file 
      responsibilities.
### Stage 1 - Preparation
- Terraform init lab-retake/01-configuration-and-types folder.
- Create versions.tf, variables.tf, and practice.env.tfvars files.
### Stage 2 - Load and instpect inputs
- Created variable definitions in variables.tf, then implemented 
  inputs of those variables in practice.env.tfvars.
  - Used `terraform console` to examine variable values and undertand
    its dot notation.
### Stage 3 - Derive values with locals
- Added locals.tf creating local. derived variables combining var. variable
  inputs.
  - Verified values with `terraform console`.
### Stage 4 - Represent a component as a resource
- Create main.tf and added `terraform_data` resource with inputs to describe a few values.
- Ran `terraform plan -var-file="practice.env.tfvars"` and validated results.
### Stage 5 - Apply and instpect the recorded resource
- Ran `terraform apply` to apply the values, then used `terrafrom state list`
  and `terraform state show <path>` to inspect created values.
- Explored the difference between a `resource` and `resource instance` to
  understand how each is applied and represented.
### Stage 6 - Expose selected information with outputs
- Added outputs.tf and created `output` blocks to show how to expose attributes to parent modules.
- Applied and examined `output` results after apply.
- Used `terraform output` to examine and verify results.
- Explored the differences between `terraform output`'s no, -raw, and -json flags,
  using PowerShell's ConvertFrom-Json for maps and objects.
- Learned about how `output` blocks expose internal values from a child module 
  to the calling parent.
### Stage 7 - Override inputs and trace their effects
- Used `-var` command line to change input values to the root-module.
- Validated that changes were not saved in the state after the apply by using 
  `terraform output -raw` to show that the value in the state file didn't change.
### Stage 8 - Validate the environment input
- Added a `validation` block to the `environment` variable, validating that
  the value would be one of 'practice', 'review', or 'production'.
- Used `terraform plan -var="environment=<value>` to test the validation with
  correct and incorrect values to see that it fails as expected.
### Stage 9 - Transform a collection with a `for` expression
