param location string = 'northeurope'
param dnsZoneName string = 'az.macro-c.com'

// Create DNS Zone
resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: dnsZoneName
  location: 'global'
}

// Outputs
output dnsZoneNameservers array = map(dnsZone.properties.nameServers, ns => ns)
output dnsZoneRgName string = resourceGroup().name
