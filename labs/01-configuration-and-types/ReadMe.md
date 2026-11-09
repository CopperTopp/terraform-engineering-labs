# Lab 01 — Configuration and Types

Status: In progress

## Objective

Define AWS network infrastructure using typed inputs, clear expressions,
and stable resource addresses.

## Skills Practiced

- Resource and data source blocks
- Input variables, local values, and outputs
- Maps and objects
- for_each and resource addresses
- Configuration validation and plan review

## Completion Criteria

- Explain how the configuration creates each subnet.
- Reject invalid input through variable validation.
- Add a subnet through input data without duplicating resource blocks.
- Explain which changes update resources and which replace them.
- Review a plan and account for every proposed infrastructure change.

## Results

- Added subnet `c` by editing only `lab.env.tfvars`. The existing
  `for_each` blocks created the subnet and its route-table association.
- Replaced numeric AZ indexes with suffix matching based on subnet keys.
  For example, `c` selects `us-east-2c` in this lab.
- Added validation with separate error messages for keys that match no
  available AZ and keys that match multiple AZs.