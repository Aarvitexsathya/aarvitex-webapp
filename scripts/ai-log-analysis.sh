#!/bin/bash
# scripts/ai-log-analysis.sh
# Called in the post { failure { } } block of Jenkinsfile

echo '================================================'
echo 'AI LOG ANALYSIS  (Amazon Bedrock / Claude Haiku)'
echo '================================================'

# Read the last 100 lines of build log
BUILD_LOG=$(cat ${WORKSPACE}/build.log 2>/dev/null | tail -100 || echo 'No log found')

python3 << PYEOF
import boto3, json

log = '''${BUILD_LOG}'''

prompt = f"""A Jenkins CI/CD pipeline has failed. Analyze this build log
and provide:
1. ROOT CAUSE: One sentence explaining why it failed
2. FAILED STAGE: Which pipeline stage failed
3. FIX: Exact steps to fix the issue
4. PREVENTION: How to prevent this in the future

Build log (last 100 lines):
{log}"""

client = boto3.client('bedrock-runtime', region_name='us-east-1')
response = client.invoke_model(
    modelId='us.anthropic.claude-haiku-4-5-20251001-v1:0',
    body=json.dumps({
        'anthropic_version': 'bedrock-2023-05-31',
        'max_tokens': 800,
        'messages': [{'role': 'user', 'content': prompt}]
    })
)
result = json.loads(response['body'].read())
print(result['content'][0]['text'])
PYEOF
