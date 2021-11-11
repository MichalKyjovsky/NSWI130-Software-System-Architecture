## Stakeholders


### Initial analysis

- hospital employees working with the devices connected to the system
  - doctors, maintenance workers, ...
- hospital owner
- hospital CEO (head of the hospital)
- investors (relevant especially for private hospitals)
- developers

#### Concerns

##### Employees

- intuitive user interface
- accessibility (the system shouldn't crash in case of a power outage, it should have a backup server)
- scalability, multi-platform usage (delivered as both web and mobile application, compatible with all widely used operating systems - Windows, Linux, Mac, Android, iOS)
- safety (regarding user data protection)
- support service (technical, quick response if an error occurs)
- backlog (information storage for monitoring of performed operations, including names of the operators, for easier issue tracking)
- safety handling (the manual control should be preferred over the remote control, system's security policy should prevent unauthorized users from manipulating with the devices)

##### Owner

- reliability, safety
- reasonable price (for both system's setup and its maintenance, especially the maintenance as it's the long-term cost)
- scalability (possibility to add new features in the future)
- external security service
- modern and well-documented (the employees might not be willing to work with a system that is too complex or obsolete)

##### Developers

- convenient maintenance (the system should be built on modern technologies with solid documentation, support and community)

- well-documented API, code examples for different use cases
- continuous integration, automatization, tests (unit tests, integration tests)
- best code practices (readable code, suitable design patterns)
- code reviews (from other developers, testers)
- clear specification of new features
- precisely maintained issue tracker


### Actual Reflection


#### Regular User

Regular User is meant as an user which directly interacts with the application on the daily bases. Literally, it can be janitor, cleaner, nurse. The use-cases of such user is to interact with the devices that have direct relation to the sector they are placed (lights, window, aircondition) and with devices intended for cleaning (hovers, window-cleaners). In addition user must be able to see the history of the particular device - hence last queries/commads and their invoker. Finally, the user must have an option to contact the support if they face any technical difficulties. 


#### Administrator

Administrator is responsible for maintaining access to the particular sectors and to the particular user. If the automatic resolving of the devices upgrades and updates fails, they must be provided with the graphical user interface enabling the manual configuration of the update/upgrade procedures. 

#### Device

The device represents the entity that is contolled with our application. Device interacts with our application to obtain the new drivers, firmware and software. Among other use-cases belongs the continuos state reporting, so the user are acknowledged about the state of the particular device. 

##### TODO: Define device states (unify on some level of abstraction)