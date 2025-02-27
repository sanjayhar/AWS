# aws-vpc-peering-3tier-architecture
AWS VPC Peering with Public &amp; Private Subnets, 3-Tier Server Architecture using EC2 (Web &amp; App Server) and RDS (Database Server) across Availability Zones.

# Project Overview
This project demonstrates a **VPC Peering** setup with **Public and Private Subnets**, implementing a **3-Tier Server Architecture**:
-> **Web & App Servers**: Hosted on EC2 instances in private subnets.
-> **Database Layer**: RDS instance for relational database management.
-> **VPC Peering**: Connects different VPCs securely.

## Architecture Diagram
-> https://github.com/sanjayhar/aws-vpc-peering-3tier-architecture/commit/25ebd4a118c34e8b9fb997a77cee087d41f2a2ca

## AWS Services Used
-> **VPC & Subnets**: Public & Private subnets across different AZs.
-> **EC2**: Web & Application Server.
-> **RDS**: Database Server.
-> **VPC Peering**: Connecting multiple VPCs.
-> **Security Groups & IAM Roles**.

## Deployment Steps
Step 1 : **Create VPCs** with public & private subnets.
Step 2 : **Set up EC2 instances** for Web & App Server.
Step 3 : **Launch RDS instance** in the private subnet.
Step 4 : **Establish VPC Peering** for secure communication.
Step 5 : **Configure Security Groups** to allow necessary traffic.
Step 6 : **Test the connection**.

