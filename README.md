# Deploying Selenium Grid on Docker Swarm :whale: 

We wrote two scripts, create.sh and destroy.sh. \
**The create.sh will**

- check related swarm is up, if not continue
- spin up the EC2 instances,
- add EC2 instances to a specific security group,
- set up the swarm manager and workers,
- create the Selenium Grid,
- deploy the Selenium Grid to AWS via Docker Compose.
- associate elastic ip to your manager node

**The destroy.sh will**

- remove EC2 instances to a specific security group,
- shut down the EC2 resources
- disassociate elastic ip

### How to run
- sh ./create.sh to create selenium grid
- sh ./destroy.sh to destroy selenium grid

You can read the below links for a detailed explanation \
[testdriven.io](https://testdriven.io/blog/distributed-testing-with-selenium-grid/) \
[qxf2.com](https://qxf2.com/blog/automating-the-setup-for-cloud-based-testing-with-selenium-grid-and-docker-swarm/)
