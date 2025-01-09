targetScope = 'subscription'

// Common parameters
param environment string
param location string

// App Service Plan parameters
// param aspName string
// param aspSku string
// param aspKind string

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

// Outputs (optional - useful for referencing in other deployments)
output resourceGroupName string = resourceGroup.name
// output appServicePlanId string = appServicePlan.outputs.appServicePlanId
