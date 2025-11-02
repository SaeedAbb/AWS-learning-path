# 🚀 AWS Learning Path - Quick Start Guide

Welcome to your AWS learning journey! This guide will help you get started with your first project.

## Prerequisites

Before you begin, ensure you have:

1. **AWS Account**: Sign up at [aws.amazon.com](https://aws.amazon.com)
2. **AWS CLI**: Install from [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
3. **AWS CLI Configuration**: Run `aws configure` and enter your credentials

## Project Structure

```
AWS-learning-path/
├── CLAUDE.md                          # Guidance for Claude Code
├── README-TEMPLATE.md                 # Template for project READMEs
├── ARCHITECTURE-DIAGRAM-GUIDELINES.md # How to create architecture diagrams
├── QUICK-START.md                    # This file
├── phase-1-foundation/               # Foundation projects
│   ├── 01-static-website-blog/      # Your first project!
│   └── 02-compute-fundamentals/     # Next project
└── ... (more phases to come)
```

## 🎯 Your First Project: Static Website Blog

Let's deploy your first AWS project - a static website hosted on S3 with CloudFront CDN!

### Step 1: Navigate to the Project

```bash
cd phase-1-foundation/01-static-website-blog
```

### Step 2: Review the Architecture

Read the `README.md` to understand:
- What you're building
- AWS services involved
- Architecture design
- Cost estimates

### Step 3: Deploy the Infrastructure

**Windows:**
```bash
cd scripts
deploy.bat
```

**Mac/Linux:**
```bash
cd scripts
chmod +x deploy.sh
./deploy.sh
```

### Step 4: Customize Your Website

1. Edit the files in the `website/` folder
2. Add your own content, blog posts, and styling
3. Re-run the deployment script to update

### Step 5: Monitor and Learn

1. Check CloudWatch metrics in AWS Console
2. View CloudFront distribution settings
3. Explore S3 bucket configuration
4. Test the website from different locations

## 📚 Learning Tips

### 1. Start Small, Build Up
- Don't rush through projects
- Understand each AWS service before moving on
- Experiment with configurations

### 2. Document Everything
- Write blog posts about what you learn
- Take screenshots of AWS Console
- Note any issues and how you solved them

### 3. Cost Management
- Set up billing alerts immediately
- Use AWS Free Tier when possible
- Delete resources after documenting them

### 4. Best Practices from Day 1
- Always use IAM roles, never hardcode credentials
- Enable MFA on your AWS root account
- Tag all resources for easy identification

## 🛠️ Useful Commands

### Check Your AWS Configuration
```bash
aws sts get-caller-identity
```

### List Your CloudFormation Stacks
```bash
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE
```

### View S3 Buckets
```bash
aws s3 ls
```

### Get Stack Outputs
```bash
aws cloudformation describe-stacks --stack-name aws-learning-blog --query 'Stacks[0].Outputs'
```

## 🚨 Troubleshooting

### Common Issues

1. **"Access Denied" errors**
   - Check your IAM permissions
   - Ensure AWS CLI is configured correctly

2. **CloudFormation stack fails**
   - Check CloudFormation events in AWS Console
   - Review the error message carefully

3. **Website not accessible**
   - Wait 15-20 minutes for CloudFront distribution
   - Check S3 bucket policy

### Getting Help

- AWS Documentation: [docs.aws.amazon.com](https://docs.aws.amazon.com)
- AWS Forums: [forums.aws.amazon.com](https://forums.aws.amazon.com)
- Stack Overflow: Tag questions with `amazon-web-services`

## 📈 Next Steps

After completing the static website project:

1. **Add Features**:
   - Custom domain with Route 53
   - Contact form with Lambda
   - Blog search functionality

2. **Move to Project 2**:
   - EC2 Auto-Scaling Web Application
   - Learn about compute and scaling

3. **Share Your Progress**:
   - Write blog posts
   - Share on LinkedIn
   - Contribute to open source

## 🎊 Congratulations!

You're now ready to start your AWS learning journey. Remember:
- Take your time to understand each concept
- Don't be afraid to experiment
- Document your learnings
- Have fun building!

Happy learning! 🚀