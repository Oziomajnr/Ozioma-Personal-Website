# Local Testing for Deploy Action

## Option 1: Manual script (recommended for debugging)

Reproduce the build + deploy steps locally with verbose Firebase output:

```bash
# From repo root
./scripts/test-deploy-local.sh
```

**Auth:** Either:
- `firebase login` first, or
- `export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json`
- Or `export GCP_SA_KEY='{"type":"service_account",...}'` (JSON string)

The script runs Firebase with `--debug`; check `firebase-debug.log` for detailed logs if deploy is slow or times out.

---

## Option 2: Run full workflow with act

[act](https://github.com/nektos/act) runs GitHub Actions locally via Docker.

**Install:** `brew install act` (requires Docker)

**Run with secrets:**
```bash
# Create .secrets file (add to .gitignore) with:
# GCP_SA_KEY=<paste full JSON or base64-encoded key>

act push -s GCP_SA_KEY="$(cat /path/to/your-service-account.json)"
```

Or use a `.secrets` file:
```bash
echo 'GCP_SA_KEY={"type":"service_account",...}' > .secrets
act push --secret-file .secrets
```

**Run only the deploy job** (after build succeeds locally):
```bash
act push -j deploy-site --secret-file .secrets
```

---

## Why deploy might be slow

Your `firebase.json` has **two hosting targets** (website + blog), so each push deploys to both. That can double deploy time. The `--debug` flag will show where time is spent.
