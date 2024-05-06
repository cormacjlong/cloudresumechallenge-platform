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
    properties: {
      isVersioningEnabled: true // Versioning should be enabled to ensure that the state file is not lost
    }
  }
}

// Create lifecycle policy to delete blob versions older than 3 days
resource lifecyclePolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-01-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          enabled: true
          name: 'Delete blob versions older than 3 days'
          type: 'Lifecycle'
          definition: {
            actions: {
              version: {
                delete: {
                  daysAfterCreationGreaterThan: 3
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
          }
        }
      ]
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
