workspace "Public Data Space" "This workspace documents the architecture of the Public Data Space which enables public institutions in Czechia to share public data among each other in a guaranteed way." {

    model {
        hospitalBuildingMaintenance = softwareSystem "Hospital Building Maintanance System (HBMS)" "Manages and schedules building maintanance devices accross the hospital sectors."  {
            webFrontend = container "(HBMS) Web Front-end" "Provides all functionality for all devices schedulling, management and monitoring"  {
                deviceCollectionProvider = component "Device Collection Provider" "Provides access to device record based on the search query. Supports operations on multiple devices at once."
                searchManager = component "Search Manager" "Accepts search queries for retrieval of information to a particular hospital section, device, list of devices or employee."
                logInManager = component "Log In Manager" "Provides form for user authentication."
                deviceScheduler = component "Device Scheduler" "Provides access to device scheduling interface to trigger specific device functions in a given time or periodically."
                driverManager = component "Driver Manager" "Enables setup of device drivers configuration."
                addDeviceManager = component "Add Device Manager" "Enables addition of a new device."
                deleteDeviceManager = component "Delete Device Manager" "Enables deletion of an existing device."
                hospitalVisualizer = component "Hospital Visualizer" "Provides UI for browsing individual sections of a hospital with their corresponding devices and employees."
            }
            server = container "(HBMS) Server" "Implements logic for functionality of the regular devices management." {
                requestHandler = component "Request handler" "Retrieves and handles HTTP requests using JSON"

                authController = component "Auth controller" "Provides API for user authentication."
                deviceController = component "Device Controller" "Provides API for devices manipulations."
                driverController = component "Driver controller" "Provides API for devices drivers manipulations."

                authService = component "Auth Service" "Implements and provides functionality related to users authentication"
                logService = component "Log service" "Logs all operations made by users"
                # deviceService will use device data manager to manipulate with devices
                deviceService = component "Device service" "Implements and provides functionality related to manipulation with devices"
                driverService = component "Driver service" "Implements and provides functionality related to manipulation with devices drivers"
                
            }   

            deviceUpdater = container "Device Updater" "Worker responsible for the firmware and driver maintenance." {
                updateManager = component "Update Manager" "Expose the functionality to other component of the system, so they can be accessed via API or manually"
                statusResolver = component "System Status Resolver" "Retrieves the category of the devices that are under the regular check and decides if update is required."
                updatePlanner = component "Update Planner" "Schedules the suitable update window for the particular device so the regular service is not affected."
                versionResolver = component "Version Resolver" "Verifies the provided devices map to a current version of a drivers, firmware and software against the Hospital's devices register"
                updateTrigger = component "Update Installation Trigger" "Triggers the events of device update and propagates it to every issued component "
                updateWorker = component "Update Installation Worker" "Based on the resolved versions and categories installs the requested updates to the device "
            }
                        
            userDataManager = container "User Data Manager" "Manages data about users." "Relational Database With API" {
                userDataManagerGateway = component "User Data Manager Gateway" "provides access to external user data database"
            }
            
            deviceDataManager = container "Device Data Manager" "Manages data about devices." "Relational Database With API" {
                deviceDataManagerGateway = component "Device Data Manager Gateway" "provides access to external device data database"
            }


            singlePageApplication = container "Single-Page Application" "Provides all of the HBMS functionality to customers via their web browser." "JavaScript and Angular" "Web Browser"   
            
            !docs docs
        }

        singlePageApplication -> webFrontend "Makes API calls to" "JSON/HTTPS"

        # Hospital employees general database with API
        hospitalEmployeeDatabase = softwareSystem "Database of the hospital employees" "Stores data records about the hospital employees and provides API for Hospital Building Maintenance System." "Database"

        devicesRegistry = softwareSystem "Devices Registry" "Stores and presents the records of all hospital devices." "Existing System"

        driverIndex = softwareSystem "Index of all hospital's devices drivers" "Actual data storage index where all drivers and firmwares of hospital's devices are stored in the most recent version." "Existing System"
        
        regularUser = person "Regular User" "An actor who configures and schedules the cleaning devices or the building components (windows, lights, air condition)." "Consumer"

        administrator = person "Administrator" "An actor who manages the building maintenance devices and supports." "Consumer"

        device = softwareSystem "Device" "A device that is subject to the HBMS" "Existing System"
        

        # Relationships to/from software systems (Level 1)  
        regularUser -> hospitalBuildingMaintenance "Configures the cleaning devices and building systems"
        administrator -> hospitalBuildingMaintenance "Configures the drivers for the cleaning devices and manages accesses"

        hospitalBuildingMaintenance -> hospitalEmployeeDatabase "Uses hospital employee records from"
        hospitalBuildingMaintenance -> devicesRegistry "Harvests metadata records from"

        hospitalBuildingMaintenance -> driverIndex "Fetches a newer version of the firmwares and drivers from"
        devicesRegistry -> driverIndex "Indexes"
        
        
        # Relationships to/from containers (Level 2)
        regularUser -> singlePageApplication "Configures the cleaning devices and building systems"
        administrator -> singlePageApplication "Configures the drivers for the cleaning devices and manages accesses"

        webFrontend -> server "Uses to deliver functionality"

        server -> deviceUpdater "Uses to maintain drivers firmware"
        
        server -> userDataManager "Uses to retrieve information about the users including their system roles and permissions."
        server -> deviceDataManager "Uses to retrieve the information about the available devices and their current state."

        userDataManager -> hospitalEmployeeDatabase "Accesses the employees database "
        deviceDataManager -> devicesRegistry "Accesses the devices database "
        deviceDataManager -> device "Retrieves device information and current status and sends requests"

        device -> deviceDataManager "Retrieves device information and current status and sends requests"

        # relationships to/from components

        webFrontend -> requestHandler "Makes API calls to" "JSON/HTTPS"

        # server components
        requestHandler -> authController "Makes auth API call to authenticate user."
        requestHandler -> logService "Logs request"
        requestHandler -> deviceController "Makes device API call to search/add/delete devices"
        requestHandler -> driverController "Makes driver API call to manipulate with devices drivers"

        authController -> authService "Calls logic to authenticate users"
        deviceController -> deviceService "Calls logic to search/add/delete devices"
        driverController -> driverService "Calls logic to manipulate with drivers"

        authService -> userDataManager "Uses to retrieve information about the users including their system roles and permissions."

        deviceService -> deviceDataManager "Uses to retrieve the information about the available devices and their current state."
        
        driverService -> deviceUpdater "Maintain drivers firmware using"
        deviceUpdater -> driverService "Gets the category of the devices with relevant metadata." 

        # Device Updater - Component Relations and Decompositions

        updateManager -> webFrontend  "Expose the functionality to the GUI as well as to the REST-API "

        versionResolver -> devicesRegistry "Gets data and updates from "
        # We could ask data manager directly, but we need to know the current status of the devices to be posted into the planner
        statusResolver -> server "Gets the category of the devices with relevant metadata "
        updateManager -> server "Posts the information about the planned updated with the modified device schedule and state "
        updateTrigger -> updateManager "Reflects the information about scheduled update to the manager, so its actual for every listening service "
        updatePlanner -> updateTrigger "Posts the schedule for the devices that are in the current update scope "
        statusResolver -> versionResolver "Gets the information about the possible updates for the tracked devices "
    
        updateWorker -> device "Installs updates when in the device is in the appropriate state "
        updateTrigger -> updatePlanner "Initiates the planning with the current information about issued devices "
        updateTrigger -> statusResolver "Gets the information about the actual devices state "

        server -> updateManager "Maintain drivers firmware using"

        updateManager -> updateWorker "Adds task"

        # webFrontend components
        logInManager -> server "Makes API call to retrieve user record from DB"
        deviceCollectionProvider -> server "Makes API calls to [JSON/HTTPS]"

        searchManager -> deviceCollectionProvider "Uses to retrieve record of a particular device or list of devices based on the search query"
        driverManager -> deviceCollectionProvider "Uses to retrieve record of a particular device or group of devices to attach their driver settings"
        addDeviceManager -> deviceCollectionProvider "Uses to update the collection of devices by adding a new device"

        deviceScheduler -> searchManager "Uses to retrieve record of a particular device or list of devices for scheduling"
        deleteDeviceManager -> searchManager "Uses to retrieve record of a device for further agreement of a delete operation for this device"
        hospitalVisualizer -> searchManager "Uses to retrive records of devices that belong to a particular section"
        
        # DeviceDataManager components
        server -> DeviceDataManagerGateway "Uses to get high level functionality over raw device data"
        DeviceDataManagerGateway -> devicesRegistry "Uses to get all data regarding devices"
        
        # UserDataManager components
        server -> userDataManagerGateway "Uses to get high level functionality over raw employee data"
        userDataManagerGateway -> hospitalEmployeeDatabase "Uses to get all data regarding employees"

        deploymentEnvironment "Development" {
                deploymentNode "Developer Laptop" "" "Microsoft Windows 11 or Linux" {
                    deploymentNode "Web Browser" "" "Chrome, Firefox, Safari, or MS Edge" {
                        developerSinglePageApplicationInstance = containerInstance singlePageApplication
                    }
                    deploymentNode "Docker Container - Web Server" "" "Docker" {
                        deploymentNode "Apache Tomcat" "" "Apache Tomcat 8.x" {
                            developerWebApplicationInstance = containerInstance webFrontend
                            developerApiApplicationInstance = containerInstance server
                        }
                    }
                    deploymentNode "Docker Container - Database Server" "" "Docker" {
                        deploymentNode "Database Server" "" "Oracle 12c" {
                            developerDeviceDatabaseInstance = containerInstance deviceDataManager
                            developerUserDatabaseInstance = containerInstance userDataManager
                        }
                    }
                }
                deploymentNode "Existing Hospital" "" "Existing Hospital deployed environment" "" {
                    deploymentNode "hospital-dev001" "" "" "" {
                        softwareSystemInstance hospitalEmployeeDatabase
                        softwareSystemInstance devicesRegistry
                        softwareSystemInstance driverIndex
                    }
                }
            }
    }
    
    views {
        
        systemContext hospitalBuildingMaintenance "hospitalBuildingMaintenanceSystemContextDiagram" {
            include *
        }

        container hospitalBuildingMaintenance "hospitalBuildingMaintenanceContainerDiagram" {
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
        
        deployment hospitalBuildingMaintenance "Development" "DevelopmentDeployment" {
            include *
            animation {
                developerSinglePageApplicationInstance
                developerWebApplicationInstance developerApiApplicationInstance
                developerDeviceDatabaseInstance developerUserDatabaseInstance
            }
            autoLayout
        }        
        
        dynamic webFrontend "searchManager" "Summarises how the Device search function works." {
                searchManager -> server "Submits search request to Server"
                server -> deviceDataManager "Getting the needed data from"
                deviceDataManager -> devicesRegistry "Fetches data from"
                devicesRegistry -> deviceDataManager "Returns device data to"
                deviceDataManager -> server "Returns requested information"
                server -> searchManager "Returns request result"
                autoLayout
        }

        dynamic webFrontend "addDeviceManager" "Summarises how the Add Device function works." {
                addDeviceManager -> server "Sends add device request to"
                server -> deviceDataManager "Requests device collection update from"
                deviceDataManager -> devicesRegistry "Stores data of new device into"
                devicesRegistry -> deviceDataManager "Returns result of device data storage to"
                deviceDataManager -> server "Returns result of device addition operation with potentially discovered errors to"
                server -> addDeviceManager "Returns if new device was added successfully or not to"
                autoLayout
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

            element "Web Browser" {
                shape WebBrowser
            }

            element "Mobile App" {
                shape MobileDeviceLandscape
            }

            element "Database" {
                shape Cylinder
            }
        }

}