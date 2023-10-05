# This script create all dependencies such Azure Resource Group, App Service and deploy web app and set deployment source as GitHub Repository

#!/bin/bash

# Create Azure Resources
RESOURCE_GROUP_NAME=test-rg
APPSERVICE_PLAN_NAME=my-app-plan$RANDOM
WEBAPP_NAME=my-web-app$RANDOM
DEPLOYMENT_SOURCE=https://github.com/Azure-Samples/html-docs-hello-world
LOCATION=eastus

# Create an App Service Plan
az appservice plan create --name $APPSERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku f1

# Create a Web App
az webapp create --name $WEBAPP_NAME --plan $APPSERVICE_PLAN_NAME --resource-group $RESOURCE_GROUP_NAME 

# Deploy an app from GitHub to Azure App service
az webapp deployment source config --repo-url $DEPLOYMENT_SOURCE --branch master --manual-integration --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME

