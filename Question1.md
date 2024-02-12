Assume now that you are an SRE who is responsible for maintaining the Availability & Uptime of the company’s environment, which was described previously in the Scenario. At 4:35pm on Friday, there were reports of customers being unable to access the website coming in; at 4:35pm the “Web_Application_Alive” test began failing. Complete the following questions with a full, in-depth, and detailed write-up/response for each:
1. Describe the steps that you would take to begin debugging the problem, to determine what might be going on.
2. What metrics, monitoring, or other tooling/processes would you expect to have available within your monitoring system to identify and validate the infrastructure is performing in a functional, healthy state?
3. What changes or improvements could be made to the Architecture to reduce the risk of a similar incident?
Now that the issue was resolved, and the environment is back into a healthy state; complete the following:
1. Create an After-Action Report (Post-Mortem/Post-Incident Review). It should include, at minimum, the following sections (more is highly encouraged):
a. High-level Summary
b. Participants (include who would be invited to an After Action Report Discussion, as well other stakeholders who were involved in the incident)
c. Timeline
d. Root Cause Analysis


1. Below are initial steps I will take to begin to debug the problem.
   =====================================================================

a. Initial Triage:
    - I will verify the reports of customer access issues and the failure of the "Web_Application_Alive" test at 4:35pm.
    - I will check if the issue is widespread or localized to specific regions or services.

b. Access and analyse Logs and Metrics:

   - I will review access logs and metrics from the ALB to identify any sudden drops in traffic or abnormalities in request patterns.
   - Check CloudWatch metrics for the ALB, EC2 instances, RDS, and other relevant services for any spikes or anomalies in error rates, latency, or throughput.

c. Infrastructure Health Checks:

    - I will check the status of EC2 instances, RDS database, ALB, and other critical resources to ensure they are running and healthy.
    _ will also verify network connectivity within the VPC and between availability zones.

d. Application Logs:

    - I wil review application logs on the web servers for any errors or exceptions that might indicate issues with the application code or dependencies.
    - I will check database logs for any errors or performance issues.

e. Security Group and Network Configuration:

    - I will check to ensure that security group rules and network ACLs are correctly configured to allow traffic to reach the web servers and database.

f. DNS Resolution:

    - I will verify that DNS resolution is working correctly and the domain is correctly mapped to the ALB.

g. Third-party Service Dependencies:

    - I will check for any dependencies on external services or APIs and investigate if there are any issues with those services.

h. Consultation with Team:

    I will collaborate with team members, including developers, network engineers, and database administrators, to gather additional insights and troubleshoot the issue.

2. Metrics, Monitoring, and Tooling:
   =================================

a. CloudWatch Metrics:

    1. ALB metrics: Requests count, Target connection errors, HTTP code targets, etc.
    2. EC2 metrics: CPU utilization, Network in/out, Status checks, etc.
    3. RDS metrics: CPU utilization, Database connections, Read/write latency, etc.

b. CloudWatch Synthetics:

    Monitor the "Web_Application_Alive" test for availability and response time.

c. Infrastructure Monitoring Tools:

    I will use Use tools like Datadog, New Relic, or Prometheus for additional insights into system performance and application health.

d. Log Management:

    I will also use centralized log management tools like AWS CloudWatch Logs, ELK Stack, or Splunk to analyze application and system logs for errors and abnormalities.

e. Alerting and Notification:

    I wil set up proactive alerting based on predefined thresholds for key metrics to detect and respond to issues in real-time.

3. Possible changes and improvement that can be made in the architectural design to reduce the risk of similar incident include the following;
=======================================

a. Multi-AZ Deployment for RDS:

    Deploying RDS in multiple availability zones will lead to higher availability and fault tolerance.

b. Auto Scaling for EC2 Instances:

    Implementing auto-scaling will automatically adjust the number of EC2 instances based on traffic patterns to handle fluctuations in demand. This will also be cost saving

c. Implementing Infrastructure as Code (IaC):

    The use IaC tools like AWS CloudFormation or Terraform to manage infrastructure configuration will ensure consistency and reproducibility.

d. Enhanced Monitoring and Logging:

    This will increase granularity in monitoring and logging to detect and troubleshoot issues more effectively.

e. Disaster Recovery Plan:

    Developing and regularly testing and updating a comprehensive disaster recovery plan will help to quickly recover from outages or failures.

4. After-Action Report (Post-Mortem/Post-Incident Review):
   =======================================================

a. High-level Summary:

    A customer-reported issue of website inaccessibility was identified at 4:35pm, coinciding with the failure of the "Web_Application_Alive" test. The incident was resolved, and the environment returned to a healthy state.

b. Participants:

    SRE team, developers, network engineers, database administrators, stakeholders from operations and customer support.

c. Timeline:

    4:35pm: Reports of customer access issues and failure of "Web_Application_Alive" test.
    4:35pm - 5:30pm: Initial triage, debugging, and resolution efforts.
    5:30pm: Issue identified and resolved; environment back to a healthy state.

d. Root Cause Analysis:

    The root cause was identified as a misconfiguration in the security group rules, which inadvertently blocked incoming traffic to the ALB, resulting in the website inaccessibility. The misconfiguration was rectified, restoring normal operation.