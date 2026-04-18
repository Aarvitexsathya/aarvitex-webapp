#!/bin/bash
# scripts/ai-code-review.sh
# Usage: ./ai-code-review.sh <changed-files>
set -e

echo '========================================='
echo 'AI CODE REVIEW  (Amazon Bedrock / Claude)'
echo '========================================='

# Get the git diff of changed Java files
GIT_DIFF=$(git diff HEAD~1 HEAD -- '*.java' 2>/dev/null || echo 'Initial commit')

if [ -z "$GIT_DIFF" ]; then
    echo 'No Java file changes detected. Skipping AI review.'
    exit 0
fi

# Truncate diff to avoid exceeding token limits
GIT_DIFF_TRUNCATED=$(echo "$GIT_DIFF" | head -200)

# Call Bedrock Claude
python3 << PYEOF
import boto3, json, sys

diff = '''${GIT_DIFF_TRUNCATED}'''

prompt = f"""You are a senior DevOps engineer reviewing a Java web application.
Review the following git diff and provide:
1. A summary of what changed (2-3 sentences)
2. Any code quality issues or bugs (list format)
3. Security concerns if any
4. Overall assessment: PASS, WARN, or FAIL

Git diff:
{diff}

Keep the review concise and actionable. Format clearly."""

client = boto3.client('bedrock-runtime', region_name='us-east-1')
response = client.invoke_model(
    modelId='us.anthropic.claude-haiku-4-5-20251001-v1:0',
    body=json.dumps({
        'anthropic_version': 'bedrock-2023-05-31',
        'max_tokens': 1000,
        'messages': [{'role': 'user', 'content': prompt}]
    })
)
result = json.loads(response['body'].read())
review = result['content'][0]['text']
print(review)

# Fail the build if AI says FAIL
if 'FAIL' in review.upper() and 'OVERALL ASSESSMENT: FAIL' in review.upper():
    print('\nAI CODE REVIEW: FAILED - Critical issues found')
    sys.exit(1)
else:
    print('\nAI CODE REVIEW: PASSED')
PYEOF
