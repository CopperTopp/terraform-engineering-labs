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
- Add local.component_settings to iterate over var.components, defining a new
  map with name as local.deployment_prefix concatenated with key, captured 
  instance_size, and captured replicas.
- Ran `terraform console` to examine and validate var.components map was transformed
  to var.component_settings correctly.
### Stage 10 - Use the collection to declare resource instances
- Modify the "gateway" resource block to be a "component" resource block.
- Use `for_each` over local.component_settings to iterate the map into multiple
  resource instances for each of the local_component_settings keys.
- Add a moved block to inform state that terraform_data.gateway moved to
  terraform_data.component["gateway"].
- Updated output blocks for "gateway_name", "gateway_id", and "gateway_settings" to 
  follow the moved "gateway" resource instance.
- Run `terraform plan -var-file="practice.env.tfvars"` to verify only the
  previously unrealized "processor" entry from var.components is added, and
  that "gateway" was not changed due to the moved block.
- After successful plan validation, applied changes to save in the state file.
- Inspected state with `terraform state list` and `terraform state show` to validate
  resource instances were created as defined.
- Inspected outputs to validate updates to output blocks using `terraform output`.
### Stage 11 - Build an output for the whole collection
- Add output block for component_inventory, iterating the `terraform_data.component`
  instances, capturing several output attributes and the instance id.
- Ran `terraform validate` to validate the syntax of the added output block.
- Ran `terraform plan -var-file="<env_tfvars>` to observe that the output block
  captured the correct attributes and didn't cause a change to the resource instances.
- Ran `terraform apply` to capture the changes to the state file.
- Ran `terraform output -json component_inventory` to feed into PowerShell's Hashtable
  object to see how to interface, sending output results to other scripting languages.
- Ran `terraform plan` again to verify there were no pending changes.
### Stage 12 - Validate every entry in a collection
- Add validation block to variable `components` object attribute `replicas` to ensure
  it is an integer between 1 and 5.
- Run `terraform validate` and `terraform plan` to validate against practice.env.tfvars.
- Modify processor's replicas value to 0, 1, 2.5, 5, and 6 to verify failure on
  0, 2.5, and 6, then rerun `terraform plan` ensuring failure on numbers outside 1-5 
  and any non-integers.
- Return processor's replicas to original value.
### Stage 13 - Make validation errors identity the problem
- Updated error_message in variable components validation block to use an if with a
  boolean test that is the inversion of the alltrue() in condition.
- Used `terraform plan` to validate capture of failed values using temporary changes
  to the replicas attribute for both gateway and processor in practice.env.tfvars.
- Restored original replica attributes.
### Stage 14 - Collection changes and resource identity
- Capture existing resource instances in state file in a PowerShell variable using 
  `terraform output -json component_inventory`.
- Change processor.replicas from 3 to 4 and add new processor.scheduler to 
  var.components input in practice.env.tfvars.
- Use `terraform plan` to validate changes match predictions.
- Run `terraform apply` to save changes to the state.
- Capture new resource instances from state to compare to the before instances.
- Compare the before and after instance settings to verify changes.
### Stage 15 - Configuration boundaries and version selection
- Discussed and answered hypotheticals regarding
  - Version selection syntax and how terraform handles changes in an existing
    workspace where `init` has already locked.
  - Workspace files and which are automatically loaded and those that must be
    explicitly loaded.
    - Only .tf files in the current directory are loaded, no recursion so subdirectories
      are ignored.
      - modules have to be included with a module block in one of the root .tf files.
    - Only terraform.tf, *.auto.tfvars variable files are auto loaded, all other
      .tfvars files must be explicitly loaded with the -var-files parameter.
### Stage 16 - Independent practical exercise
- Change request:
  - Rename the `scheduler` instance to dispatcher.
    - Preserve the instance's id using a moved block.
  - Validate var.components' instance_size attribute.
    - Valid sizes are to be "small", "medium", and "large".
    - error_message should display the incorrect value as well as the instance key 
      it came from.
  - Add output for scaled_components.
    - Include only components whose replica count is greateer than 1.
    - Map components to thier replica value from resource outputs.
- Steps
  - Capture current component_inventory output
  - Validate no pending changes with a `terraform plan`.
  - Rename 'scheduler' to 'dispatcher' in var.components in practice.env.tfvars.
  - Add moved block to moved.tf from 'scheduler' to 'dispatcher'.
  - Validate changes don't incur a destroy/create with `terraform plan`.
  - Add a new validation block to variable components in variables.tf.
    - Validate that all instance_size values come from set "small", "medium", "large".
  - Use `terraform plan` to test valid and invalid instance_size values.
  - Change the error_message such that we iterate over var.components,
    displaying key and component.instance_size for failing values.
  - Add output bloxk to outputs.tf for scaled_components.
    - Iterate terraform_data.components using 'if' to find components with replica > 1.
    - Capture those components in a map(), with key as key, and replicas value as value.
  - Capture finished component_inventory and compare to initial output.
- Execution
  - Captured current component_inventory with
    `$start_inventory = terraform output -json component_inventory | ConvertFrom-Json`
  - Validated no pending changes.
  - Changed scheduler to dispatcher in practice.env.tfvars.
  - Added moved block and validated with `terraform plan`.
  - Added validation block and validated failure on 'tiny'.
  - Modified errer_message to show failing resource instance and it's 
    instance_size value.
  - Added output to make map of scaled_components using a comprehension.
  - Capture finished inventory and compared.

## Lab 02 - Retake
### Stage 1 - Defining the module contract
- Created workspace lab-retake/02-reusable-modules
- Created module directory lab-retake/02-reusable-modules/modules/component
- Created component module's variables.tf file.
  - Added variable blocks with appropriate default and validations for
    - component_name - string - no default/
    - instance_size - string - must be one of "small", "medium", or "large".
    - replicas - number - must be a whole number between and including 1 and 5.
- Created component module's main.tf file.
  - Created terraform_data resource called 'this' with inputs
    - name capturing var.component_name.
    - instance_size capturing var.instance_size.
    - replicas capturing var.replicas.
- Created root main.tf
  - Added module with source "./modules/component" with attributes
    - component_name = "parcel-practice-gateway"
    - instance_size = "small"
    - replicas = 2
- Created root versions.tf and require versions ">= 1.50, < 2.0.0"
- Ran `terraform` for `fmt -recursive`, `inti`, `validate`, and `plan` 
  to validate the scripts so far.
### Stage 2 - Expose results from the child module to the parent module
- Added outputs.tf to the component module.
- Added output blocks to component's outputs.tf for
  - id pointed to the generated terraform_date.this resource instance.
  - settings pointed to the generated terraform_data.this.output resource
    instance's output.
- Added outputs.tf to the root module.
- Added output block for `gateway_id` to root outputs.tf pointed at 
  the component module's gateway instance's id.
- Added output block for `gateway_settings` to root outputs.tf pointed at
  the component module's gateway instance's settings output.
- Ran terraform's fmt, validate, and plan to verify.
- Applied plan and captured current gatway_id in PowerShell's $gatewayIdBefore variable.
