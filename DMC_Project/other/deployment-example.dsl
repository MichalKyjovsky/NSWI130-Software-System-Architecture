        deploymentEnvironment "Server Development"   {
            deploymentNode "Developer Laptop" "" "Microsoft Windows 11"  {
                deploymentNode "Web Browser" "" "Chrome, Firefox or Edge"   {
                    containerInstance webFrontend
                }
                deploymentNode "Node.js" "" "Node.js 14.*"  {
                    containerInstance server
                }
            }
            deploymentNode "NODC develop" "" "NODC development infrastructure"  {
                deploymentNode "NODC-dev-data" "" "Ubuntu 18.04 LTS"  {
                    deploymentNode "Apache Solr" "" "Apache Solr 8.*"   {
                        containerInstance recordIndex
                    }
                    deploymentNode "Apache CouchDB" "" "Apache CouchDB 3.*"   {
                        containerInstance recordStorage
                    }
                }
            }
        }

        deploymentEnvironment "Live"   {
            deploymentNode "Gov User's device" "" "Microsoft Windows or Android"  {
                deploymentNode "Web Browser" "" "Chrome, Firefox or Edge"   {
                    containerInstance webFrontend
                }
            }
            deploymentNode "Public User's device" "" "Microsoft Windows or Android"  {
                deploymentNode "Web Browser" "" "Chrome, Firefox or Edge"   {
                    containerInstance webFrontend
                }
            }
            deploymentNode "NODC UPAAS" "" "NODC eGov unified runtime environment (UPAAS)"  {
                deploymentNode "NODC-upaas-app" "" "Ubuntu 18.04 LTS" "" 4 {
                    deploymentNode "Node.js" "" "Node.js 14.*" {
                        containerInstance server
                    }
                }
                deploymentNode "NODC-upaas-index" "" "Ubuntu 18.04 LTS"  {
                    deploymentNode "Apache Solr" "" "Apache Solr 8.*"   {
                        containerInstance recordIndex
                    }
                }
                deploymentNode "NODC-upaas-storage" "" "Ubuntu 18.04 LTS"  {
                    deploymentNode "Apache CouchDB" "" "Apache CouchDB 3.*"   {
                        containerInstance recordStorage
                    }
                }
                deploymentNode "LODC-upaas-etl" "" "Ubuntu 18.04 LTS" "" 4 {
                    deploymentNode "LinkedPipes ETL"   {
                        containerInstance harvestor
                    }
                }
                deploymentNode "LODC-registry" {
                    softwareSystemInstance lodcRegistry
                }
            }
            deploymentNode "External open data provider"    {
                softwareSystemInstance lodc
            }
        }