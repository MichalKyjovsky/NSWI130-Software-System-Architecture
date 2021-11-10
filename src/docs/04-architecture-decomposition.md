## Decomposition of the Architecture

The following chapter provides a decomposition and description of each container that is subject to our system.


![Hospital Building Maintanance Container Diagram](embed:hospitalBuildingMaintananceContainerDiagram)

### HBMS Web Front-End
The purpose of this container is to introduce the graphical user interface both for the administrator of the application and the regular user.


### HBMS Server
The following container represents the core functionality and business logic of our application. Our architecture acts as a controller over the model components (Device Data Manager, User Data Manager). Among other responsibilities and the most important one of the components is the interaction with devices in the hospital.  


### Device Data Manager
TBD

### User Data Manager
TBD

### Device Updater
The last container our system consists of is the ***Device Updater***. The ***Device Updater*** is responsible for the maintenance of the particular device, checking the version of its firmware and software, and the overall status. Furthermore, it provides updates and upgrades for the devices that are connected to the network and are actively deployed to the service.

Firstly we must declare that the responsibility of storing and managing the drivers was let upon to a standalone service which is not part of our system. Assuming that such a component will exist in the hospital's ecosystem was taken because other devices must be registered within a hospital and require regular drivers, firmware, or system maintenance. Therefore, having this assumption, we will be only querying the issued component and reducing our system's overall complexity and data redundancy. 


![Device Updater Component](embed:deviceUpdater)

The utilization of the updater will be enabled using the Admin UI. That literally means that the regular user will not have an access to the maintanance of the particular device. 


#### Workflow Scenario

The component will periodically scan the devices that will be grouped based on the common metric (modifiable - sector, producer, area of usage). **Update Intallation Trigger** will based on the **Update Manager** invocation starts the devices scan. First, the confirmation that the version index were updated and varies from the current devices version is performed. Based on the outcome of this subprocess either the updates end or continues to the **Update Planner**. The **Update Planner** will construct the most suitable schedule for update of the particular device so its regular or planned service is not affected anyhow. The constructed schedulle is then propagated to the ***Trigger*** component so it can be via ***Manager*** propagated to the particular device. This process must be synchronized and strongly relies on the schedulle status flag so the planning cannot be dead-locked by another system interaction. Finally the ***Manager*** posts the tasks to the ***Update Installation Worker***, which will handle the installation and update process for each device individually without any limitation to the system.
 <!-- TODO: Consider the limitation of the container interaction with the external entities. This could be moved to the HBMS Server, so the comunication with the devices is kept under one container. However, this could cause the performance issues considering all other functionalities that the server contaiener must span. Discuss this!  -->

#### Automatic update & upgrade resolution

First of all the system must be able to track the current version of the drivers, firmawares and software on each device. This can be done by the decomposition and categorization of the devices. Then in the scheduled intervals can be devices validated against the version of its system dependencies against the **Devices Registry** which stores the information about the most recent drivers, firmware and software required. The component then verifies that the device can be updated based on the versions resolution. When the device is about to be updated, the component then post request to a planner component which plans the regular update window for a device, so it won't affect the service. 

#### Update Manager

The container must communicate with others container. Firstly we need to provide the REST-API to Fron-End service, so the ***admin panel*** can visualize real-time data and statuses.
 <!-- TODO: Consider decomposing this component so the REST-API remains standalone service and some kind of publisher will post/get the data to/from the server  -->
Another responsibilty of the manager is to exchange the metadata information with the server, so the appropriate operaions can be performed. For an instance to set the valid state to a device that is under update check - so the schedulle modification are locked.