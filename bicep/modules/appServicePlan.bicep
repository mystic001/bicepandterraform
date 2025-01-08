param aspName string
param location string
param aspSku string
param aspKind string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: aspName
  location: location
  sku: {
    name: aspSku
  }
  kind: aspKind
  properties: {
    reserved: aspKind == 'linux' // Required for Linux plans
  }
  tags: {
    environment: 'development'
    purpose: 'example'
  }
}

output appServicePlanId string = appServicePlan.id
