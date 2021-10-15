# NSWI130-Software-System-Architecture


### Preface

This repository serves to submit the assignments for the NSWI130 - Software System Architecture course enrolled on the faculty of Mathematics and Physics at Charles University.

### Prerequisite
- Docker installed: [Docker - Get Started](https://www.docker.com/get-started)

### Used software

To develop the architecture schemes using the C4 Model standard, we will be using the [Structurizr Lite](https://structurizr.com/help/lite) DSL.

For installation via Docker, please follow the following steps:

- Run the Docker daemon (Docker for Windows or via a command on Linux)
- Based on your OS, execute the `pull-structurizr-img` script to obtain the Structurizr Lite image to your local Docker registry.
- Finally, execute the `run-structurizr` script to start the Docker container that will load the project held by the src directory and populates it to the `localhost:8080`

## Team Topic: **Hospital Building Maintanace**

### Input (Requirement Analysis)

**Target platforms:** *Web/Mobile*

We are developing the Building Maintance for the Hospital. The Hospital is organized into the floors and the sections (rooms). These rooms are categorized onto:
- **Rooms for patients** (*out of scope of these requirements*)
- **Other rooms** - shared rooms, operating rooms, halls, etc. 

The application will be used by the qualified employees which have appropriate rights to use our software. We will be using already implemented database of the Hospital's employees, therefore; all information about the particular employee is already known.

#### Functional Requirements:

The following section summarizes the *Functional Requirements* of the project in a non-formatted way. Please feel free to extend any additional remarks or observations. 

- User-friendly (intuitive) visualization of the hospital, so the employee can easily orientate. (We are not required to develop mockups or wireframes but consider how possible choices of visualization affects the SW Architecture)
Each room/section has an associated collection of **states** of each of the devices that our application can handle, i.e., *window - opened/closed*, *air-condition - on/off*, etc.
-  Each floor has associated the cleaning devices that can be scheduled and triggered automatically by our system
   -  We can expect that there are no barriers on the floor that our application should consider, i.e., stairs 
   -  We can expect that the device is connected to the PAN, has a unique ID, variable API (depends on the constructor of the particular device), and its firmware is somehow intelligent
   -  We should consider that the APIs of the devices vary and can be changed, replaced or if the new device is acquired, then it is not yet supported
   -  The cleaning devices can be scheduled to perform tasks and the proper time - even periodically
   -  Consider the behavior of the devices at the risk situations - battery low/ lack of the internet, etc.
   -  Addition of new devices or removal of the obsolete ones
   -  Track the history of the particular devices, i.e., who configured it last time, etc.
   -  We do not have to consider user-rights system (either consider that this is taken care of out of the box or prepare your system for the right access check)
   -  Authentication and authorization process (can be dependent on outer services)
   -  We can expect outer services that could help our purposes yet are out of the scope of this project
   -  The architecture should be moreover universal for Web/Mobile platforms (This could be tricky since web-servers, reverse-proxies, or monitoring won't be present on the mobile device - depends - to be discussed)
   -  Consider the physical/manual interaction with the devices simultaneously with the automated one - prepare precedence behavior/fallback strategies
  

#### Non-Functional Requirements

The following section summarizes our system's *Non-Functional Requirements* that should be considered and reflected in the architecture. Those requirements are mainly targeted to reduce the overall costs, duration of the development, and the entire system's final complexity.

- The system should consider the security constraints
- The system should be designed efficiently considering the performance
- The system should be scalable and extensible
- The system should be designed in a way to support newly acquired devices easily
- The system should be robust

All architectonical decisions that consider the points listed above must be documented within the output diagrams.

### Output

The C4 Model diagram on the first three levels of the abstraction with the detailed component description and the architectonical decisions that have been made.