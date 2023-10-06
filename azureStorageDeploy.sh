#Class  assigment quuestion 1
#Write and execute a script to deploy an Azure Storage Account, Resource Group, Storage SKU, Kind and Location.  
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

# in your bash terminal, make the script executable
chmod +x deploy-storage-account.sh

# In you bash terminal run
sh azureStorageDeploy.sh



