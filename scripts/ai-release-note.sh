#!/bin/bash
# scripts/ai-release-notes.sh

echo '================================================='
echo 'AI RELEASE NOTES  (Amazon Bedrock / Claude Haiku)'
echo '================================================='

# Get git commits since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo 'HEAD~10')
GIT_LOG=$(git log ${LAST_TAG}..HEAD --oneline --no-merges 2>/dev/null | head -30)
BUILD_NUM=${BUILD_NUMBER:-1}
APP_VERSION=${VERSION:-1.0}

python3 << PYEOF
import boto3, json

git_log = '''${GIT_LOG}'''
build   = '${BUILD_NUM}'
version = '${APP_VERSION}'

prompt = f"""Generate professional release notes for a Java web application.

Build: #{build}
Version: {version}
Git commits:
{git_log}

Format the release notes as:
## Release v{version} - Build #{build}
**Release Date:** [today]

### What's New
- [feature list]

### Bug Fixes
- [bug fixes]

### Technical Changes
- [technical changes]

Keep it professional and concise. Infer categories from commit messages."""

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
notes  = result['content'][0]['text']
print(notes)

# Save for Jenkins to archive and include in email
with open('RELEASE_NOTES.md', 'w') as f:
    f.write(notes)
print('\nRelease notes saved to RELEASE_NOTES.md')
PYEOF
