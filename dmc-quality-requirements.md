# Doctor Monitoring and Communication (DMC) - Quality Attribute Requirements Scenarios Feedback

This document is intended as a brief summarization of the aspects of the Quality Attributes of the DMC system. The text
below further categorizes the requirements of the particular QA, so the roadmap is clear and easily extendable.

## List of Contents

1. [System Quality Attributes](#system-quality-attributes)
    - [Run-Time Quality Attributes](#run-time-quality-attributes)
    - [Design-Time Quality Attributes](#design-time-quality-attributes)
2. [Business Quality Attributes](#business-quality-attributes)
3. [Architectural Quality Attributes](#architectural-quality-attributes)

### Quality Requirement Scenario - Template

<hr>

<b>Requirement Scenario - \<REQUIREMENT NAME></b>
    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>TBD</td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox"></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>TBD</td>
        </tr>
    </table>

<hr>

<!-- SYSTEM -->

## System Quality Attributes

### Run-Time Quality Attributes

#### Performance

- <b>Requirement Scenario - Message Sender </b>

  <table>
      <tr>
          <th>Source of Stimulus</th>
          <td>Hospital employee</td>
      </tr>
      <tr>
          <th>Stimulus</th>
          <td>Send message to a colleague</td>
      </tr>
      <tr>
          <th>Artifact</th>
          <td>DMC Mobile App</td>
      </tr>
      <tr>
          <th>Environment</th>
          <td>Normal operation</td>
      </tr>
      <tr>
          <th>Response</th>
          <td>Message sent and delivered</td>
      </tr>
      <tr>
          <th>Measure</th>
          <td>
              <ul>
                  <li>
                      Message is sent with average latency of 10 milliseconds (instantly from user's point of view)
                  </li>
                   <li>
                      Message is delivered with average latency of 1 second (notification of successfull delivery is received within this interval)
                  </li>
              </ul>
          </td>
      </tr>
      <tr>
          <th>Requirement Fulfilled</th>
          <td><input type="checkbox" checked></td>
      </tr>
      <tr>
          <th>Comment</th>
          <td>Messages are stored within DMC system using Data Storage container with MySQL DB for internal data storage. Request is sent to the server through firewall gate and once the server receives a send message request, it can respond to it immediately (the message is considered sent if it's accepted by the server). External services don't need to be requested for sending the message successfully in terms of delivering it to the server. More time is needed to actually deliver the message as its recipient needs to be found first. The whole process of message exchange could be handled within Data Storage as we don't need to extract additional information of the recipient through Employees Catalog.</td>
      </tr>
  </table>

- <b>Requirement Scenario - Monitoring Info Extraction </b>

  <table>
      <tr>
          <th>Source of Stimulus</th>
          <td>Hospital employee</td>
      </tr>
      <tr>
          <th>Stimulus</th>
          <td>Monitor colleague's actions</td>
      </tr>
      <tr>
          <th>Artifact</th>
          <td>DMC Desktop App</td>
      </tr>
      <tr>
          <th>Environment</th>
          <td>Normal operation</td>
      </tr>
      <tr>
          <th>Response</th>
          <td>All available information of the particular employee received</td>
      </tr>
      <tr>
          <th>Measure</th>
          <td>Result is provided with average latency of 1 second</td>
      </tr>
      <tr>
          <th>Requirement Fulfilled</th>
          <td><input type="checkbox"></td>
      </tr>
      <tr>
          <th>Comment</th>
          <td>
              We have rather low latency tolerance and the system doesn't implement caching of employees and departments. It fetches data from external software systems for each monitoring request which generates overhead of additional API calls and network connection. A solution might be to add container for employees and departments data caching or extend usage of Data Storage container to handle the caching (it takes care of internal data storage already).
          </td>
      </tr>
  </table>

#### Security

- <b>Requirement Scenario - Security Scenario Mobile/Web app login</b>
    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>Malicious attacker Pepan</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>Bruteforce password attack to login as an existing user into the mobile/web application</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>DMC Mobile App / DMC Web app</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>Live online production version</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>After three unsuccessful logins the user account is blocked</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        Logging of all activity to trace where the attack comes from
                    </li>
                    <li>
                        After 3 unsuccessful login attempts the user has to request account unblock with mail/telephone/on place verification
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox" checked></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>Security is on the first place and by this way the requirement is nicely fulfilled. </td>
        </tr>
    </table>

- <b>Requirement Scenario - Security of messages</b>
    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>malicious attacker Vojtech</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>Interception of sent messages</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>DMC Mobile App / DMC Web app</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>Live online production version, user and attacker connected on the hospital Wifi network</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>Attacker intercepts encoded messages but cannot decode them</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        Messages are sent/received to/from the server encrypted by some standard safe encryption algorithm
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox" checked></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>
               Even though Vojtech can intercept the traffic between server and client it is just bunch of encrypted data which he cannot interpret without encryption keys that are securely stored and changed on a regular basis.
            </td>
        </tr>
    </table>

#### Availability

- <b>Requirement Scenario - Availability Scenario - Server failure</b>

    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>Hospital employees</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>System recovery after failures</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>DMC server</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>TEST, Prod</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>System recovered after failure</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        System is up after 5 minutes after failure
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox"></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>Since communication between hospital employees(doctors) is important for hospital functioning, the system must be available 24/7 and in case of failure(system crash etc.), it should be recovered relatively fast. It might be achieved using containers and load balancer which, in case of falling of any container, will start a new one. It might be useful to create healthcheck endpoint so it will be possible to check whether system is available or not. Healthcheck endpoint might be called every 5 seconds.</td>
        </tr>
    </table>

#### Scalability

- <b>Requirement Scenario - Scalability Scenario - High number of requests</b>

    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>Hospital employees</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>System stable during high requests ratio</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>DMC server</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>Performance, Prod</td>
        </tr>
        <tr>
            <th>Response</th>
            <td></td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        High amount of requests are sent
                    </li>
                    <li>
                        System works as expected, without failures
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox"></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>Since communication between hospital employees(doctors) is important for hospital functioning, the system must be stable even during high load. It might be achieved using containers and load balancer(or some alternative) which, in case of exceeding a certain limit of requests will start a new container(new instance). The other solution is to predict the maximum amount of requests and create a necessary amount of containers in advance.</td>
        </tr>
    </table>

### Design-Time Quality Attributes

#### Testability

- <b>Requirement Scenario - Test Scenario Automation for Widgets</b>
    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>QA Engineer</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>Mobile Application Deployment</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>DMC Mobile App</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>SIT,UAT,QAT</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>Results Captured</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        100% of actions assigned to widget components interracting with DMC Server can be automatically tested
                    </li>
                    <li>
                        100% of already deployed and tested components will be subject to a regression testing
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox" checked></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>Due to a direct comunication amon the DMC Mobile App container and DMC Server container the QA Engineer will be capable to determine the expected behavior and results or set of results that can be automated without loss of generality. The architecture should declare the interface, that would handle not only the various input provided by the test data, but also the load, that the component needs to handle.</td>
        </tr>
    </table>

- <b>Requirement Scenario - Data Encoder - Unit Test Coverage</b>
    <table>
        <tr>
            <th>Source of Stimulus</th>
            <td>Developer</td>
        </tr>
        <tr>
            <th>Stimulus</th>
            <td>Implementation of the Data Encoder</td>
        </tr>
        <tr>
            <th>Artifact</th>
            <td>Data Encoder [DMC Server]</td>
        </tr>
        <tr>
            <th>Environment</th>
            <td>Development</td>
        </tr>
        <tr>
            <th>Response</th>
            <td>Results Captured</td>
        </tr>
        <tr>
            <th>Measure</th>
            <td>
                <ul>
                    <li>
                        85% of test coverage of data-encoding methods within 1 man-day
                    </li>
                    <li>
                        Testing data extension on any adjustment to a data encoding scheme / algorithm
                    </li>
                </ul>
            </td>
        </tr>
        <tr>
            <th>Requirement Fulfilled</th>
            <td><input type="checkbox" checked></td>
        </tr>
        <tr>
            <th>Comment</th>
            <td>
                Data encoder does not have any dependency that would require extensive mocking strategy or implementation on the integration test level. The main focus can be determined to validate and verify the particular encoding schemes and algorithms on the level of the unit tests. Furthermore, great importance should be given to test data. The test coverage is lowered to 85% due to the expectancy of usage of the additional libraries of third-party providers.
            </td>
        </tr>
    </table>


<!-- BUSINESS -->

## Business Quality Attributes

<!-- ARCHITECTURE -->

## Architectural Quality Attributes

