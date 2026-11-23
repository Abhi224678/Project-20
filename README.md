
# Project 20: Load Balanced Application Deployment

## 1. Overview

The objective of this project is to improve application scalability, availability, and performance by deploying multiple Amazon EC2 instances behind an AWS Application Load Balancer (ALB).

The Application Load Balancer distributes incoming HTTP requests across two EC2 instances. It also performs health checks to ensure that requests are forwarded to healthy instances.

## 2. AWS Services and Technologies Used

- Amazon EC2
- Application Load Balancer (ALB)
- EC2 Target Groups
- Amazon VPC
- AWS Security Groups
- AWS CLI
- Ubuntu 24.04
- Nginx

## 3. Architecture

```text
                     Internet
                        |
                        v
              Application Load Balancer
                    HTTP : 80
                        |
                        v
                  Target Group
                 (abhijeet-p20-tg)
                        |
               +--------+--------+
               |                 |
               v                 v
          EC2 Instance 1    EC2 Instance 2
          (Nginx Server)    (Nginx Server)
               |                 |
               +--------+--------+
                        |
                  Health Checks
```

## 4. Implementation Steps

### Step 1: Created Two EC2 Instances

Launched two Ubuntu EC2 instances in separate Availability Zones within the same VPC.

| Configuration | EC2 Instance 1 | EC2 Instance 2 |
|---|---|---|
| Instance Name | project20-web-1 | project20-web-2 |
| Instance ID | i-07d0c03dfc9a28017 | i-037a278fbb6f24c77 |
| Private IP | 172.31.200.73 | 172.31.76.105 |
| Availability Zone | ap-south-1a | ap-south-1b |
| Instance Type | t2.micro | t2.micro |
| Operating System | Ubuntu 24.04 | Ubuntu 24.04 |

Both instances were successfully launched and passed their EC2 status checks.

### Step 2: Installed and Configured Nginx

Configured EC2 user data to automatically install and start Nginx on both instances.

Each instance hosts a custom webpage displaying its unique EC2 instance ID.

Example application webpage:

```html
<h1>Project 20 - Load Balanced Application</h1>
<p>Served by EC2 Instance: INSTANCE_ID</p>
```

This allows us to identify which EC2 instance handles each incoming request.

### Step 3: Created the Target Group

Created a target group named `abhijeet-p20-tg`.

| Configuration | Value |
|---|---|
| Target Group Name | abhijeet-p20-tg |
| Protocol | HTTP |
| Port | 80 |
| Target Type | Instance |
| Health Check Protocol | HTTP |
| Health Check Path | / |
| Expected HTTP Response | 200 |

Registered both EC2 instances with the target group.

### Step 4: Created the Application Load Balancer

Created an internet-facing Application Load Balancer named `abhijeet-p20-alb`.

| Configuration | Value |
|---|---|
| Load Balancer Name | abhijeet-p20-alb |
| Load Balancer Type | Application |
| Scheme | Internet-facing |
| Region | ap-south-1 |
| Availability Zones | ap-south-1a, ap-south-1b |
| IP Address Type | IPv4 |

Configured the load balancer to use two public subnets in separate Availability Zones.

### Step 5: Configured the HTTP Listener

Created an HTTP listener on port 80.

Configured its default action to forward incoming requests to the target group `abhijeet-p20-tg`.

This allows users to access the application through the load balancer DNS address.

### Step 6: Configured Health Checks

Configured HTTP health checks on port 80 using the `/` path.

The load balancer continuously checks whether both EC2 instances are responding successfully.

Both instances passed the health checks and reported the status `healthy`.

## 5. Verification and Testing

### Target Health Verification

Used the following AWS CLI command to verify the health of registered targets:

```bash
aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:ap-south-1:590507089733:targetgroup/abhijeet-p20-tg/22d44e3defda16f6 \
  --region ap-south-1
```

**Result:**

| EC2 Instance ID | Port | Health Status |
|---|---|---|
| i-037a278fbb6f24c77 | 80 | Healthy |
| i-07d0c03dfc9a28017 | 80 | Healthy |

Both EC2 instances successfully passed the health checks.

### Load Balancer Testing

Tested the application by sending ten consecutive HTTP requests to the load balancer.

Command used:

```bash
for i in {1..10}; do
  curl -s http://abhijeet-p20-alb-1715649473.ap-south-1.elb.amazonaws.com
  echo
done
```

**Result:**

The responses displayed both EC2 instance IDs.

Some requests were served by the first instance, while others were served by the second instance.

This confirmed that the Application Load Balancer was successfully distributing incoming requests across both EC2 instances.

## 6. Application Access

**Application Load Balancer DNS:**

http://abhijeet-p20-alb-1715649473.ap-south-1.elb.amazonaws.com

The application can be accessed directly through the ALB DNS address using a web browser.

## 7. Screenshots and Evidence

The following screenshots demonstrate the successful implementation:

| Screenshot | Description |
|---|---|
| P20-01-EC2-Instances.png | Both running EC2 instances |
| P20-02-Target-Health.png | Both registered targets showing Healthy status |
| P20-03-ALB-Listener.png | Application Load Balancer and HTTP listener configuration |
| P20-04-Load-Balancing-Proof.png | Terminal output showing responses from both EC2 instances |

## 8. Project Outcome

Successfully deployed a load-balanced web application using two Amazon EC2 instances and an Application Load Balancer.

The following objectives were achieved:

- Deployed two EC2 instances in separate Availability Zones.
- Installed and configured Nginx on both instances.
- Created and configured an Application Load Balancer.
- Registered both EC2 instances with a target group.
- Configured HTTP health checks.
- Verified that both instances were healthy.
- Successfully tested load distribution using multiple HTTP requests.
- Confirmed that requests were served by both EC2 instances.

## 9. Conclusion

This project demonstrates how AWS Application Load Balancing improves application scalability and availability by distributing incoming traffic across multiple EC2 instances.

The successful health checks and HTTP testing confirmed that the load balancer was functioning as expected.

**Project Status: Completed**
