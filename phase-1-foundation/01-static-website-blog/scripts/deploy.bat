@echo off
REM Deploy script for AWS Learning Blog Static Website (Windows)

echo AWS Learning Blog - Deployment Script
echo ======================================

REM Check if AWS CLI is installed
where aws >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: AWS CLI is not installed
    exit /b 1
)

REM Get AWS account ID
for /f "tokens=*" %%a in ('aws sts get-caller-identity --query Account --output text 2^>nul') do set ACCOUNT_ID=%%a
if "%ACCOUNT_ID%"=="" (
    echo Error: Unable to get AWS account ID. Please configure AWS CLI.
    exit /b 1
)

set BUCKET_NAME=aws-learning-blog-%ACCOUNT_ID%
set STACK_NAME=aws-learning-blog

echo Using AWS Account: %ACCOUNT_ID%
echo S3 Bucket: %BUCKET_NAME%
echo.

REM Deploy CloudFormation stack
echo 1. Deploying CloudFormation stack...
aws cloudformation describe-stacks --stack-name %STACK_NAME% >nul 2>nul
if %errorlevel% equ 0 (
    echo    Stack exists. Updating...
    aws cloudformation update-stack ^
        --stack-name %STACK_NAME% ^
        --template-body file://../cloudformation/static-website.yaml ^
        --parameters file://../cloudformation/parameters.json ^
        --capabilities CAPABILITY_IAM
    
    echo    Waiting for stack update to complete...
    aws cloudformation wait stack-update-complete --stack-name %STACK_NAME%
) else (
    echo    Creating new stack...
    aws cloudformation create-stack ^
        --stack-name %STACK_NAME% ^
        --template-body file://../cloudformation/static-website.yaml ^
        --parameters file://../cloudformation/parameters.json ^
        --capabilities CAPABILITY_IAM
    
    echo    Waiting for stack creation to complete...
    aws cloudformation wait stack-create-complete --stack-name %STACK_NAME%
)

echo    √ Stack deployed successfully

REM Get CloudFront distribution ID
echo 2. Getting CloudFront distribution ID...
for /f "tokens=*" %%a in ('aws cloudformation describe-stacks --stack-name %STACK_NAME% --query "Stacks[0].Outputs[?OutputKey==`DistributionId`].OutputValue" --output text') do set DISTRIBUTION_ID=%%a
echo    Distribution ID: %DISTRIBUTION_ID%

REM Sync website files to S3
echo 3. Syncing website files to S3...
aws s3 sync ../website s3://%BUCKET_NAME% --delete --exclude ".git/*" --exclude ".DS_Store"
echo    √ Files synced successfully

REM Create CloudFront invalidation
echo 4. Creating CloudFront invalidation...
for /f "tokens=*" %%a in ('aws cloudfront create-invalidation --distribution-id %DISTRIBUTION_ID% --paths "/*" --query "Invalidation.Id" --output text') do set INVALIDATION_ID=%%a
echo    Invalidation ID: %INVALIDATION_ID%
echo    √ Invalidation created

REM Get website URL
for /f "tokens=*" %%a in ('aws cloudformation describe-stacks --stack-name %STACK_NAME% --query "Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue" --output text') do set WEBSITE_URL=%%a

echo.
echo Deployment complete!
echo ====================
echo Website URL: %WEBSITE_URL%
echo.
echo Note: CloudFront distribution may take 15-20 minutes to fully deploy globally.
pause