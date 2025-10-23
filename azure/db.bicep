@description('Name of the Cosmos DB account')
param cosmosdb_account_name string

@description('Azure region for the Cosmos DB account')
param location string = resourceGroup().location

@description('Name of the database')
param databaseName string = 'viewCounterDb'

@description('Name of the container')
param containerName string = 'counter'

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-03-15' = {
  name: cosmosdb_account_name
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    // Enable free tier (if creating fresh)
    enableFreeTier: true
    // Optional: minimal consistency
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    // Optional: restrict throughput limit
    // properties.capacity.totalThroughputLimit: <some value> (if you want to cap)
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-03-15' = {
  parent: cosmosAccount
  name: '${databaseName}'
  properties: {
    // Use shared throughput (no dedicated throughput for the container)
    resource: {
      id: databaseName
    }
    options: {
      throughput: 400  // minimal RU/s provisioned (if not using serverless)
      // If using free tier + shared throughput, this may not even bill
    }
  }
}

resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-03-15' = {
  parent: cosmosDb
  name: '${containerName}'
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: ['/id']
        kind: 'Hash'
      }
      // minimal indexing policy if you like
      indexingPolicy: {
        indexingMode: 'Consistent'
        // further customisation if needed
      }
      defaultTtl: -1  // never expire, but if you want expire older values you could set >0
    }
    options: {
      // we are sharing throughput from the database so no dedicated throughput here
    }
  }
}
