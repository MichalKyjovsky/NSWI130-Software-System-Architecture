workspace "Public Data Space" "This workspace documents the architecture of the Public Data Space which enables public institutions in Czechia to share public data among each other in a guaranteed way." {

    model {
        hospitalBuildingMaintanance = softwareSystem "Hospital Building Maintanance System (HBMS)" "Manages and schedules building maintanance devices accross the hospital sectors."  {
            webFrontend = container "(HBMS) Web Front-end" "Provides all functionality for all devices schedulling, management and monitoring"  {
                deviceManager = component "Device Manager" "Provides access to device record based on the search query. Supports operations on multiple devices at once."
                searchAPI = component "Search API" "Handles search queries for retrieval of information to a particular device, list of devices or employee."
                logInAPI = component "Log In API" "Provides form for user authentication."
                deviceScheduler = component "Device Scheduler" "Provides access to device scheduling interface to trigger specific device functions in a given time or periodically."
                driverManager = component "Driver Manager" "Enables setup of device drivers configuration."
                addDeviceAPI = component "Add Device API" "Enables addition of a new device."
                deleteDeviceAPI = component "Delete Device API" "Enables deletion of an existing device."
                hospitalVisualizer = component "Hospital Visualizer" "Provides UI for browsing individual sections of a hospital with their corresponding devices."
            }
            server = container "(HBMS) Server" "Implements logic for functionality of the regular devices management."    {
                listAPI = component "Service of the component 1" "Provides API for getting a list of metadata records according to specified search parameters via a JSON/HTTPS API."
                detailAPI = component "Service of the component 2" "Provides API for getting a detail of a given metadata record via a JSON/HTTPS API."
                searchController = component "Service of the component 3" "Implements and provides business functionality related to searching for metadata records"
                detailController = component "Service of the component 4" "Implements and provides business functionality related to viewing details of metadata records"
                distributionModel = component "Service of the component 5" "Internal model of distribution metadata"
                datasetModel = component "Service of the component 6" "Internal model of dataset metadata"
                recordIndexGateway = component "Service of the component 7" "Provides access to a metadata records index"
                
            }   
            deviceUpdater = container "Device Updater" "Worker responsible for the firmware and driver maintanace." "Some black box magix Miso did not invented yet." {
                updateManager = component "Update Manager" "Expose the functionality to other component of the system, so they can be accessed via API or manually"
                statusResolver = component "System Status Resolver" "Retrieves the category of the devices that are under the regulat check and decides if update is required."
                updatePlanner = component "Update Planner" "Schedules the suitable update window for the particular device so the regular service is not afected."
                versionResolver = component "Version Resolver" "Verifies the provided devices map to a current version of a drivers, firmware and software against the Hospital's devices register"
                updateTrigger = component "Update Installation Trigger" "Triggers the events of device update and propagates it to every issued component "
                updateWorker = component "Update Installation Worker" "Based on the resolved versions and categories installs the requested updates to the device "
            }
                        
            userDataManager = container "User Data Manager" "Manages data about users." "UserDataManager"{
                userDataManagerGateway = component "User Data Manager Gateway" "provides access to external user data database"
            }
            
            deviceDataManager = container "Device Data Manager" "Manages data about devices." "DeviceDataManager"{
                deviceDataManagerGateway = component "Device Data Manager Gateway" "provides access to external device data database"
            }

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

        # server components
        listAPI -> searchController "Uses to access search business functionality"
        detailAPI -> detailController "Uses to access detail business functionality"

        searchController -> datasetModel "Uses to access metadata about datasets"
        detailController -> datasetModel "Uses to access metadata about datasets"
        detailController -> distributionModel "Uses to access metadata about distributions"

        datasetModel -> recordIndexGateway "Uses to retrieve list of metadata records with given values of selected properties"
        
        recordIndexGateway -> deviceUpdater "Provides access to"


        # Device Updater - Component Relations and Decompositions

        updateManager -> webFrontend  "Expose the functinality to the GUI as well as to the REST-API "

        versionResolver -> devicesRegistry "Gets data and updates from "
        # We could ask data manager directly, but we need to know the current status of the devices to be posted into the planner
        statusResolver -> server "Gets the category of the devices with relevant metadata "
        updateManager -> server "Posts the information about the planned updated with the modified device schedule and state "
        updateTrigger -> updateManager "Reflects the information about schedulled update to the manager, so its actual for every listenning service "
        updatePlanner -> updateTrigger "Posts the schedule for the devices that are in the current update scope "
        statusResolver -> versionResolver "Gets the information about the possible updates for the tracked devices "
    
        updateWorker -> device "Installs updates when in the device is in the appropriate state "
        updateTrigger -> updatePlanner "Initiates the planning with the current information about issued devices "
        updateTrigger -> statusResolver "Gets the information about the actual devices state "

        updateManager -> updateWorker "Adds task "

        # webFrontend components
        logInAPI -> server "Makes API call to retrieve user record from DB"
        deviceManager -> server "Makes API calls to [JSON/HTTPS]"

        searchAPI -> deviceManager "Uses to retrieve record of a particular device or list of devices based on the search query"
        driverManager -> deviceManager "Uses to retrieve record of a particular device or group of devices to attach their driver settings"
        addDeviceAPI -> deviceManager "Uses to update the collection of devices by adding a new device"

        deviceScheduler -> searchAPI "Uses to retrieve record of a particular device or list of devices for scheduling"
        deleteDeviceAPI -> searchAPI "Uses to retrieve record of a device for further agreement of a delete operation for this device"
        hospitalVisualizer -> searchAPI "Uses to retrive records of devices that belong to a particular section"
        
        # DeviceDataManager components
        server -> DeviceDataManagerGateway "Uses to get high level functionality over raw device data"
        DeviceDataManagerGateway -> devicesRegistry "Uses to get all data regarding devices"
        
        # UserDataManager components
        server -> userDataManagerGateway "Uses to get high level functionality over raw employee data"
        userDataManagerGateway -> devicesRegistry "Uses to get all data regarding employees"
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
        
        component deviceUpdater "deviceUpdater" {
            include *
        }
        
        component DeviceDataManager "DeviceDataManagerComponentDiagram" {
            include *
        }
        
        component UserDataManager "UserDataManagerComponentDiagram" {
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