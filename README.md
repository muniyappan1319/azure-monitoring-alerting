# Azure VM Monitoring and Automated Alerting

Enterprise-style Azure VM monitoring and alerting solution built with Terraform and Azure Monitor. A Linux VM sends performance and syslog data to Log Analytics, a KQL alert detects sustained high CPU usage, and a Logic App sends an email notification.

---

## Architecture

```text
Azure Linux VM
      |
      v
Azure Monitor Agent
      |
      v
Data Collection Rule
      |
      v
Log Analytics Workspace
      |
      v
KQL (Scheduled Query)
      |
      v
Azure Monitor Alert
      |
      v
Action Group
      |
      v
Logic App
      |
      v
Email Notification
```

---

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

---

## Infrastructure as Code

Terraform is used to provision the Azure infrastructure, including networking, the Linux VM, monitoring resources, and alerting components.

---

## Monitoring

The solution collects:

- CPU performance
- Memory performance
- Disk performance
- Linux Syslog

---

## Alerting

A scheduled query alert monitors for sustained high CPU utilization (above 80%) using a sliding time window to reduce false positives. When the condition is met, the alert triggers an Action Group, which runs a Logic App to send an email notification.

Example KQL:

```kusto
Perf
| where ObjectName == "Processor" and CounterName == "% Processor Time" and InstanceName == "_Total"
| summarize AvgCPU = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
| where AvgCPU > 80
```

---

## Security

- SSH key authentication
- Password authentication disabled
- Network Security Group
- Managed Identity
- Restricted SSH access
- No secrets stored in Git

---

## Prerequisites

- Azure subscription
- Terraform installed
- Azure CLI installed and logged in (`az login`)
- SSH key pair
- Office 365 Outlook account to authorize the Logic App email connector

---

## Project Structure

```text
azure-monitoring-alerting/
├── terraform/
├── .gitignore
└── README.md
```

---

## Deployment

```powershell
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After deployment, open the Logic App in the Azure Portal and authorize the Office 365 Outlook connection if required.

---

## Validation

Connect to the VM over SSH and generate CPU load:

```bash
sudo apt-get update && sudo apt-get install -y stress
stress --cpu 2 --timeout 600
```

Then confirm:

- CPU data appears in the Log Analytics Workspace
- The alert fires in Azure Monitor
- The Action Group triggers the Logic App
- The notification email is delivered

---

## Troubleshooting

- **No data in Log Analytics:** check the DCR association and that the Azure Monitor Agent extension is healthy
- **Alert does not fire:** run the KQL manually and check the evaluation frequency, window and threshold
- **Email not sent:** re-authorize the Office 365 Outlook connection in the Logic App
- **SSH fails:** check the NSG rules and that your public IP is allowed

---

## Cleanup

Remove all resources to avoid charges:

```powershell
cd terraform
terraform destroy
```

---

## Technologies

Terraform, Azure Monitor, Azure Monitor Agent, Data Collection Rules, Log Analytics, KQL, Action Groups, Logic Apps, Azure VM, NSG, Linux

---

## Author

Muniyappan Ayyanar, Azure Cloud Engineer (AZ-104)

LinkedIn: https://linkedin.com/in/muniyappan-a-4937b8201
GitHub: https://github.com/muniyappan1319
