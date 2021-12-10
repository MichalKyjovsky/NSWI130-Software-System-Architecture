## Views

### How are the views documented?

The software architecture of NODC is further documented according to 
the [C4 model](https://c4model.com/) using its 2 levels - 
[container](https://c4model.com/#ContainerDiagram) level and 
[component](https://c4model.com/#ComponentDiagram) level. The documentation 
also uses supplementary diagrams - 
[deployment diagrams](https://c4model.com/#DeploymentDiagram) and 
[dynamic diagrams](https://c4model.com/#DynamicDiagram).

### DMC Decomposition View

DMC business functionality is implemented by the DMC Server container. Human 
users interact with mobile or desktop application provided by DMC Mobile App or 
DMC Desktop app container respectively. The server container uses two 
supplemental containers Data Collector and Data Storage for collecting external 
and storing internal data respectivelly.

![](embed:doctorMonitoringContainerDiagram)

### DMC Mobile App and Desktop App Decomposition Views

DMC Client Apps (Mobile App and Desktop app) has very similar decomposition and 
only technologies used differ, so this description applies to both diagrams.

Client apps internal architecture comprises 2 layers:
- User Interface layer provides user friendly interface for users on thier 
mobile devices and commputers.
- Server Connection Providers layer provides data encryption, decription and 
also secure connection to server instance itself.

#### Mobile Component Diagram

![](embed:mobileAppComponentDiagram)

#### Desktop Component Diagram

![](embed:desktopAppComponentDiagram)

### DMC Server Decomposition Views

Server internal architecture comprises 2 layers:
- Data Encryption layer provides data encryption and decryption
- Business Logic layer provides implementation of business logic

![](embed:serverComponentDiagram)

### DMC Data Collector Decomposition Views

Is responsible for collecting data from different data sources.

![](embed:dataComponentDiagram)

### DMC Deployments

There exist various DMC deployment environments.

#### DMC Live Deployment

This deployment is the desired production environment of DMC.

![](embed:Live_Deployment)

#### DMC Mobile App Development Deployment

This deployment is mandatory for all DMC Mobile App developers and their unit tests.

![](embed:Mobile_App_Development_Deployment)

#### DMC Mobile App Development Deployment

This deployment is mandatory for all DMC Desktop App developers and their unit tests.

![](embed:Desktop_App_Development_Deployment)

### DMC Dynamic Diagrams

Specific use cases are represented by dynamic diagrams.

#### Doctor Monitoring Use Case

![](embed:Monitoring_System_Dynamic_View)

![](embed:Monitoring_Container_Dynamic_View)
