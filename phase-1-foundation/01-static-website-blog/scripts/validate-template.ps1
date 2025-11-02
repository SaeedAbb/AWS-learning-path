# PowerShell script to validate CloudFormation template
# This script performs multiple validation checks

Write-Host "CloudFormation Template Validator" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

$templatePath = "..\cloudformation\static-website.yaml"

# Check if template file exists
if (!(Test-Path $templatePath)) {
    Write-Host "Error: Template file not found at $templatePath" -ForegroundColor Red
    exit 1
}

Write-Host "`n1. Checking YAML syntax..." -ForegroundColor Yellow
try {
    # Basic YAML syntax check using PowerShell
    $null = Get-Content $templatePath -Raw | ConvertFrom-Yaml -ErrorAction Stop
    Write-Host "   ✓ YAML syntax is valid" -ForegroundColor Green
} catch {
    Write-Host "   ✗ YAML syntax error: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. Validating with AWS CLI..." -ForegroundColor Yellow
# Check if AWS CLI is installed
$awsCommand = Get-Command aws -ErrorAction SilentlyContinue
if ($null -eq $awsCommand) {
    Write-Host "   ⚠ AWS CLI not installed - skipping AWS validation" -ForegroundColor Yellow
} else {
    try {
        $validation = aws cloudformation validate-template --template-body file://$templatePath 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✓ AWS CloudFormation validation passed" -ForegroundColor Green
            
            # Parse and display template details
            $validationObj = $validation | ConvertFrom-Json
            Write-Host "`n   Template Details:" -ForegroundColor Cyan
            Write-Host "   - Parameters: $($validationObj.Parameters.Count)" -ForegroundColor Gray
            if ($validationObj.Parameters) {
                foreach ($param in $validationObj.Parameters) {
                    Write-Host "     • $($param.ParameterKey)" -ForegroundColor Gray
                }
            }
        } else {
            Write-Host "   ✗ AWS validation failed: $validation" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ✗ AWS validation error: $_" -ForegroundColor Red
    }
}

Write-Host "`n3. Checking for cfn-lint..." -ForegroundColor Yellow
$cfnLintCommand = Get-Command cfn-lint -ErrorAction SilentlyContinue
if ($null -eq $cfnLintCommand) {
    Write-Host "   ⚠ cfn-lint not installed" -ForegroundColor Yellow
    Write-Host "   Install with: pip install cfn-lint" -ForegroundColor Gray
} else {
    Write-Host "   Running cfn-lint validation..." -ForegroundColor Cyan
    $lintOutput = & cfn-lint $templatePath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ cfn-lint validation passed - no issues found!" -ForegroundColor Green
    } else {
        Write-Host "   ✗ cfn-lint found issues:" -ForegroundColor Red
        Write-Host $lintOutput -ForegroundColor Yellow
    }
}

Write-Host "`n4. Template Statistics:" -ForegroundColor Yellow
$content = Get-Content $templatePath -Raw
$resourceCount = ([regex]::Matches($content, '^\s{2}\w+:\s*$', 'Multiline')).Count
$conditionCount = ([regex]::Matches($content, 'Condition:')).Count

Write-Host "   - Resources: ~$resourceCount" -ForegroundColor Gray
Write-Host "   - Conditions: $conditionCount" -ForegroundColor Gray
Write-Host "   - File size: $([math]::Round((Get-Item $templatePath).Length / 1KB, 2)) KB" -ForegroundColor Gray

Write-Host "`n✅ Validation Complete!" -ForegroundColor Green
Write-Host "`nNote: This validates template syntax and structure." -ForegroundColor Cyan
Write-Host "For full validation, consider:" -ForegroundColor Cyan
Write-Host "- Using AWS CloudFormation Designer in the console" -ForegroundColor Gray
Write-Host "- Creating a stack with --disable-rollback for testing" -ForegroundColor Gray
Write-Host "- Using TaskCat for automated testing" -ForegroundColor Gray