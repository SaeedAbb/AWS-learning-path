#!/bin/bash

# Deploy script for AWS Learning Blog Static Website

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}AWS Learning Blog - Deployment Script${NC}"
echo "======================================"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    exit 1
fi

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
if [ -z "$ACCOUNT_ID" ]; then
    echo -e "${RED}Error: Unable to get AWS account ID. Please configure AWS CLI.${NC}"
    exit 1
fi

BUCKET_NAME="aws-learning-blog-${ACCOUNT_ID}"
STACK_NAME="aws-learning-blog"

echo -e "${YELLOW}Using AWS Account: ${ACCOUNT_ID}${NC}"
echo -e "${YELLOW}S3 Bucket: ${BUCKET_NAME}${NC}"
echo ""

# Function to check if stack exists
stack_exists() {
    aws cloudformation describe-stacks --stack-name $1 &> /dev/null
}

# Deploy or update CloudFormation stack
echo -e "${GREEN}1. Deploying CloudFormation stack...${NC}"
if stack_exists $STACK_NAME; then
    echo "   Stack exists. Updating..."
    aws cloudformation update-stack \
        --stack-name $STACK_NAME \
        --template-body file://../cloudformation/static-website.yaml \
        --parameters file://../cloudformation/parameters.json \
        --capabilities CAPABILITY_IAM
    
    echo "   Waiting for stack update to complete..."
    aws cloudformation wait stack-update-complete --stack-name $STACK_NAME
else
    echo "   Creating new stack..."
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --template-body file://../cloudformation/static-website.yaml \
        --parameters file://../cloudformation/parameters.json \
        --capabilities CAPABILITY_IAM
    
    echo "   Waiting for stack creation to complete..."
    aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
fi

echo -e "${GREEN}   ✓ Stack deployed successfully${NC}"

# Get CloudFront distribution ID
echo -e "${GREEN}2. Getting CloudFront distribution ID...${NC}"
DISTRIBUTION_ID=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`DistributionId`].OutputValue' \
    --output text)

echo -e "   Distribution ID: ${DISTRIBUTION_ID}"

# Sync website files to S3
echo -e "${GREEN}3. Syncing website files to S3...${NC}"
aws s3 sync ../website s3://${BUCKET_NAME} \
    --delete \
    --exclude ".git/*" \
    --exclude ".DS_Store"

echo -e "${GREEN}   ✓ Files synced successfully${NC}"

# Create CloudFront invalidation
echo -e "${GREEN}4. Creating CloudFront invalidation...${NC}"
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

echo -e "   Invalidation ID: ${INVALIDATION_ID}"
echo -e "${GREEN}   ✓ Invalidation created${NC}"

# Get website URL
WEBSITE_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
    --output text)

echo ""
echo -e "${GREEN}Deployment complete!${NC}"
echo -e "${GREEN}===================${NC}"
echo -e "Website URL: ${YELLOW}${WEBSITE_URL}${NC}"
echo ""
echo -e "${YELLOW}Note: CloudFront distribution may take 15-20 minutes to fully deploy globally.${NC}"