# Define variables for the deployement of azure storage account using power powershell
#!/bin/bash

# Define variables for your Azure resources
resourceGroupName="test-rg01"
storageAccountName="nickomostorage01"
sku="Standard_LRS"  # You can change this to the desired SKU (e.g., Premium_LRS)
kind="StorageV2"    # You can change this to the desired kind (e.g., StorageV2)
location="eastus"   # You can change this to your desired location

# Create a resource group
az group create --name $resourceGroupName --location $location

# Create a storage account
az storage account create \
    --name $storageAccountName \
    --resource-group $resourceGroupName \
    --sku $sku \
    --kind $kind \
    --location $location

echo "Azure Storage Account deployment completed."
