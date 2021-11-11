workspace "Public Data Space" "This workspace documents the architecture of the Public Data Space which enables public institutions in Czechia to share public data among each other in a guaranteed way." {

    model {
        hospitalBuildingMaintanance = softwareSystem "Hospital Building Maintanance System (HBMS)" "Manages and schedules building maintanance devices accross the hospital sectors."  {
            webFrontend = container "HBMS Web Front-end" "Provides all functionality for all devices schedulling, management and monitoring"  {
                deviceManager = component "Device Manager" "Provides access to device record based on the search query. Supports operations on multiple devices at once."
                searchAPI = component "Search API" "Handles search queries for retrieval of information to a particular device, list of devices or employee."
                logInAPI = component "Log In API" "Provides form for user authentication."
                deviceScheduler = component "Device Scheduler" "Provides access to device scheduling interface to trigger specific device functions in a given time or periodically."
                driverManager = component "Driver Manager" "Enables setup of device drivers configuration."
                addDeviceAPI = component "Add Device API" "Enables addition of a new device."
                deleteDeviceAPI = component "Delete Device API" "Enables deletion of an existing device."
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
            
            recordIndex = container "Metadata Index" "Index for fast searching in metadata records" "Apache SOLR via JSON/HTTPS"
            recordStorage = container "Metadata Storage" "Storage of metadata records" "CouchDB via JSON/HTTPS"

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

        server -> recordIndex "Uses for fast retrieval of metadata records lists"
        server -> recordStorage "Uses for fast retrieval of metadata records details"

        server -> userDataManager "Uses to retrieve information about the users including their system roles and permissions."
        server -> deviceDataManager "Uses to retrieve the information about the available devices and their current state."

        userDataManager -> hospitalEmployeeDatabase "Accesses the employees database "
        deviceDataManager -> devicesRegistry "Accesses the devices database "
        # dataManager -> recordStorage "Uses to persists harvested metadata records. All records are always replaced"
        
        # relationships to/from components
        webFrontend -> listAPI "Makes API calls to" "JSON/HTTPS"
        webFrontend -> detailAPI "Makes API calls to" "JSON/HTTPS"

        # server components
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

        recordIndexGateway -> recordIndex "Provides access to"
        recordDetailGateway -> recordStorage "Provides access to"

        # webFrontend components
        logInAPI -> server "Makes API call to retrieve user record from DB"
        deviceManager -> server "Makes API calls to [JSON/HTTPS]"

        searchAPI -> deviceManager "Uses to retrieve record of a particular device or list of devices based on the search query"
        driverManager -> deviceManager "Uses to retrieve record of a particular device or group of devices to attach their driver settings"
        addDeviceAPI -> deviceManager "Uses to update the collection of devices by adding a new device"

        deviceScheduler -> searchAPI "Uses to retrieve record of a particular device or list of devices for scheduling"
        deleteDeviceAPI -> searchAPI "Uses to retrieve record of a device for further agreement of a delete operation for this device"
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

        component webFrontend "webFrontendComponentDiagram" {
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