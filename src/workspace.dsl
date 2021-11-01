workspace "Public Data Space" "This workspace documents the architecture of the Public Data Space which enables public institutions in Czechia to share public data among each other in a guaranteed way." {

    model {
        hospitalBuildingMaintanance = softwareSystem "Hospital Building Maintanance System (HBMS)" "Manages and schedules building maintanance devices accross the hospital sectors."  {
            webFrontend = container "HBMS Web Front-end" "Provides all functionality for all devices schedulling, management and monitoring"  {

            }
            server = container "(HBMS) Server" "Implements logic for functionality of the regular devices management."    {
                listAPI = component "Record List API" "Provides API for getting a list of metadata records according to specified search parameters via a JSON/HTTPS API."
                detailAPI = component "Record Detail API" "Provides API for getting a detail of a given metadata record via a JSON/HTTPS API."
                searchController = component "Records Search Controller" "Implements and provides business functionality related to searching for metadata records"
                detailController = component "Record Detail Controller" "Implements and provides business functionality related to viewing details of metadata records"
                distributionModel = component "Distribution Model" "Internal model of distribution metadata"
                datasetModel = component "Dataset Model" "Internal model of dataset metadata"
                recordIndexGateway = component "Metadata Index Gateway" "Provides access to a metadata records index"
                recordDetailGateway = component "Metadata Detail Gateway" "Provides access to a metadata records store"
                codeListAccess = component "Code List Gateway" "Provides access to code lists and their items via HTTPS dereferencing Web IRIs."
            }
            
            deviceUpdater = container "Device Updater" "Worker responsible for the firmware and driver maintanace." "Some black box magix Miso did not invented yet."
            
            userDataManager = container "User Data Manager" "Manages data about users." "UserDataManager"
            deviceDataManager = container "Device Data Manager" "Manages data about devices." "DeviceDataManager"

            !docs docs

        }
        # Hospital employees general database with API
        hospitalEmployeeDatabase = softwareSystem "Database of the hospital employees" "Stores data records about the hospital employees and provides API for Hospital Building Maintanace System." "Existing System"

        devicesRegistry = softwareSystem "Devices Registry" "Stores and presents the records of all hospital devices." "Existing System"

        driverIndex = softwareSystem "Index of all hospital's devices drivers" "Actual data storage index where all drivers and firmwares of hospital's devices are stored in the most recent version." "Existing System"
        
        regularUser = person "Regular User" "An actor who configures and schedules the cleaning devices or the building components (windows, lights, aircondition)." "Consumer"

        administrator = person "Administrator" "An actor who manages the building maintanance devices and supports." "Consumer"

        device = person "Device" "A device that is subject to the HBMS" "Consumer"
        

        # Relationships to/from software systems (Level 1)
        regularUser -> hospitalBuildingMaintanance "Configures the cleaining devices and building systems"
        administrator -> hospitalBuildingMaintanance "Configures the drivers for the cleaning devices and manages accesses"

        hospitalBuildingMaintanance -> hospitalEmployeeDatabase "Uses hospital employee records from"
        hospitalBuildingMaintanance -> devicesRegistry "Harvests metadata records from"

        hospitalBuildingMaintanance -> driverIndex "Fetches a newer version of the firmawares and drivers from"
        devicesRegistry -> driverIndex "Indexes"
        
        
        # Relationships to/from containers (Level 2)
        regularUser -> webFrontend "Configures the cleaining devices and building systems"
        administrator -> webFrontend "Configures the drivers for the cleaning devices and manages accesses"

        webFrontend -> server "Uses to deliver functionality"

        server -> deviceUpdater "Uses for fast retrieval of metadata records lists"
        
        server -> userDataManager "Uses to retrieve information about the users including their system roles and permissions."
        server -> deviceDataManager "Uses to retrieve the information about the available devices and their current state."

        userDataManager -> hospitalEmployeeDatabase "Accesses the employees database "
        deviceDataManager -> devicesRegistry "Accesses the devices database "
        deviceDataManager -> device "Retrieves device information and current status and sends requests"

        device -> deviceDataManager "Retrieves device information and current status and sends requests"

        # relationships to/from components
        webFrontend -> listAPI "Makes API calls to" "JSON/HTTPS"
        webFrontend -> detailAPI "Makes API calls to" "JSON/HTTPS"

        listAPI -> searchController "Uses to access search business functionality"
        detailAPI -> detailController "Uses to access detail business functionality"

        searchController -> datasetModel "Uses to access metadata about datasets"
        detailController -> datasetModel "Uses to access metadata about datasets"
        detailController -> distributionModel "Uses to access metadata about distributions"

        datasetModel -> recordIndexGateway "Uses to retrieve list of metadata records with given values of selected properties"
        datasetModel -> recordDetailGateway "Uses to retrieve detailed metadata"
        distributionModel -> recordDetailGateway "Uses to retrieve detailed metadata"
        datasetModel -> codeListAccess "Uses to retrieve code list items labels and descriptions"
        distributionModel -> codeListAccess "Uses to retrieve code list items labels and descriptions"

        recordIndexGateway -> deviceUpdater "Provides access to"
        
    }
    
    views {
        
        systemContext hospitalBuildingMaintanance "hospitalBuildingMaintananceSystemContextDiagram" {
            include *
        }

        container hospitalBuildingMaintanance "hospitalBuildingMaintananceContainerDiagram" {
            include *
        }

        component server "serverComponentDiagram" {
            include *
        }

        theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Consumer" {
                background #999999
                color #ffffff
            }
        }

}