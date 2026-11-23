#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# Install missing tools on macOS using Homebrew.
if ! command -v brew >/dev/null; then
  if ! command -v npm >/dev/null || ! command -v gh >/dev/null; then
    echo 'Install Homebrew from https://brew.sh and run this script again.'
    exit 1
  fi
fi
if ! command -v npm >/dev/null; then brew install node@20; export PATH="$(brew --prefix node@20)/bin:$PATH"; fi
if ! command -v gh >/dev/null; then brew install gh; fi

# Creates package-lock.json, required by npm ci and the Dockerfile.
npm install
npm run lint
npm test

if ! gh auth status >/dev/null 2>&1; then gh auth login; fi
if [ ! -d .git ]; then git init -b main; fi
git add .
if ! git diff --cached --quiet; then git commit -m "Add KT3 app and CI/CD pipeline"; fi
git branch develop 2>/dev/null || git show-ref --verify refs/heads/develop
if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create devops-kt3 --public --source=. --remote=origin
fi
git push -u origin main
git push -u origin develop

# Require both CI checks before merging into main.
gh api --method PUT repos/{owner}/{repo}/branches/main/protection --input - <<'JSON'
{
  "required_status_checks": { "strict": true, "contexts": ["lint", "test"] },
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null
}
JSON
gh repo view --web
