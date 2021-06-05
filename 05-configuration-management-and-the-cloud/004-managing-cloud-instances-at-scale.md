# Week 4: Managing Cloud Instances at Scale

## Building Software for the Cloud

---

## 4.1.1 Storing Data in the Cloud  

Types of storage:

1. Block storage
2. Object storage
3. Blob storage

***Persistent storage***

> Used for instances that are long lived and need to keep data across reboots and upgrades

***Ephemeral storage***

> Used for instances that are only temporary and only need to keep local data while they're running  

***Object storage***

> Lets you place and retrieve objects in a storage bucket

***Blob***

> Binary large object

Common database types:

1. SQL (relational database)
2. NoSQL

***Question***

Which form of cloud data storage is based on objects instead of traditional file system?  
`( )` Relational databases  
`( )` Block storage  
`(✓)` Blob storage *(Blobs are pieces of data that are stored as independent objects, and require no file system)*  
`( )` NoSQL databases  

Performance of storage solution is influenced by a number of factors:

1. Throughput
2. IOPS
3. Latency

***Throughput***  

> The amount of data that you can read and write in a given amount of time  

***Input/Output Operations per Seconds (IOPS)***

> Measures how many reads or writes you can do in one second, no matter how much data you're accessing

***Latency***  

> The amount of time it takes to complete a read or write operation  

***Hot data***

> Accessed frequently and stored in hot storage  

***Cold data***

> Accessed infrequently and stored in cold storage

## 4.1.2 Load Balancing  

Load balancing techniques:

1. Round-Robin DNS
    Pros:
    * Easy to set up

    Cons:
    * Cannot control which IP addresses get picked by the clients
    * DNS records are cached by clients and other servers. So, if the IP addresses have to be changed, it is necessary to wait until all of the DNS records that were cached by the clients expire

2. Dedicated load balancer to route to specific backend server

***Sticky sessions***

> All requests from the same client always go to the same backend server

***Question***  

Which description fits the Round-Robin DNS load balancing method?  
`( )` Each client is served based on a complex calculation  
`( )` Each client is served based on the amount of traffic  
`( )` Each client is served randomly  
`(✓)` Each client is served in turn *(the Round-robin approach serves clients one at a time, starting with the first, and making rounds until it reaches the beginning again)*  

How to make sure the clients connect to the servers that are closest to them?  
**Use geoDNS and geoIP**  

***Content Delivery Network (CDN)***  

> Make up a network of physical hosts that are geographically located as close to the end users as possible  

## 4.1.3 Change Management  

***Change management***

> Make changes in a controlled and safe way

Typical tests performed prior to implementation of changes:

1. Unit tests
2. Integrity tests

***Continuous Integration (CI) System***

> Will build and test our code every time there's a change

Common CI systems:

1. Jenkins
2. Travis CI

We usually configure our Continuous Deployment (CD) system to deploy new builds only when all of the tests have passed successfully.  

***Environment***

> Everything needed to run the service

***Question***  

Automation tools are used to manage the software development phase's build and test functions. Which of the following is the set of development practices focusing on these aspects?  
`( )` Continuous Deployment  
`(✓)` Continuous Integration *(Continuous Integration means the software is built, uploaded, and tested constantly)*  
`( )` Pre-Prod  
`( )` Test environment  

***A/B testing***  

> Some requests are served using one set of code and configuration (A) and other requests are served using a different set of code and configuration (B)  

## 4.1.4 Understanding Limitations  

***Rate limits***  

> Prevent one service from overloading the whole system

***Utilization limits***  

> Cap the total amount of a certain resource that you can provision  

***Question***  

What is the purpose of a rate limit?  
`( )` Prevent over-provisioning of a certain resource  
`( )` Provide additional capacity  
`(✓)` To prevent overloading the entire system with one service *(Cloud providers will often enforce rate limits on resource-hungry service calls to prevent one service from overloading the entire system)*  
`( )` To restrict the frequency of login attempts  

## 4.1.5 More about Cloud Providers  

[GCP resource quotas](https://cloud.google.com/compute/quotas#understanding_vm_cpu_and_ip_address_quotas)  
[AWS service quotas](https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html)  
[Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#service-specific-limits)  

## 4.1.6 Quiz  

***Question 1***  

What is latency in terms of Cloud storage?  
`( )` The measure of how many reads or writes you can do in one second, no matter how much data you're accessing  
`( )` The amount of data that you can read, and write in a given amount of time  
`(✓)` The amount of time it takes to complete a read or write operation *(Latency is the amount of time it takes to complete a read or write operation)*  
`( )` The time delay between an input and output  

***Question 2***  

Which of the following statements about sticky sessions are true? (Select all that apply.)  
`[✓]` All requests from the same client always go to the same backend server *(Sticky sessions route requests for a particular session to the same machine that first served the request for that session)*  
`[ ]` Sticky sessions maintain an even load  
`[✓]` They should only be used when needed *(Because sticky sessions can cause uneven load distribution as well as migration problems, they should only be used when absolutely necessary)*  
`[✓]` They can cause problems during migration *(Sticky sessions can cause unexpected results during migration, updating, or upgrading, so it's best to use them only when absolutely necessary)*  

***Question 3***  

If you run into limitations such as rate limits or utilization limits, you should contact the Cloud provider and ask for a _____.  
`( )` Beta version  
`(✓)` Quota increase *(Our cloud provider can increase our limits that we have set, though it will cost more money)*  
`( )` A/B test  
`( )` Blob storage solution  

***Question 4***  

What is the term referring to everything needed to run a service?  
`(✓)` Environment *(Everything used to run the service is referred to as the environment. This includes the machines and networks used for running the service, the deployed code, the configuration management, the application configurations, and the customer data)*  
`( )` Provisions  
`( )` Utilization limits  
`( )` Continuous integration  

***Question 5***

What is the term referring to a network of hosts spread in different geographical locations, allowing ISPs to be as close as possible to content?  
`( )` Domain Name Service  
`( )` Continuous Deployment  
`( )` Platform as a Service  
`(✓)` Content delivery network *(CDNs allow an ISP to select the closest server for the content it is requesting)*  

## Monitoring and Alerting  

---

## 4.2.1 Getting Started with Monitoring  

Monitoring lets us look into the history and current status of a system.  

5xx error codes -> something bad on server side

4xx error codes -> client-side problem in the requests

Common monitoring services:

1. AWS CloudWatch
2. Google Stack Driver
3. Azure Metrics
4. Prometheus
5. Datadog
6. Nagios

Two ways of getting metrics:

1. Pull model (peridically query service to get metrics)
2. Push model (periodically connect to the system to send the metrics)

You only want to store the metrics that you care about, since storing all these metrics in the system takes space, and storage space costs money.  

***Question***  

Which of the following monitoring models is being used if our monitoring system requires our service to actively send metrics?  
`(✓)` Push model *(When push monitoring is used, the service being monitored actively sends metrics to the monitoring system)*  
`( )` Pull model  
`( )` Error monitoring  
`( )` Resource monitoring  

***Whitebox monitoring***  

> Checks the behavior of the system from the inside, e.g. knowing the information that wants to be tracked and possible to be tracked

***Blackbox monitoring***

> Checks the behavior of the system from the outside, e.g. checking the actual response matches the expected response

## 4.2.2 Getting Alerts When Things Go Wrong  

Basic alerting system in Linux  
`cron` job -> pair with Python script (check service and send email as alert)  

Raising an alert signals that something is broken and a human needs to respond.  

Systems are typically configured to raise alerts in 2 different ways

1. **Pages**: need immediate attention  
2. Non-urgent alerts via emails, mailing lists, or messaging services

All alerts should be ***actionable***.  

***Question***  

What do we call an alert that requires immediate attention?  
`( )` Ticket  
`(✓)` Page *(Pages are alerts that need immediate human attention, and are often in the form of SMS or email)*  
`( )` Cron job  
`( )` Bug report  

## 4.2.3 Service-Level Objectives  

***Service-Level Objectives (SLOs)***  

> Pre-established performance goals for a specific service  

SLOs need to be ***measurable***, means that there should be metrics that track how the service is performing and let you check if it is meeting the objectives or not. Many SLOs are expressed as how much time a service will behave as expected, e.g. available 99% of the time.  

99% -> two 9s service  
99.9% -> three 9s service  
99.9999% -> five 9s service  

Availability of 99% means a total down time of a service is up to 3.65 days in a year.  

Availability of 99.999% means a total down time of a service is up to 5 minutes in a year.  

***Service-Level Agreement (SLA)***  

> A commitment between a provider and a client  

The common cause of down time is ***new changes*** added in a service.  

***Error budget***

> A service that has three 9s of availability can be down 43 minutes per month, i.e. error budget is 43 minutes per month and has to be tracked  

If total down time is close to the error budget, it is good not to introduce any new changes, but try to solve the problems to reduce the down time.  

***Question***  

If our service has a Service Level Objective (SLO) of four-nines, what is our error budget measured in downtime percentage?  
`( )` .001%  
`( )` 1%  
`( )` .1%  
`(✓)` .01%  

## 4.2.4 Basic Monitoring in GCP  

## 4.2.5 More Information on Monitoring and Alerting  

## 4.2.6 Quiz  

## Troubleshooting and Debugging  

---

## 4.3.1 What to Do When You Can't be Physically There  

## 4.3.2 Identifying Where the Failure is Coming from  

## 4.3.3 Recovering from Failure  

## 4.3.4 Debugging Problems on the Cloud  

## 4.3.5 Quiz  
