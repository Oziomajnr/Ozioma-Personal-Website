#!/usr/bin/env bash
# Local test script to reproduce the deploy action and debug Firebase deploy slowness.
# Run from repo root. Requires: Ruby, Bundler, Firebase CLI, GCP_SA_KEY or firebase login.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

echo "==> 1. Building Jekyll blog..."
cd blog
bundle install --quiet
JEKYLL_ENV=production bundle exec jekyll build --verbose
cd ..

echo ""
echo "==> 2. Verifying build artifacts..."
ls -la blog/_site/ || (echo "ERROR: blog/_site not found" && exit 1)
ls -la index.html || (echo "ERROR: index.html not found" && exit 1)

echo ""
echo "==> 3. Firebase deploy with --debug (verbose logs)..."
echo "    Set GOOGLE_APPLICATION_CREDENTIALS or GCP_SA_KEY for auth."
echo "    Debug log will be saved to firebase-debug.log"
echo ""

# Use --debug for verbose output; logs also written to firebase-debug.log
# Uses npx so firebase-tools need not be installed globally
export NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=4096}"
npx --yes firebase-tools deploy --only hosting --non-interactive --force --debug

echo ""
echo "==> Done. Check firebase-debug.log for detailed logs if deploy was slow or failed."
