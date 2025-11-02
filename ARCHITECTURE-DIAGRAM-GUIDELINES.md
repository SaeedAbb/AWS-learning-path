# Architecture Diagram Guidelines

## 🎨 Tools for Creating AWS Architecture Diagrams

### Recommended Tools
1. **draw.io (diagrams.net)** - Free, web-based
   - AWS icon library available
   - Export to PNG/SVG
   - Version control friendly

2. **Lucidchart** - Professional tool
   - AWS architecture templates
   - Collaboration features
   - Free tier available

3. **AWS Architecture Icons**
   - Official icon set: https://aws.amazon.com/architecture/icons/
   - Use consistent, official icons

4. **PlantUML** - Code-based diagrams
   - Version control friendly
   - Reproducible diagrams
   - Good for CI/CD integration

## 📐 Diagram Standards

### General Principles
1. **Clarity over Complexity**
   - Show only what's necessary
   - Avoid cluttered diagrams
   - Use multiple diagrams for different aspects

2. **Consistency**
   - Use official AWS icons
   - Consistent color schemes
   - Standard flow directions (left-to-right or top-to-bottom)

3. **Context**
   - Include diagram title
   - Add legend if needed
   - Date and version number

### Color Conventions
- **Blue**: AWS services
- **Green**: Success paths/healthy state
- **Orange**: Warning states
- **Red**: Error paths/unhealthy state
- **Gray**: External systems
- **Black**: Network boundaries

## 📊 Types of Architecture Diagrams

### 1. High-Level Architecture
**Purpose**: Overview for stakeholders
**Include**:
- Major components
- Service boundaries
- Data flow direction
- External integrations

**Example Structure**:
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   CloudFront    │────▶│   S3 Bucket     │────▶│    Lambda       │
│      (CDN)      │     │ (Static Files)  │     │  (Processing)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### 2. Detailed Technical Architecture
**Purpose**: Implementation guide for developers
**Include**:
- All AWS services
- Security groups/NACLs
- Availability zones
- Subnet configurations
- IAM roles

### 3. Data Flow Diagram
**Purpose**: Show how data moves through the system
**Include**:
- Data sources
- Transformation points
- Storage locations
- Data formats

### 4. Network Architecture
**Purpose**: Network topology and security
**Include**:
- VPCs and subnets
- Route tables
- Internet/NAT gateways
- VPN connections
- Security groups

### 5. Disaster Recovery Diagram
**Purpose**: Backup and recovery strategy
**Include**:
- Primary and secondary regions
- Replication paths
- RTO/RPO indicators
- Failover mechanisms

## 🏷️ Labeling Best Practices

### Service Labels
```
Service Name
(Instance Type/Config)
Purpose/Role
```

Example:
```
EC2 Auto Scaling Group
(t3.micro, min:2, max:10)
Web Application Servers
```

### Connection Labels
- Show data flow direction with arrows
- Label with protocol/port when relevant
- Include data format (JSON, XML, etc.)
- Show sync/async communication

Example:
```
──HTTPS/443──▶
──SQS Queue──▶
◀──S3 Event──
```

## 📋 Diagram Checklist

Before finalizing your architecture diagram, ensure:

- [ ] **Title and Metadata**
  - [ ] Descriptive title
  - [ ] Date created/updated
  - [ ] Version number
  - [ ] Author information

- [ ] **Visual Clarity**
  - [ ] Official AWS icons used
  - [ ] Consistent sizing
  - [ ] Clear flow direction
  - [ ] No overlapping elements
  - [ ] Appropriate use of color

- [ ] **Technical Accuracy**
  - [ ] All services labeled
  - [ ] Availability zones shown
  - [ ] Security boundaries marked
  - [ ] Correct service relationships

- [ ] **Documentation**
  - [ ] Legend included (if needed)
  - [ ] Key assumptions noted
  - [ ] Scaling indicators
  - [ ] Cost considerations

## 🎯 Examples by Project Type

### Static Website Architecture
Key Elements:
- S3 bucket (public/private)
- CloudFront distribution
- Route 53 DNS
- Certificate Manager

### Serverless API Architecture
Key Elements:
- API Gateway
- Lambda functions
- DynamoDB tables
- Cognito user pool
- CloudWatch logs

### Microservices Architecture
Key Elements:
- ECS/EKS clusters
- Application Load Balancer
- Service discovery
- RDS/DynamoDB
- ElastiCache
- SQS/SNS for messaging

## 💡 Pro Tips

1. **Start Simple**: Begin with boxes and arrows, refine later
2. **Version Control**: Save diagram source files, not just exports
3. **Reusable Components**: Create templates for common patterns
4. **Accessibility**: Include text descriptions for diagrams
5. **Review Process**: Have someone else validate your diagrams

## 🔗 Resources

- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [draw.io AWS Shapes](https://www.diagrams.net/blog/aws-diagrams)
- [AWS Icons for PowerPoint](https://aws.amazon.com/architecture/icons/)

---

Remember: A good architecture diagram should tell a story about your system. Someone should be able to understand what your system does and how it works just by looking at the diagram.