# Azure Data Factory - Setup Guide

## Prerequisites

- Azure Subscription
- Azure CLI installed
- PowerShell 5.1+
- SQL Server Management Studio (optional)

## Step-by-Step Setup

### 1. Create Resource Group

```powershell
$resourceGroup = "adf-learning-rg"
$location = "canadacentral"

az group create --name $resourceGroup --location $location
```

### 2. Create Storage Account

```powershell
$storageAccount = "adflearning9287"

az storage account create `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --location $location `
  --sku Standard_LRS

# Create container
az storage container create `
  --account-name $storageAccount `
  --name raw-data
```

### 3. Upload Sample Data

```powershell
az storage blob upload `
  --account-name $storageAccount `
  --container-name raw-data `
  --name sales_data.csv `
  --file ./sales_data.csv
```

### 4. Create SQL Server and Database

```powershell
$sqlServer = "adflearningserver"
$sqlAdmin = "sqladmin"
$sqlPassword = "AzurePass123!"
$database = "salesdb"

# Create SQL Server
az sql server create `
  --name $sqlServer `
  --resource-group $resourceGroup `
  --location $location `
  --admin-user $sqlAdmin `
  --admin-password $sqlPassword

# Create database
az sql db create `
  --server $sqlServer `
  --name $database `
  --resource-group $resourceGroup

# Configure firewall rules
az sql server firewall-rule create `
  --server $sqlServer `
  --resource-group $resourceGroup `
  --name AllowAzureServices `
  --start-ip-address 0.0.0.0 `
  --end-ip-address 0.0.0.0
```

### 5. Create SQL Table

Connect to SQL and run:

```sql
CREATE TABLE [dbo].[sales] (
    [sales_id] INT NOT NULL,
    [product] NVARCHAR(100),
    [amount] DECIMAL(10, 2),
    [date] DATE,
    [country] NVARCHAR(50),
    [amount_category] NVARCHAR(50)
);

ALTER TABLE [dbo].[sales]
ADD CONSTRAINT PK_sales PRIMARY KEY (sales_id);
```

### 6. Create Data Factory

```powershell
$dataFactory = "adf-learning-df"

az datafactory create `
  --name $dataFactory `
  --resource-group $resourceGroup `
  --location $location
```

### 7. Configure in ADF Studio

1. Go to Azure Portal
2. Open Data Factory resource
3. Click "Launch studio"
4. Follow the README.md instructions

## Configuration Summary

| Component | Name | Details |
|-----------|------|---------|
| Resource Group | adf-learning-rg | Contains all resources |
| Storage Account | adflearning9287 | Blob storage for CSV |
| Container | raw-data | Contains sales_data.csv |
| SQL Server | adflearningserver | adflearningserver.database.windows.net |
| Database | salesdb | Contains sales table |
| Admin User | sqladmin | Credentials: sqladmin / AzurePass123! |
| Data Factory | adf-learning-df | Main ADF resource |

## Cleanup (Optional)

```powershell
# Delete everything
az group delete --name adf-learning-rg --yes
```

## Verification

### 1. Check Storage Account
```powershell
az storage blob list --account-name adflearning9287 --container-name raw-data
```

### 2. Check SQL Database
```powershell
sqlcmd -S adflearningserver.database.windows.net -U sqladmin -P AzurePass123! -d salesdb -Q "SELECT * FROM [dbo].[sales];"
```

### 3. Check Data Factory
```powershell
az datafactory show --name adf-learning-df --resource-group adf-learning-rg
```

## Troubleshooting

### Firewall Issue
```powershell
# Allow your IP
$myIp = (Invoke-WebRequest -Uri 'https://api.ipify.org' -UseBasicParsing).Content

az sql server firewall-rule create `
  --server adflearningserver `
  --resource-group adf-learning-rg `
  --name AllowMyIP `
  --start-ip-address $myIp `
  --end-ip-address $myIp
```

### Connection String
```
Server=tcp:adflearningserver.database.windows.net,1433;
Initial Catalog=salesdb;
Persist Security Info=False;
User ID=sqladmin;
Password=AzurePass123!;
Encrypt=True;
Connection Timeout=30;
```

---

*Setup completed on: January 19, 2026*
