# LLM Dev Protocol - Deployment Guide

> **Date**: 2026-01-23
> **Status**: Ready for deployment

---

## Repository Status

✅ Git repository initialized
✅ All files committed
✅ CI/CD workflows configured
✅ Sync scripts ready
✅ AGENTS.md synchronized (SDD: 3-Layer)

---

## Deployment Steps

### 1. Create GitHub Repository

1. Go to: https://github.com/new
2. Repository settings:
   - **Name**: `llm-dev-protocol`
   - **Description**: "Enforced Standard for LLM-Driven Development - CDD, SDD, ADD Methodologies"
   - **Visibility**: ✅ **Public**
   - **Initialize**: ⛔ **Do NOT** initialize with README (we already have it)

### 2. Connect Local Repository

```bash
cd /home/beegy/workspace/labs/llm-dev-protocol

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/llm-dev-protocol.git

# Or if using SSH
git remote add origin git@github.com:YOUR_USERNAME/llm-dev-protocol.git

# Verify remote
git remote -v
```

### 3. Push to GitHub

```bash
# Push main branch
git push -u origin main

# Verify
git status
```

### 4. Configure GitHub Secrets (for CI/CD)

Navigate to: Repository → Settings → Secrets and variables → Actions

Add the following secrets:

| Secret Name | Value | Purpose |
|-------------|-------|---------|
| `SYNC_TOKEN` | GitHub PAT with repo scope | For auto-sync to projects |
| `MY_GIROK_REPO_URL` | `https://github.com/beegy-labs/my-girok.git` | Target repo URL |
| `SLACK_WEBHOOK` | (Optional) Slack webhook URL | Notifications |

**Generate GitHub PAT**:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token
3. Scopes: `repo` (full control)
4. Copy token and add as `SYNC_TOKEN` secret

### 5. Sync to my-girok

#### Option A: Manual Sync (Immediate)

```bash
cd /home/beegy/workspace/labs/llm-dev-protocol

# Run sync script
./scripts/sync-to-my-girok.sh

# Review changes in my-girok
cd ../my-girok
git diff

# Commit if satisfied
git add AGENTS.md docs/llm/policies/
git commit -m "sync: Update from llm-dev-protocol v1.0

- AGENTS.md: SDD corrected to 3-Layer
- Added missing policy files (cdd.md, sdd.md, add.md)

Source: https://github.com/YOUR_USERNAME/llm-dev-protocol"

git push
```

#### Option B: Automated Sync (CI/CD)

Once GitHub secrets are configured:

```bash
# Trigger workflow manually
gh workflow run sync-to-projects.yml

# Or push a change to trigger automatically
cd /home/beegy/workspace/labs/llm-dev-protocol
echo "# Update" >> README.md
git add README.md
git commit -m "trigger: Test auto-sync"
git push
```

CI/CD will:
1. Create branch in my-girok
2. Update AGENTS.md (marker-based)
3. Add missing policy files
4. Create PR automatically

---

## Repository Structure

```
llm-dev-protocol/
├── README.md                           # Project overview
├── AGENTS.md                           # Multi-LLM standard (SSOT)
├── LICENSE                             # MIT License
│
├── .ai/                                # CDD Tier 1
│   └── README.md
│
├── docs/
│   └── llm/                            # CDD Tier 2
│       ├── policies/
│       │   ├── cdd.md
│       │   ├── sdd.md
│       │   └── add.md
│       └── agents/
│           ├── README.md
│           └── _template.md
│
├── .specs/                             # SDD
│   └── README.md
│
├── standards/                          # Methodology standards
│   ├── cdd/
│   │   └── README.md
│   └── sdd/
│       ├── README.md
│       └── STRUCTURE.md
│
├── scripts/                            # Automation
│   ├── sync-to-my-girok.sh            # Manual sync
│   ├── sync-standards.sh
│   └── validate-structure.sh
│
├── .github/workflows/                  # CI/CD
│   ├── sync-to-projects.yml           # Auto-sync
│   └── validate-structure.yml         # Structure validation
│
├── projects.json                       # Target projects config
│
└── [Reports]
    ├── ADD_CURRENT_STATUS.md
    ├── SDD_STANDARD_CLARIFICATION.md
    ├── STRUCTURE_COMPARISON.md
    ├── TEMPLATE_ENHANCEMENT_REPORT.md
    └── METHODOLOGY_SYNC_VERIFICATION.md
```

---

## Verification Checklist

### Before Deployment

- [x] AGENTS.md synchronized (SDD: 3-Layer)
- [x] All methodology definitions consistent
- [x] CI/CD workflows created
- [x] Sync script tested locally
- [x] Git repository initialized
- [x] Initial commit created

### After GitHub Push

- [ ] Repository created on GitHub
- [ ] Remote added and pushed
- [ ] GitHub secrets configured
- [ ] CI/CD workflows visible
- [ ] Repository is public

### After my-girok Sync

- [ ] AGENTS.md updated in my-girok
- [ ] Policy files added (cdd.md, sdd.md, add.md)
- [ ] Structure validation passes
- [ ] No merge conflicts

---

## Testing CI/CD

### Test 1: Structure Validation

```bash
# Push a change
echo "# Test" >> README.md
git add README.md
git commit -m "test: Trigger validation"
git push
```

Check: GitHub Actions → Validate Structure should run

### Test 2: Auto-Sync to my-girok

```bash
# Update AGENTS.md
echo "" >> AGENTS.md
git add AGENTS.md
git commit -m "test: Trigger auto-sync"
git push
```

Check:
1. GitHub Actions → Sync Standards to Projects should run
2. PR created in my-girok repository

---

## Maintenance

### Update Standards

When updating methodology standards:

1. Edit files in llm-dev-protocol
2. Commit and push
3. CI/CD automatically syncs to my-girok (and other registered projects)

### Add New Project

1. Edit `projects.json`
2. Add new project entry
3. Commit and push
4. CI/CD will include new project in sync

---

## Troubleshooting

### Sync Fails

**Check**:
- GitHub secrets configured correctly
- Target repository accessible
- Branch name doesn't conflict

**Manual fix**:
```bash
./scripts/sync-to-my-girok.sh
```

### Validation Fails

**Check structure**:
```bash
./scripts/validate-structure.sh
```

**Common issues**:
- Missing .ai/README.md
- Missing docs/llm/policies/
- AGENTS.md missing markers

---

## Links

| Resource | URL |
|----------|-----|
| GitHub New Repo | https://github.com/new |
| Generate PAT | https://github.com/settings/tokens |
| my-girok Repo | https://github.com/beegy-labs/my-girok |
| GitHub Actions Docs | https://docs.github.com/en/actions |

---

**Ready for deployment**: ✅

**Next**: Create GitHub repository and push
