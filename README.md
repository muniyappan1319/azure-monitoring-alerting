@"
# Azure Monitoring and Alerting

Enterprise-style Azure VM monitoring and alerting solution using Terraform and Azure Monitor.

## Architecture

Azure Linux VM
↓
Azure Monitor Agent
↓
Data Collection Rule
↓
Log Analytics Workspace
↓
KQL
↓
Azure Monitor Alert
↓
Action Group
↓
Logic App
↓
Email Notification

## Azure Services

- Azure Virtual Machine
- Azure Virtual Network
- Network Security Group
- Azure Monitor Agent
- Data Collection Rule
- Log Analytics Workspace
- Azure Monitor Alerts
- Action Group
- Logic App
- Office 365 Outlook

## Infrastructure as Code

Terraform is used to provision the Azure infrastructure.

## Monitoring

The solution collects:

- CPU performance
- Memory performance
- Disk performance
- Linux Syslog

## Alerting

A scheduled query alert monitors high CPU utilization.

## Security

- SSH key authentication
- Password authentication disabled
- Network Security Group
- Managed Identity
- Restricted SSH access
- No secrets stored in Git

## Deployment

``````powershell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply