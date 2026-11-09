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

### Next milestone

- Reuse the same network module from a second root configuration
  with its own inputs and state.