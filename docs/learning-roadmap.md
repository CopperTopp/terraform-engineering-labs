# Terraform Engineering Learning Roadmap

## Objective

Develop and demonstrate Terraform skills for designing, deploying,
automating, and troubleshooting enterprise infrastructure on AWS.

Use small deployments to demonstrate scalable patterns. Prefer local
testing where practical and document costs before deploying paid resources.

## Planned Milestones

- [ ] 01 — Configuration and Types
  - Typed variables, maps, objects, optional attributes, and validation
  - Locals, outputs, expressions, and resource dependencies
  - Stable resource addressing with for_each

- [ ] 02 — Modules and Environments
  - Reusable child modules and deployable root configurations
  - Module interfaces and version constraints
  - Environment configuration and deployment boundaries

- [ ] 03 — State, Import, and Recovery
  - Remote state, locking, and access controls
  - Resource imports and moved blocks
  - Drift detection and state recovery

- [ ] 04 — Load-Balanced EC2
  - Application Load Balancer and target groups
  - Launch templates and Auto Scaling
  - Health checks, instance replacement, and application updates

- [ ] 05 — CI/CD and Identity
  - Automated formatting, validation, and tests
  - GitHub Actions and AWS OIDC authentication
  - Plan review, controlled deployment, and cleanup

- [ ] 06 — ECS Multi-Service
  - Front-end, API, and worker services
  - Task definitions, IAM roles, routing, and logs
  - Independent service deployments and scaling

- [ ] 07 — EKS Platform
  - Cluster infrastructure and node groups
  - Access management and workload identity
  - Separate infrastructure and workload deployment workflows

- [ ] 08 — Enterprise Design and Operations
  - Environment promotion and module releases
  - Multiple-account architecture and governance
  - Observability, troubleshooting, recovery, and cost management

## Completion Criteria

A milestone is complete when I can:

1. Explain the configuration and its design decisions.
2. Deploy and validate the implementation where applicable.
3. Diagnose a relevant failure or explain its likely failure modes.
4. Destroy disposable resources and verify cleanup.
5. Link to supporting code and evidence in the milestone log.

## Portfolio Progression

Completed lab patterns will inform a separate Acme infrastructure project
comparing EC2, ECS, and EKS implementations of the same application.