# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AWS learning path project set up as an IntelliJ IDEA Java project (JDK 13). The project is currently empty and ready for AWS-related development or learning materials.

## Development Environment

- **IDE**: IntelliJ IDEA
- **Java Version**: JDK 13
- **Project Type**: Java project (based on .iml configuration)

## Project Structure

The project is currently empty except for IDE configuration files. When adding content, consider organizing it based on AWS service categories or learning modules.

## Common AWS Services to Explore

- **EC2**: Virtual servers in the cloud
- **S3**: Object storage service
- **Lambda**: Serverless compute service
- **RDS**: Managed relational database service
- **DynamoDB**: NoSQL database service
- **IAM**: Identity and access management
- **VPC**: Virtual private cloud networking
- **CloudFormation**: Infrastructure as Code
- **API Gateway**: REST API management
- **SQS/SNS**: Message queuing and notification services

## Suggested Learning Path

1. **Foundational Services**: Start with IAM, VPC, EC2, and S3
2. **Database Services**: Explore RDS and DynamoDB
3. **Serverless**: Learn Lambda and API Gateway
4. **Infrastructure as Code**: Practice with CloudFormation
5. **Messaging**: Implement SQS and SNS patterns

## Code Organization Suggestions

```
src/
├── main/
│   ├── java/
│   │   ├── com/
│   │   │   └── awslearning/
│   │   │       ├── ec2/
│   │   │       ├── s3/
│   │   │       ├── lambda/
│   │   │       ├── database/
│   │   │       └── common/
│   └── resources/
│       └── application.properties
└── test/
    └── java/
```

## AWS SDK Dependencies

When you need to work with AWS services, add the appropriate AWS SDK v2 dependencies to your build configuration:

```xml
<!-- For Maven -->
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>aws-core</artifactId>
    <version>2.20.0</version>
</dependency>
```

## Notes for Future Development

When implementing AWS-related code:
- Consider the AWS service you're working with and check for appropriate SDK dependencies
- Ensure proper credential management (use AWS credential chain, never hardcode)
- Follow AWS best practices for the specific services being used
- Write unit tests for your AWS service interactions using mocks
- Implement proper error handling and logging
- Use environment-specific configuration for different AWS environments

## Best Practices

### Security
- Never commit AWS credentials to version control
- Use IAM roles and policies with least privilege principle
- Enable encryption for data at rest and in transit
- Regularly rotate access keys and secrets

### Cost Optimization
- Tag all resources for cost tracking
- Set up billing alerts
- Use appropriate instance types and sizes
- Clean up unused resources
- Consider using Spot instances for non-critical workloads

### Performance
- Use CloudWatch for monitoring and alerting
- Implement caching strategies (ElastiCache, CloudFront)
- Optimize database queries and indexes
- Use Auto Scaling for dynamic workloads

## Testing Approach

- Unit tests: Mock AWS SDK calls using Mockito
- Integration tests: Use LocalStack or AWS SDK test utilities
- End-to-end tests: Deploy to a test AWS account
- Performance tests: Use AWS X-Ray for tracing

## Useful Commands

```bash
# Configure AWS CLI
aws configure

# List all S3 buckets
aws s3 ls

# Check current AWS identity
aws sts get-caller-identity

# Validate CloudFormation template
aws cloudformation validate-template --template-body file://template.yaml
```