# Create peering from hadnicVNet1 to hadnicVNet2
#Create Peering between hadnicVNet1 and hadnicVNet2 VNets using remote-vnet-id CLI command
hadnicVNet2ID=$(az network vnet show \
--resource-group test2-rg \
--name hadnicVNet2 \
--query id --out tsv)

echo "hadicVNet2Id = " $hadicVNet2Id

#Type in the following command to peer hadnicVNet1 to EastVNetHadnicVNet2
az network vnet peering create \
    --name hadnicVNet1-to-hadnicVNet2 \
    --resource-group test-rg \
    --vnet-name hadnicVNet1 \
    --remote-vnet $hadnicVNet2ID \
    --allow-vnet-access

#Type in the following command to Verify State of peering

az network vnet peering list \
--resource-group test-rg \
--vnet-name hadnicVNet1 \
--output table

#Capture the hadnicVNet1 ID in a variable

hadnicVNet1Id=$(az network vnet show \
--resource-group test-rg \
--name hadnicVNet1 \
--query id --out tsv)

echo "hadnicVNet1 = " $hadnicVNet1Id

#Type in the following command to peer hadnicVNet2 to hadnicVNet1

az network vnet peering create \
 --name hadnicVNet2-to-hadnicVNet1 \
 --resource-group test2-rg \
 --vnet-name hadnicVNet2 \
 --remote-vnet $hadnicVNet1Id \
 --allow-vnet-access

#Type in the following command to Verify State of peering

az network vnet peering list \
--resource-group test2-rg\
--vnet-name hadnicVNet2\
--output table




    

