# Azure Backup and Azure Site Recovery Demo

This repository includes a variety of artifacts that can be used to demonstrate the capabilities of Azure Backup and Azure Site Recovery. 

### Prerequisites
A subscription with at least the Contributor RBAC role. 

### Resources Deployed
The following resouces get deployed:

#### Primary Region
* Resource Group for Backup Resources (main.bicep)
* Resource Group for other Resources (main.bicep)
* Recovery Services Vault for Backup (backup.bicep)
* Backup Vault (backup.bicep)
* Log Analytics Workspace (asrPrimaryResources.bicep)
* Virtual Network (asrPrimaryResources.bicep)
* Azure Bastion Host (asrPrimaryResources.bicep)
* 1 Windows Virtual Machine (asrPrimaryResources.bicep)
* 1 Linux Virtual Machine (asrPrimaryResources.bicep)

#### Secondary Region
* Resource Group for ASR Resources (main.bicep)
* Resource Group for other Resources (main.bicep)
* Recovery Services Vault for ASR (asr.bicep)
* Automation Account (asr.bicep)
* Virtual Network for Failover (asrSecondaryResources.bicep)
* Virtual Network for Test Failover (asrSecondaryResources.bicep)


### Deploying the demo environment

1. Clone this repo, install or upgrade [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and install/upgrade [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) (you can also use Cloud Shell)

    ### To clone this repo

    ```bash
    git clone https://github.com/ryhud/az-backup-asr-demo.git
    ```
    
    ### To authenticate Azure CLI

    ```bash
    az login
    ```

    ### To set a specific subscription

    ```bash
    az account list --output table
    az account set --subscription <name-of-subscription>
    ```
2. Review the default paramaters in main.bicep and modify as needed (eg: regions, naming etc)

3. Deploy the resources

    ```bash
    az deployment sub create --location eastus --template-file main.bicep
    ```
    
4. When prompted, enter the username and password for the VM resoources.  

### Post Deployment Steps

1. Using the Backup Recovery Services Vault, configure a new enhanced backup policy and apply to the Virtual Machines

2. Using the ASR Recovery Services Vault, configure the Virtual machines for replication. 

3. If you would like to demo the Backup Vault, deploy a storage account for Blob (or any other supported resources) and configure protection. 

### High Level Demo Guidance
Deploy and configure at least a few days before the demo

#### Backup
1. Go through the settings of the Recovery Services vault properties explaining each setting (eg, storage replication type, CRR, encryption, immutability and security settings etc)
2. Show Backup Center and go through the reports, compliance, polcies etc (optional configure some Azure Policy for backup)
3. Show the process for a restore of a VM (including cross region restore)

#### ASR
1. Go through the ASR Settings
2. Create a recovery plan and go through all the settings
3. Perform a Test failover to the test VNet in the secondary region (showing cleanup process)
4. Perfom a failover to the secondary region

### Cleanup of resources

1. It is very important that you disable protection for both Backup and ASR before attempting to delete the resources. For Backup see [Delete an Azure Backup Recovery Services Vault](https://learn.microsoft.com/en-us/azure/backup/backup-azure-delete-vault), and for ASR see [Disable protection for a Azure VM (Azure to Azure)](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-manage-registration-and-protection#disable-protection-for-a-azure-vm-azure-to-azure)

2. Once protection has been disabled, you can proceed to delete the 4 Resource Groups

    ```bash
    az group delete --name ResourceGroupName
    ```