// frontdoor.bicep
@description('Front Door uses global location.')
param location string = 'global'

@description('Origin hostname (e.g., mystorage.z13.web.core.windows.net)')
param origin_hostname string

@description('Custom domain served by Front Door (use a subdomain, e.g., www.andrewbrownresume.net)')
param domain_fqdn string

@description('Azure DNS zone name (e.g., andrewbrownresume.net)')
param dns_zone_name string

@description('Resource group name where the Azure DNS zone lives')
param dns_zone_rg string

// Front Door Standard (Microsoft)
resource fd 'Microsoft.Cdn/profiles@2025-06-01' = {
  name: 'fd-${uniqueString(resourceGroup().id)}'
  location: location
  sku: { name: 'Standard_AzureFrontDoor' }
}

resource fdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2025-06-01' = {
  name: 'ep-${uniqueString(resourceGroup().id)}'
  parent: fd
  location: location
  properties: { enabledState: 'Enabled' }
}

// Origin group + origin -> Storage Static Website endpoint
resource og 'Microsoft.Cdn/profiles/originGroups@2025-06-01' = {
  name: 'og-default'
  parent: fd
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 0
    }
    healthProbeSettings: {
      probePath: '/index.html'
      probeRequestType: 'GET'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 120
    }
    sessionAffinityState: 'Disabled'
  }
}

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2025-06-01' = {
  name: 'origin-staticweb'
  parent: og
  properties: {
    hostName: origin_hostname
    httpPort: 80
    httpsPort: 443
    originHostHeader: origin_hostname
    priority: 1
    weight: 1000
  }
}

// Use Azure DNS zone for automatic validation + managed TLS
resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dns_zone_name
  scope: resourceGroup(dns_zone_rg)
}

resource customDomain 'Microsoft.Cdn/profiles/customDomains@2025-06-01' = {
  name: 'cd-${uniqueString(domain_fqdn)}'
  parent: fd
  properties: {
    hostName: domain_fqdn
    azureDnsZone: { id: dnsZone.id }
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

// Route UNDER afdEndpoints (correct parent)
resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2025-04-15' = {
  name: 'route-static'
  parent: fdEndpoint
  properties: {
    originGroup: { id: og.id }
    supportedProtocols: [ 'Http', 'Https' ]
    httpsRedirect: 'Enabled'
    linkToDefaultDomain: 'Disabled'
    customDomains: [ { id: customDomain.id } ]
    patternsToMatch: [ '/*' ]
    forwardingProtocol: 'MatchRequest'
    enabledState: 'Enabled'
  }
}

output afd_endpoint string = fdEndpoint.properties.hostName