# Define variables for the deployement of azure storage account
$resourceGroupName = "nickomo-rg"
$storageAccountName = "nickomostorage"
$location = "eastus"
$storageSku = "Standard_LRS"  # Change this to the desired SKU
$kind = "StorageV2"  # Change this to the desired kind (e.g., StorageV2, BlobStorage, etc.)

# Create a new resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a new storage account
New-AzStorageAccount
 -ResourceGroupName $resourceGroupName
 -Name $storageAccountName 
-SkuName $storageSku 
-Kind $kind 
-Location $location
