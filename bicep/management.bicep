param saName string
param location string = 'northeurope'
param miId string
param miRoleAssId string = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

// Create a stroage account for Terraform state
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: saName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  resource blobService 'blobServices@2023-01-01' = {
    name: 'default'
    resource blobContainer 'containers@2023-01-01' = {
      name: 'terraform-state'
    }
  }
}

// Create Role Assignments for Stroage Account
resource miRoleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, 'mi-sa-contributor', '')
  scope: storageAccount
  properties: {
    principalId: miId
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${miRoleAssId}'
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output storageAccountRgName string = resourceGroup().name
output storageAccountContainerName string = storageAccount::blobService::blobContainer.name
