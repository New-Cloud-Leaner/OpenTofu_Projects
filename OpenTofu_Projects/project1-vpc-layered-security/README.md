---

# Project 1 – VPC Layered Security (AWS + OpenTofu)

## Overview

This project implements a layered security architecture on AWS using OpenTofu (Infrastructure as Code).
It demonstrates secure network segmentation using public and private subnets, enforced through route tables, security groups (stateful), and network ACLs (stateless), along with internal connectivity validation.

---

## Region

AWS Region: **ap-south-1 (Mumbai)**

---

## Architecture

VPC (10.0.0.0/16)

* Internet Gateway
* Public Subnet (10.0.1.0/24)

  * Route: 0.0.0.0/0 → Internet Gateway
  * EC2 Public Instance (Public IP enabled)
* Private Subnet (10.0.2.0/24)

  * Route: Local only
  * EC2 Private Instance (No Public IP)
* Security Group (Stateful)

  * SSH (22) → Allow
  * ICMP → Allow
* Network ACL (Stateless)

  * Inbound Rules

    * SSH (22) → Allow
    * ICMP Echo Request → Allow
    * ICMP Echo Reply → Allow
    * All traffic → Deny
  * Outbound Rules

    * TCP 1024–65535 → Allow
    * ICMP Echo Request → Allow
    * ICMP Echo Reply → Allow
    * All traffic → Deny

---

## Directory Structure

project1-vpc-layered-security/

* README.md
* versions.tf
* providers.tf
* variables.tf
* main.tf
* outputs.tf

---

## Prerequisites

* AWS account
* Existing EC2 key pair (example: `ProjectKey`)
* OpenTofu installed
* AWS credentials configured using environment variables:

  * AWS_ACCESS_KEY_ID
  * AWS_SECRET_ACCESS_KEY
  * AWS_SESSION_TOKEN (if applicable)

---

## Deployment Steps

### Initialize OpenTofu

tofu init

### Format and validate

tofu fmt -recursive
tofu validate

### Review execution plan

tofu plan

### Apply configuration

tofu apply --auto-approve

---

## Outputs

After successful deployment, OpenTofu displays:

* Public instance public IP
* Private instance private IP
* VPC ID
* AWS region

---

## Validation Steps

### SSH into the public instance

ssh -i ProjectKey.pem ec2-user@<PUBLIC_IP>

### Ping private instance from public instance

ping <PRIVATE_IP>

Expected result:

* ICMP replies received
* 0% packet loss

---

## Security Validation Checklist

* Public instance reachable from the internet
* Private instance not reachable from the internet
* Internal ICMP communication works
* Route tables correctly isolate public and private subnets
* Network ACL stateless behavior verified
* Default deny rules enforced

---

## Cleanup

To destroy all resources created by this project:
tofu destroy --auto-approve

---

## Learning Outcomes

* Practical AWS VPC networking experience
* Clear understanding of stateful vs stateless security
* Correct ICMP Echo Request and Echo Reply handling
* Real-world OpenTofu troubleshooting and validation

---

## Project Status

**Completed and fully validated**

---
