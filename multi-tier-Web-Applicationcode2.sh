
RESOURCE GROUP..................................................................................

#Create a resource group
az group create --name nickMuitiTier-rg --location westus2



VIRTUAL NETWORK..................................................................................


# Create a virtual network
az network vnet create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-VNet \
  --address-prefix 10.0.0.0/16


SUBNET FOR APPLICATION TIER.......................................................

# Create subnets for each application tier
az network vnet subnet create \
  --resource-group nickMuitiTier-rg \
  --vnet-name nickMuitiTier-VNet \
  --name nickMuitiTier-web-subnet \
  --address-prefix 10.0.1.0/24

az network vnet subnet create \
  --resource-group nickMuitiTier-rg \
  --vnet-name nickMuitiTier-VNet \
  --name nickMuitiTier-app-subnet \
  --address-prefix 10.0.2.0/24

az network vnet subnet create \
  --resource-group nickMuitiTier-rg \
  --vnet-name nickMuitiTier-VNet \
  --name nickMuitiTier-db-subnet \
  --address-prefix 10.0.3.0/24


NSG FOR APPLICATION TIER...........................................................................

# Create network security groups for each application tier
az network nsg create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-web-nsg \
  --location westus2

az network nsg create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-app-nsg \
  --location westus2

az network nsg create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-db-nsg \
  --location westus2


NSG TO ALLOW TRAFFIC......................................................................................


# Configure network security groups to allow traffic between tiers
az network nsg rule create \
  --resource-group nickMuitiTier-rg \
  --nsg-name nickMuitiTier-web-nsg \
  --name allow-app \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefix 10.0.2.0/24 \
  --source-port-range '*' \
  --destination-address-prefix 10.0.0.0/16 \
  --destination-port-range 80

az network nsg rule create \
  --resource-group nickMuitiTier-rg \
  --nsg-name nickMuitiTier-app-nsg  \
  --name allow-db \
  --protocol tcp \
  --direction inbound \
  --priority 1000 \
  --source-address-prefix 10.0.1.0/24 \
  --source-port-range '*' \
  --destination-address-prefix 10.0.3.0/24 \
  --destination-port-range 3306



VIRTUAL MACHINE DEPLOYMENT..............................................................................................................................


# Deploy virtual machines (VMs) into their respective subnets
az vm create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-web-vm \
  --image UbuntuLTS \
  --admin-user admin \
  --admin-password admin \
  --nics nickMuitiTier-web-nic \
  --subnet nickMuitiTier-web-subnet

az vm create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-app-vm \
  --image UbuntuLTS \
  --admin-user admin \
  --admin-password admin \
  --nics nickMuitiTier-app-nic \
  --subnet nickMuitiTier-app-subnet

az vm create \
  --resource-group nickMuitiTier-rg \
  --name nickMuitiTier-db-vm \
  --image UbuntuLTS \
  --admin-user admin \
  --admin-password admin \
  --nics nickMuitiTier-db-nic \
  --subnet nickMuitiTier-db-subnet
........................................................................................................................
# Deploy your application to the web tier VMs









FIREWALL..................................................................................................................


# Create an Azure Firewall resource
az network firewall create \
    --resource-group nickMuitiTier-rg \
    --name nickMuitiTier-firewall \
    --location us-east-1

# Create an application rule collection for the web tier
az network firewall application-rule-collection create \
    --resource-group nickMuitiTier-rg \
    --firewall-name nickMuitiTier-firewall \
    --name nickMuitiTier-web-rule-collection

# Add a rule to the web rule collection to allow HTTP traffic
az network firewall application-rule create \
    --resource-group nickMuitiTier-rg \
    --firewall-name nickMuitiTier-firewall \
    --rule-collection-name nickMuitiTier-web-rule-collection \
    --name allow-http \
    --protocol tcp \
    --source-addresses 10.0.1.0/24 \
    --destination-addresses 10.0.2.0/24 \
    --source-ports 80 \
    --destination-ports 80

# Create an application rule collection for the database tier
az network firewall application-rule-collection create \
    --resource-group nickMuitiTier-rg \
    --firewall-name nickMuitiTier-firewall \
    --name nickMuitiTier-db-rule-collection

# Add a rule to the db rule collection to allow database traffic
az network firewall application-rule create \
    --resource-group nickMuitiTier-rg \
    --firewall-name nickMuitiTier-firewall \
    --rule-collection-name nickMuitiTier-db-rule-collection \
    --name allow-db







APPLICATION GATEWAY......................................................................................................................

# Create an Application Gateway resource
az network application-gateway create \
    --resource-group nickMuitiTier-rg \
    --name nickMuitiTier-ag \
    --location westus2 \
    --sku Standard_v2 \
    --capacity 2

# Create a frontend IP address for the Application Gateway
az network application-gateway frontend-ip create \
    --resource-group nickMuitiTier-rg \
    --application-gateway-name nickMuitiTier-ag \
    --name nickMuitiTier-frontend-ip \
    --public-ip-address nickMuitiTier-public-ip

# Create a backend pool for the web tier
az network application-gateway backend-pool create \
    --resource-group nickMuitiTier-rg \
    --application-gateway-name nickMuitiTier-ag \
    --name nickMuitiTier-web-backend-pool

# Add the web tier VMs to the backend pool
az network application-gateway backend-address-pool add \
    --resource-group nickMuitiTier-rg \
    --application-gateway-name nickMuitiTier-ag \
    --backend-pool-name nickMuitiTier-web-backend-pool \
    --nic-name nickMuitiTier-web-nic

# Create a listener for HTTP traffic
az network application-gateway listener create \
    --resource-group nickMuitiTier-rg \
    --application-gateway-name nickMuitiTier-ag \
    --name nickMuitiTier-listener \
    --frontend-port 80 \
    --frontend-ip nickMuitiTier-frontend-ip \
    --protocol http

# Create a rule to route HTTP traffic to the web tier
az network application-gateway rule create \
    --resource-group nickMuitiTier-rg \
    --application-gateway-name nickMuitiTier-ag \
    --name nickMuitiTie-rule \
    --listener-name nickMuitiTie-listener \
    --backend-pool nickMuitiTie-web-backend-pool \
    --backend-http-settings nickMuitiTie-web-http-settings

# Configure the web tier to communicate with the Application Gateway
az vm run-command invoke \
    --resource-group nickMuitiTier-rg \
    --vm-name nickMuitiTier-web-vm \
    --command-id RunPowerShellScript \
    --scripts "Add-DnsServer -IPAddress 10.0.0.1"

..........................................................................................................
Enabling Azure Monitor:

# Enable Azure Monitor for the resource group
az monitor diagnostic settings create \
    --resource-group nickMuitiTier-rg \
    --name nickMuitiTier-diagnostic-settings \
    --target-resource-group nickMuitiTier-rg \
    --logs \
        --metrics \
        --event-hub-name nickMuitiTier-event-hub \
        --event-hub-namespace nickMuitiTier-event-hub-namespace \
        --log-analytics-workspace nickMuitiTier-log-analytics-workspace

......................................................................................................................................

Setting up alerts for network traffic:

# Create an alert rule for high network traffic to the web tier
az monitor alert create \
    --resource-group my-resource-group \
    --name web-traffic-alert \
    --location westus2 \
    --subscription-id my-subscription-id \
    --action-group my-action-group \
    --alert-condition \
        --condition-type "MetricAlert" \
        --resource-id "/subscriptions/my-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/web-nic" \
        --metric-name "BytesReceived" \
        --operator "GreaterThan" \
        --threshold "100000000" \
        --time-aggregation-type "Average" \
        --time-range "PT1M"

Setting up alerts for resource utilization:

# Create an alert rule for high CPU utilization on the web tier VM
az monitor alert create \
    --resource-group my-resource-group \
    --name web-cpu-alert \
    --location westus2 \
    --subscription-id my-subscription-id \
    --action-group my-action-group \
    --alert-condition \
        --condition-type "MetricAlert" \
        --resource-id "/subscriptions/my-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/web-vm" \
        --metric-name "Percentage CPU Usage" \
        --operator "GreaterThan" \
        --threshold "90" \
        --time-aggregation-type "Average" \
        --time-range "PT1M"

Setting up alerts for security events:

# Create an alert rule for suspicious login attempts
az monitor alert create \
    --resource-group my-resource-group \
    --name suspicious-login-alert \
    --location westus2 \
    --subscription-id my-subscription-id \
    --action-group my-action-group \
    --alert-condition \
        --condition-type "LogAlert" \
        --query "SigninLogs | where (Status contains 'Failed' or Status contains 'Suspicious') | summarize count() by AccountIdentity" \
        --time-aggregation-type "Count" \
        --time-range "PT1M"

Create a diagnostic settings resource:
    az monitor diagnostic settings create \
    --resource-group my-resource-group \
    --name my-diagnostic-settings \
    --target-resource-group my-resource-group


Enable logging for network traffic:
az monitor diagnostic settings add \
    --resource-group my-resource-group \
    --name my-diagnostic-settings \
    --logs \
        --categories "NetworkTraffic"



Enable metrics for network traffic:
az monitor diagnostic settings add \
    --resource-group my-resource-group \
    --name my-diagnostic-settings \
    --metrics \
        --categories "NetworkTraffic"















