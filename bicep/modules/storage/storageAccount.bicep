@description('Storage Account Name')
param storageAccountName string

@description('Location for the storage account')
param location string

@description('The storage account SKU name')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Enable blob encryption at rest')
param enableBlobEncryption bool = true

@description('Tags for the storage account')
param tags object

@description('Container settings array')
param containers array = []

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: enableBlobEncryption
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
  tags: tags
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource containers_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for container in containers: {
  parent: blobService
  name: container.name
  properties: {
    publicAccess: container.publicAccess
    metadata: container.metadata
  }
}]

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name 
