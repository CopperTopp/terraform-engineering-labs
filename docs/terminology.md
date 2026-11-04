# Terraform Terminology

Working definitions and examples collected during the labs.

| Term | Meaning |
| --- | --- |
| Infrastructure as Code (IaC) | Defining infrastructure in version-controlled code so changes can be reviewed and applied consistently. |
| Provider | A plugin Terraform uses to interact with an API, such as AWS. |
| Resource | A configuration block declaring an infrastructure object Terraform manages. |
| Data source | A configuration block that reads information without managing the object's lifecycle. |
| Module | A collection of Terraform configuration files in one directory. |
| Root module | The configuration Terraform runs directly. |
| Child module | A module called by another module. |
| Input variable | A declared input to a module, optionally constrained by type and validation rules. |
| Local value | A named expression used within a module to reduce repetition or clarify intent. |
| Output value | A value a module exposes to its caller or to users of the root configuration. |
| State | Terraform's record linking resource addresses to managed infrastructure objects and their recorded attributes. |
| Backend | The mechanism Terraform uses to store state; capabilities such as locking depend on the backend. |
| Plan | A proposed set of changes calculated from configuration, state, and provider information. |
| Drift | A difference between actual infrastructure and Terraform's recorded state, often caused by changes outside Terraform. |
| Resource address | Terraform's identifier for a resource instance, such as aws_subnet.lab["a"]. |
| Idempotence | Repeating an operation with the same intended inputs produces no further changes once the desired state is reached. |

## Distinctions to Remember

- Splitting configuration into multiple .tf files in one directory
  does not create separate modules or establish execution order.
- Child modules must be called explicitly; nested folders are not
  automatically included.
- File organization, module boundaries, and state boundaries solve
  different problems.