targetScope = 'subscription'

param location string = 'northeurope'
param suffix string = substring(uniqueString(subscription().id), 0, 4)
param rgSuffix string = 'rg-platform'
param miRoleAssIds array = [
  {
    name: 'Contributor'
    scope: 'Subscription'
    id: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    name: 'User Access Administrator'
    scope: 'Subscription'
    id: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  }
]

// Create Resource Groups
resource identityRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${rgSuffix}-identity'
  location: location
}

resource connectivityRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${rgSuffix}-connectivity'
  location: location
}

resource managementRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${rgSuffix}-management'
  location: location
}

// Create Management Resources
module managementMod 'management.bicep' = {
  name: 'managementMod'
  scope: resourceGroup(managementRg.name)
  params: {
    saName: 'stterraform${suffix}'
    location: managementRg.location
    miId: identityMod.outputs.miPrincipalId
  }
}

// Create Identity Resources
module identityMod 'identity.bicep' = {
  name: 'identityMod'
  scope: resourceGroup(identityRg.name)
  params: {
    location: identityRg.location
  }
}

// Create Connectivity Resources
module connectivityMod 'connectivity.bicep' = {
  name: 'connectivityMod'
  scope: resourceGroup(connectivityRg.name)
  params: {
    location: connectivityRg.location
  }
}

// Create Role Assignments for Subscription
resource miRoleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = [ for miRoleAssId in miRoleAssIds: if (miRoleAssId.scope == 'Subscription') {
  name: guid(subscription().id, 'mi-sub-${miRoleAssId.name}', miRoleAssId.id)
  properties: {
    principalId: identityMod.outputs.miPrincipalId
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/${miRoleAssId.id}'
  }
}]

// Outputs
output dnsZoneNameservers array = connectivityMod.outputs.dnsZoneNameservers
output storageAccountName string = managementMod.outputs.storageAccountName
output dnsZoneRgName string = connectivityMod.outputs.dnsZoneRgName
output storageAccountRgName string = managementMod.outputs.storageAccountRgName
output storageAccountContainerName string = managementMod.outputs.storageAccountContainerName
output miClientId string = identityMod.outputs.miClientId
output miRgName string = identityMod.outputs.miRgName
output miName string = identityMod.outputs.miName
