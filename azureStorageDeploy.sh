# Define variables for the deployement of azure storage account using power powershell
#!/bin/bash

$resourceGroupName = "test-rg1"
$storageAccountName = "nickomostorage"
$location = "eastus"
$storageSku = "Standard_LRS"  # Change this to the desired SKU
$kind = "StorageV2"  # Change this to the desired kind (e.g., StorageV2, BlobStorage, etc.)

# Create a new resource group
 New-AzResourceGroup create
 -Name $resourceGroupName 
 -Location $location

# Create a new storage account
 New-AzStorageAccount create
 -ResourceGroupName $resourceGroupName
 -Name $storageAccountName 
 -SkuName $storageSku 
 -Kind $kind 
 -Location $location
