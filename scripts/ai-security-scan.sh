#!/bin/bash
# scripts/ai-security-scan.sh
set -e

echo '============================================='
echo 'AI SECURITY SCAN  (Amazon Bedrock / Claude)'
echo '============================================='

# Read the files to scan
DOCKERFILE=$(cat Dockerfile 2>/dev/null || echo 'No Dockerfile found')
K8S_DEPLOYMENT=$(cat k8s/deployment.yaml 2>/dev/null || echo 'No deployment.yaml found')

python3 << PYEOF
import boto3, json, sys

dockerfile = '''${DOCKERFILE}'''
k8s_yaml   = '''${K8S_DEPLOYMENT}'''

prompt = f"""You are a DevSecOps engineer. Scan these files for security issues.

DOCKERFILE:
{dockerfile}

KUBERNETES DEPLOYMENT YAML:
{k8s_yaml}

Check for:
- Running as root (missing USER instruction in Dockerfile)
- Using :latest image tag (unpredictable deployments)
- Missing resource limits (CPU/memory)
- Hardcoded secrets or passwords
- Missing readiness/liveness probes
- Privileged containers
- Missing security context

For each issue found, give: SEVERITY (CRITICAL/HIGH/MEDIUM/LOW), DESCRIPTION, FIX.
End with: SECURITY ASSESSMENT: PASS / WARN / FAIL"""

client = boto3.client('bedrock-runtime', region_name='us-east-1')
response = client.invoke_model(
    modelId='us.anthropic.claude-haiku-4-5-20251001-v1:0',
    body=json.dumps({
        'anthropic_version': 'bedrock-2023-05-31',
        'max_tokens': 1500,
        'messages': [{'role': 'user', 'content': prompt}]
    })
)
result = json.loads(response['body'].read())
scan_result = result['content'][0]['text']
print(scan_result)

# Save to file for Jenkins to archive
with open('ai-security-report.txt', 'w') as f:
    f.write(scan_result)

if 'SECURITY ASSESSMENT: FAIL' in scan_result.upper():
    print('\nAI SECURITY SCAN: FAILED - Critical security issues found')
    sys.exit(1)
else:
    print('\nAI SECURITY SCAN: PASSED')
PYEOF
