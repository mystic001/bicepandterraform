targetScope = 'subscription'

// Common parameters
@description('Environment name')
param environment string
@description('Azure region')
param location string

@description('Storage account settings')
param storageAccountSettings object

@description('Tags for resources')
param tags object = {
  Environment: environment
  DeployedBy: 'Bicep'
}

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${environment}'
  location: location
  tags: {
    environment: environment
    deployedBy: 'GitHub Actions'
    purpose: 'example'
  }
}

// Module for App Service Plan
// module appServicePlan 'modules/appServicePlan.bicep' = {
//   scope: resourceGroup
//   name: 'asp-deployment'
//   params: {
//     aspName: aspName
//     location: location
//     aspSku: aspSku
//     aspKind: aspKind
//   }
// }



// Storage Account Module
module storage 'modules/storage/storageAccount.bicep' = {
  scope: resourceGroup
  name: 'storage-deployment'
  params: {
    storageAccountName: storageAccountSettings.name
    location: location
    skuName: storageAccountSettings.sku
    enableBlobEncryption: true
    tags: union(tags, {
      Service: 'Storage'
    })
  }
}


// Outputs (optional - useful for referencing in other deployments)
output resourceGroupName string = resourceGroup.name
output storageAccountName string = storage.outputs.storageAccountName
output storageAccountId string = storage.outputs.storageAccountId

