param location string = 'northeurope'
param miName string = 'id-github-crc'
param githubRepos array = [
  {
    name: 'cormacjlong/cloudresumechallenge-frontend'
    ref: 'crc-frontend'
    branch: 'main'
  }
  {
    name: 'cormacjlong/cloudresumechallenge-backend'
    ref: 'crc-backend'
    branch: 'master'
  }
]

// Create a Managed Identity for Github Actions
resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: miName
  location: location
}

@batchSize(1)
resource miFederation 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-07-31-preview' = [ for repo in githubRepos: {
  name: 'id-github-${repo.ref}'
  parent: mi
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${repo.name}:ref:refs/heads/${repo.branch}'
  }
}]

// Outputs
output miPrincipalId string = mi.properties.principalId
output miClientId string = mi.properties.clientId
output miRgName string = resourceGroup().name
output miName string = mi.name
