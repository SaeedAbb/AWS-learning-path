# AWS Learning Blog - Static Website

## 🎯 Project Overview

**Brief Description**: A static website hosted on AWS S3 with CloudFront CDN distribution, custom domain via Route 53, and SSL certificate from ACM. This blog will document my AWS learning journey and serve as a practical example of static website hosting on AWS.

**AWS Services Used**:
- [x] Amazon S3 (Static Website Hosting)
- [x] Amazon CloudFront (Content Delivery Network)
- [x] Amazon Route 53 (DNS Management)
- [x] AWS Certificate Manager (SSL/TLS Certificates)
- [x] AWS CloudFormation (Infrastructure as Code)

**Architecture Pattern**: Static Website with CDN

**Estimated Monthly Cost**: $0.50 (Free Tier) / $5.00 (with custom domain)

## 📋 Business Requirements

### Problem Statement
As an AWS learner, I need a platform to document my learning journey, share insights, and demonstrate my understanding of AWS services. Traditional hosting solutions are either expensive or don't showcase AWS skills.

### Success Criteria
- [x] Website loads in under 2 seconds globally
- [x] 99.9% uptime availability
- [x] Secure HTTPS connection
- [x] Cost under $5/month
- [x] Easy content updates via S3
- [x] SEO-friendly URLs

### Constraints
- Budget: $5/month maximum
- Compliance: Public content only
- Performance: <2s load time globally

## 🏗️ Architecture

### High-Level Architecture Diagram
```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐     ┌─────────────┐
│   Users     │────▶│  Route 53    │────▶│ CloudFront   │────▶│  S3 Bucket  │
│ (Browsers)  │     │    (DNS)     │     │    (CDN)     │     │   (Origin)  │
└─────────────┘     └──────────────┘     └──────────────┘     └─────────────┘
                           │                      │
                           │                      ▼
                           │              ┌──────────────┐
                           └─────────────▶│     ACM      │
                                         │(Certificate)  │
                                         └──────────────┘
```

### Components Description
1. **S3 Bucket**: Stores all static website files (HTML, CSS, JS, images)
   - Bucket name: `aws-learning-blog-[your-account-id]`
   - Static website hosting enabled
   - Bucket policy for CloudFront access only

2. **CloudFront Distribution**: Global CDN for fast content delivery
   - Origin: S3 bucket
   - Price class: Use only North America and Europe
   - Caching behaviors optimized for static content

3. **Route 53**: DNS management for custom domain
   - Hosted zone for your domain
   - Alias record pointing to CloudFront

4. **Certificate Manager**: Free SSL/TLS certificate
   - Domain validation
   - Auto-renewal enabled

### Data Flow
1. User enters website URL in browser
2. Route 53 resolves domain to CloudFront distribution
3. CloudFront checks cache for requested content
4. If not cached, CloudFront fetches from S3 origin
5. Content delivered to user over HTTPS
6. CloudFront caches content for future requests

## 🚀 Deployment Guide

### Prerequisites
- AWS CLI installed and configured
- AWS Account with appropriate permissions
- Domain name registered (optional for custom domain)
- Node.js for build tools (optional)

### Quick Start
```bash
# Clone the repository
git clone [repository-url]
cd phase-1-foundation/01-static-website-blog

# Deploy the infrastructure
aws cloudformation create-stack \
  --stack-name aws-learning-blog \
  --template-body file://cloudformation/static-website.yaml \
  --parameters file://cloudformation/parameters.json \
  --capabilities CAPABILITY_IAM

# Upload website content
aws s3 sync ./website s3://aws-learning-blog-[your-account-id] --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation \
  --distribution-id [DISTRIBUTION_ID] \
  --paths "/*"
```

### Step-by-Step Deployment
1. **Create S3 Bucket**:
   ```bash
   aws s3 mb s3://aws-learning-blog-[your-account-id]
   ```

2. **Enable Static Website Hosting**:
   ```bash
   aws s3 website s3://aws-learning-blog-[your-account-id] \
     --index-document index.html \
     --error-document error.html
   ```

3. **Deploy CloudFormation Stack**:
   ```bash
   aws cloudformation create-stack \
     --stack-name aws-learning-blog \
     --template-body file://cloudformation/static-website.yaml
   ```

4. **Upload Content**:
   ```bash
   aws s3 sync ./website s3://aws-learning-blog-[your-account-id]
   ```

## 🔧 Configuration

### CloudFormation Parameters
| Parameter | Description | Default | Allowed Values |
|-----------|-------------|---------|----------------|
| DomainName | Custom domain for website | None | Valid domain |
| CertificateArn | ACM certificate ARN | None | Valid ARN |
| PriceClass | CloudFront price class | PriceClass_100 | PriceClass_* |

### S3 Bucket Configuration
- Versioning: Enabled
- Server-side encryption: AES-256
- Lifecycle rules: Delete old versions after 30 days
- Public access: Blocked (CloudFront only)

## 📊 Monitoring & Operations

### CloudWatch Dashboard
- **Metrics Monitored**:
  - CloudFront requests
  - Origin latency
  - Cache hit ratio
  - 4xx/5xx error rates
  - Data transfer

### Alarms Configured
| Alarm Name | Metric | Threshold | Action |
|------------|--------|-----------|--------|
| High Error Rate | 4xx Error Rate | > 5% | Email notification |
| Origin Latency | Origin Latency | > 1000ms | Email notification |
| Low Cache Hit | Cache Hit Rate | < 80% | Review caching rules |

## 🔒 Security Considerations

### IAM Roles and Policies
- **CloudFormation Role**: Deploy and manage resources
- **S3 Bucket Policy**: Allow CloudFront OAI access only

### Network Security
- CloudFront Origin Access Identity (OAI)
- S3 bucket not publicly accessible
- HTTPS only (redirect HTTP to HTTPS)
- Security headers via CloudFront

### Data Protection
- S3 server-side encryption (SSE-S3)
- CloudFront field-level encryption for forms
- TLS 1.2 minimum
- No sensitive data stored

## 💰 Cost Analysis

### Cost Breakdown (Monthly)
| Service | Usage | Free Tier | Estimated Cost |
|---------|-------|-----------|----------------|
| S3 Storage | 100 MB | 5 GB | $0.00 |
| S3 Requests | 10,000 | 20,000 | $0.00 |
| CloudFront Transfer | 5 GB | 1 TB | $0.00 |
| Route 53 Hosted Zone | 1 zone | 0 | $0.50 |
| Route 53 Queries | 1M | 0 | $0.40 |
| **Total** | | | **$0.90** |

### Cost Optimization Strategies
1. Use S3 Intelligent-Tiering for infrequently accessed content
2. Optimize images and use modern formats (WebP)
3. Set appropriate cache headers to reduce origin requests
4. Use CloudFront price class for required regions only

## 🧪 Testing

### Performance Testing
```bash
# Test with curl
curl -w "@curl-format.txt" -o /dev/null -s https://your-domain.com

# Load testing with Apache Bench
ab -n 1000 -c 10 https://your-domain.com/
```

### Content Validation
```bash
# Check all links
python scripts/link-checker.py https://your-domain.com

# Validate HTML
python scripts/html-validator.py
```

## 🛠️ Troubleshooting

### Common Issues
1. **Issue**: 403 Forbidden Error
   - **Solution**: Check S3 bucket policy and CloudFront OAI configuration

2. **Issue**: CloudFront not updating content
   - **Solution**: Create invalidation or check cache headers

3. **Issue**: SSL certificate errors
   - **Solution**: Ensure certificate covers domain and www subdomain

### Debug Commands
```bash
# Check S3 bucket policy
aws s3api get-bucket-policy --bucket aws-learning-blog-[account-id]

# View CloudFront distribution
aws cloudfront get-distribution --id [DISTRIBUTION_ID]

# Test DNS resolution
nslookup your-domain.com
```

## 📝 Lessons Learned

### What Went Well
- CloudFormation made deployment reproducible
- CloudFront significantly improved global performance
- S3 static hosting is extremely cost-effective

### Challenges Faced
- **Challenge**: Initial CloudFront propagation took 15+ minutes
  - **Resolution**: Plan deployments accordingly, use blue-green for updates

- **Challenge**: Cache invalidation costs can add up
  - **Resolution**: Use versioned file names for assets

### Future Improvements
- [ ] Add CI/CD pipeline with GitHub Actions
- [ ] Implement A/B testing with CloudFront
- [ ] Add contact form with Lambda and SES
- [ ] Integrate with AWS WAF for additional security
- [ ] Add blog search with CloudSearch

## 🔄 Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | 2024-11-02 | Initial release | Saeed |

## 📚 References

- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Best Practices](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/best-practices.html)
- [Route 53 Documentation](https://docs.aws.amazon.com/route53/latest/developerguide/Welcome.html)

---

*This project is part of my AWS learning journey. Follow my progress at [your-domain.com]!*