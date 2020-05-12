# Andrey recommendations

I'd recommend the following tools/technologies to incorporate to this CD pipeline:

## Different Orchestation system
### Kubernates

I chose Docker Swarm for this test due its simplicity and good internal load balacing, but we would get a most robust orchestration system using K8s. Commonly, Prod environments have larger clusters and continuos releases get deployed every minute, therefore scalability and high availability is really a need. 

## Code Scanning
### SonarQube

Great tool for code scanning and indexing. Of course would help in early stages to detect bugs and code smells before to get to Prod. 

## Monitoring
### Grafana / Prometheus with InfluxDB
I'd add some monitoring to the health of the instances, custom metrics and why not reporting to stakeholders. 

## Logging
### ELK stack 
To debug issues quickly in prod and any environment we can add logging system using ELK (Elastic search, Logstash and Kibana). We can deploy them in docker containers.

## Security
### Bastion / Jump Host
I'd a Bastion host as an extra security layer to access our application instances. 
