workspace "Hospital Software Systems" "This workspace documents architecture of the Hospital Software Systems which enables hospital to monitor its employees and provides secure instant messaging functionality for employees" {

    model {
        doctorMonitoring = softwareSystem "Doctor Monitoring System (DMC)" "Provides doctor monitoring system and secure encrypted instant messaging between employees" {
            mobileApp = container "DMC Mobile App" "Provides all functionality for doctor monitoring and instant messaging via mobile app" {
                group "User interface" {
                    uiHandlerM = component "User interface handler" "Handles all user actions and calls responsible components"
                    messagingHandlerM = component "Messaging handler" "Provides message history, sends and receive messages"
                    monitoringHandlerM = component "Doctor monitoring handler" "Validates data from user and process data from server into desired format"
                    notificationHandlerM = component "Notification handler" "Component responsible for proper notification sending"
                }
                group "Server connection providers" {
                    dataEncoderM = component "Data encoder" "Encodes data which user wants to send to server"
                    dataDecoderM = component "Data decoder" "Decodes data which user received from server"
                    serverStubM = component "Server stub" "Provides communication with server"
                }
            }

            desktopApp = container "DMC Desktop App" "Provides all functionality for doctor monitoring and instant messaging via desktop app" {
                group "User interface" {
                    uiHandlerD = component "User interface handler" "Handles all user actions and calls responsible components"
                    messagingHandlerD = component "Messaging handler" "Provides message history, sends and receive messages"
                    monitoringHandlerD = component "Doctor monitoring handler" "Validates data from user and process data from server into desired format"
                    notificationHandlerD = component "Notification handler" "Component responsible for proper notification sending"
                }
                group "Server connection providers" {
                    dataEncoderD = component "Data encoder" "Encodes data which user wants to send to server"
                    dataDecoderD = component "Data decoder" "Decodes data which user received from server"
                    serverStubD = component "Server stub" "Provides communication with server"
                }
            }

            server = container "DMC Server" "Implements application security and all business functionality for doctor monitoring and instant messaging" {
                healthCheck = component "Health check endpoint" "Returns whether the server is alive or not"
		        group "Data encryption" {
                    dataEncoderS = component "Data encoder" "Encodes data which server wants to send to user"
                    dataDecoderS = component "Data decoder" "Decodes data which server received from user"
                }
                group "Business logic implementation" {
                    requestResolver = component "Request resolver" "Resolves request and chooses responsible business logic module"
                    messagingLogic = component "Messaging logic" "Implements own instant messaging business logic"
                    monitoringLogic = component "Monitoring logic" "Implements own doctor monitoring business logic"
                }
            }
	    
  	    loadBalancer = container "Load Balancer" "" {
	    	requestHandler = component "Request handler" "Resolves which server will handle the request"
		    healthChecker = component "Health checker" "Checks whether server is alive or not"
		    serverRestarter = component "Server restarter" "Starts a new container with server if any of servers is down"
	    }

            data = container "Data Collector" "Provides uniform data access point and collects requested data from different sources" {
                sourceResolver = component "Data source resolver" "Resolves data source for request"
                departmentsReader = component "Departments reader" "Reads data from departments catalog"
                employeesReader = component "Employees reader" "Reads data from employees catalog"
                internalReader = component "Internal data reader" "Reads internally stored data"
            }	    

            db = container "Data Storage" "Storage of messages and other internally needed data"

            !docs docs
        }

        employeesCatalog = softwareSystem "Employees Catalog" "Hospital software system which provides information about employees" "Existing System"

        departmentsCatalog = softwareSystem "Departments Catalog" "Hospital software system which provides information about departments" "Existing System"

        employee = person "Employee" "Hospital employee within hospital network who needs to contact doctors from various purposes" "Employee"

        # relationships to/from software systems
        employee -> doctorMonitoring "Interacts with other employees in"

        doctorMonitoring -> employeesCatalog "Reads data about doctors from"
        doctorMonitoring -> departmentsCatalog "Reads data about departments from"

        employeesCatalog -> departmentsCatalog "Reads data about departments from"

        # relationships to/from containers
        employee -> mobileApp "Access system functionality from smartphone"
        employee -> desktopApp "Access system functionality from computer"

        mobileApp -> loadBalancer "Uses to deliver functionality through"
        desktopApp -> loadBalancer "Uses to deliver functionality through"

        server -> data "Uses to acquire data"

        data -> db "Reads internal data from"
        data -> employeesCatalog "Reads employees data from"
        data -> departmentsCatalog "Reads departments data from"

        loadBalancer -> server "Checks whether server is alive"
        loadBalancer -> server "Delivers encrypted request to"

        # relationships to/from mobile app components
        employee -> uiHandlerM "Uses app functions by"
        serverStubM -> loadBalancer "Comunicates with"

        uiHandlerM -> messagingHandlerM "Uses to evaluate messaging actions"
        uiHandlerM -> monitoringHandlerM "Uses to evaluate doctor monitoring actions"

        notificationHandlerM -> uiHandlerM "Uses to display notifications to user"
        messagingHandlerM -> notificationHandlerM "Sends system notifications by"
        monitoringHandlerM -> notificationHandlerM "Sends system notifications by"

        messagingHandlerM -> dataEncoderM "Encode messages with"
        monitoringHandlerM -> dataEncoderM "Encode doctors monitoring updates with"
        dataDecoderM -> messagingHandlerM "Provides decoded incoming messages to"
        dataDecoderM -> monitoringHandlerM "Provides decoded doctors monitoring history to"

        dataEncoderM -> serverStubM "Sends data to server by"
        serverStubM -> dataDecoderM "Provides data from server to"

        # relationships to/from desktop app components
        employee -> uiHandlerD "Uses app functions by"
        serverStubD -> loadBalancer "Comunicates with"

        uiHandlerD -> messagingHandlerD "Uses to evaluate messaging actions"
        uiHandlerD -> monitoringHandlerD "Uses to evaluate doctor monitoring actions"

        notificationHandlerD -> uiHandlerD "Uses to display notifications to user"
        messagingHandlerD -> notificationHandlerD "Sends system notifications by"
        monitoringHandlerD -> notificationHandlerD "Sends system notifications by"

        messagingHandlerD -> dataEncoderD "Encode messages with"
        monitoringHandlerD -> dataEncoderD "Encode doctors monitoring updates with"
        dataDecoderD -> messagingHandlerD "Provides decoded incoming messages to"
        dataDecoderD -> monitoringHandlerD "Provides decoded doctors monitoring history to"

        dataEncoderD -> serverStubD "Sends data to server by"
        serverStubD -> dataDecoderD "Provides data from server to"

        # relationships to/from server components
        mobileApp -> requestHandler "Delivers encrypted request through"
        desktopApp -> requestHandler "Delivers encrypted request through"

        requestHandler -> dataDecoderS "Delivers encrypted request to"
        
        dataEncoderS -> requestHandler "Delivers encrypted response through"

        requestHandler -> mobileApp "Delivers encrypted response to"
        requestHandler -> desktopApp "Delivers encrypted response to"

        dataDecoderS -> requestResolver "Uses to choose responsible module"
        requestResolver -> messagingLogic "Uses to evaluate request"
        requestResolver -> monitoringLogic "Uses to evaluate request"

        messagingLogic -> data "Requests data from"
        monitoringLogic -> data "Requests data from"

        messagingLogic -> dataEncoderS "Uses to encrypt response"
        monitoringLogic -> dataDecoderS "Uses to encrypt response"

        healthChecker -> healthCheck "Checks whether server is alive"
        healthChecker -> serverRestarter "Triggers new server instance creation"

        # relationships to/from data components
        server -> sourceResolver "Uses to choose correct data source"
        
        sourceResolver -> internalReader "Reads data by"
        sourceResolver -> employeesReader "Reads data by"
        sourceResolver -> departmentsReader "Reads data by"
        
        employeesReader -> employeesCatalog "Requests external data from"
        departmentsReader -> departmentsCatalog "Requests external data from"
        internalReader -> db "Reads internal data"

        deploymentEnvironment "Live" {
            deploymentNode "Mobile device" "" "Android 8.0 or newer"  {
                mobile = containerInstance mobileApp
            }
            deploymentNode "Computer" "" "Microsoft Windows or Linux"  {
                desktop = containerInstance desktopApp
            }

            deploymentNode "Hospital server" "" "Ubuntu 20.04 LTS" {
                deploymentNode "Firewall" {
                    firewall = infrastructureNode "Gate" "Allows only communication from hospital network"
                }
                deploymentNode "nginx" "" "" "" "1" {
                    balancer = containerInstance loadBalancer
                }
                deploymentNode "PHP 8.0.*" "" "PHP" "" "4" {
                    liveServer = containerInstance server
                    containerInstance data
                }
                deploymentNode "MySQL DB" "" "MySQL 8.0.*" {
                    containerInstance db
                }
                deploymentNode "External hospital data"    {
                    softwareSystemInstance employeesCatalog
                    softwareSystemInstance departmentsCatalog
                }
            }
            mobile -> firewall "Sends request to server through"
            desktop -> firewall "Sends request to server through"
            firewall -> balancer "Delivers request from internal network through"
            balancer -> firewall "Delivers response through"
            firewall -> mobile "Delivers response"
            firewall -> desktop "Delivers response"

        }

        deploymentEnvironment "Mobile App Development" {
            deploymentNode "Developer Laptop"  {
                deploymentNode "Development enviroment" "" "Android Studio or Intellij Idea" {
                    containerInstance mobileApp
                }
            }
            deploymentNode "DMC develop" "" "DMC development infrastructure" {
                deploymentNode "DMC dev server" "" "Ubuntu 20.04 LTS"  {
                    deploymentNode "PHP" "" "PHP 8.0.*" {
                        containerInstance server
                        dataM = containerInstance data
                    }
                    deploymentNode "nginx" "" "" "" "1" {
                        containerInstance loadBalancer
                    }

                }
                deploymentNode "DMC dev data" "" "Ubuntu 20.04 LTS"  {
                    
                    deploymentNode "MySQL DB" "" "MySQL 8.0.*" {
                        containerInstance db
                        stubM = infrastructureNode "External DBs Provider" "Works as a stub of employees and departments catalog" "MySQL" "Infrastructure"
                    }
                }
            }
            dataM -> stubM "Accesses external development data from"
        }

        deploymentEnvironment "Desktop App Development" {
            deploymentNode "Developer Laptop" "" "Windows or Linux"  {
                containerInstance desktopApp
            }
            deploymentNode "DMC develop" "" "DMC development infrastructure" {
                deploymentNode "DMC dev server" "" "Ubuntu 20.04 LTS"  {
                    deploymentNode "PHP" "" "PHP 8.0.*" {
                        containerInstance server
                        dataD = containerInstance data
                    }
                    deploymentNode "nginx" "" "" "" "1" {
                        containerInstance loadBalancer
                    }
                }
                deploymentNode "DMC dev data" "" "Ubuntu 20.04 LTS"  {
                    
                    deploymentNode "MySQL DB" "" "MySQL 8.0.*" {
                        containerInstance db
                        stubD = infrastructureNode "External DBs Provider" "Works as a stub of employees and departments catalog" "MySQL" "Infrastructure"
                    }
                }
            }
            dataD -> stubD "Accesses external development data from"
        }
    }
    
    views {
        
        systemContext doctorMonitoring "doctorMonitoringSystemContextDiagram" {
            include *
        }

        container doctorMonitoring "doctorMonitoringContainerDiagram" {
            include *
        }

        component mobileApp "mobileAppComponentDiagram" {
            include *
        }

        component desktopApp "desktopAppComponentDiagram" {
            include *
        }

        component loadBalancer "loadBalancerComponentDiagram" {
            include *
        }

        component server "serverComponentDiagram" {
            include *
        }

        component data "dataComponentDiagram" {
            include *
        }

        deployment doctorMonitoring "Live" "Live_Deployment" {
            include *
            exclude mobileApp -> loadBalancer
            exclude desktopApp -> loadBalancer
            exclude loadBalancer -> mobileApp
            exclude loadBalancer -> desktopApp
        }

        deployment doctorMonitoring "Mobile App Development" "Mobile_App_Development_Deployment" {
            include *
        }

        deployment doctorMonitoring "Desktop App Development" "Desktop_App_Development_Deployment" {
            include *
        }

        dynamic * "Monitoring_System_Dynamic_View" "Doctor Monitoring System Scenario - Software System Dynamics"  {
            employee -> doctorMonitoring "Looks for other employee by"
            doctorMonitoring -> departmentsCatalog
            doctorMonitoring -> employeesCatalog
        }

        dynamic doctorMonitoring "Monitoring_Container_Dynamic_View" "Doctor Monitoring System Scenario - Container Dynamics"  {
            employee -> mobileApp "Looks for other employees by"
            mobileApp -> loadBalancer
            loadBalancer -> server
            server -> data
            data -> departmentsCatalog
            data -> employeesCatalog
            server -> loadBalancer
            loadBalancer -> mobileApp
        }

        theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }
        }
    }
}