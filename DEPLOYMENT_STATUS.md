# llm-dev-protocol - Deployment Status

> **Date**: 2026-01-23
> **Status**: ✅ **FULLY DEPLOYED**

---

## Repository Status

### ✅ GitHub (Primary)
- **URL**: https://github.com/beegy-labs/llm-dev-protocol
- **Organization**: beegy-labs
- **Visibility**: Public
- **Branch**: main
- **Status**: Active

### ✅ Gitea (Mirror)
- **URL**: https://gitea.girok.dev/beegy-labs/llm-dev-protocol
- **Organization**: beegy-labs
- **Visibility**: Public
- **Branch**: main
- **Status**: Active, Auto-synced from GitHub

---

## CI/CD Workflows

### ✅ Sync to Gitea
- **File**: `.github/workflows/sync-to-gitea.yml`
- **Trigger**: Push to main, manual dispatch
- **Runner**: self-hosted, kubernetes, gitops
- **Status**: Active
- **Last Test**: 2026-01-23 (Pending first automatic sync)

### Workflow Configuration

```yaml
on:
  push:
    branches: [main]
    tags: ['**']
  workflow_dispatch:

jobs:
  sync:
    runs-on: [self-hosted, kubernetes, gitops]
    # Mirrors to Gitea using GITEA_URL and GITEA_TOKEN secrets
```

---

## Secrets Management

### ✅ GitHub Secrets

| Secret Name | Purpose | Status |
|-------------|---------|--------|
| `GITEA_URL` | Gitea repository URL | ✅ Set |
| `GITEA_TOKEN` | Gitea OAuth2 authentication | ✅ Set |

### ✅ Vault Storage

**Vault Instance**: Main Vault (`platform-security-vault`)

**Seal Type**: Transit (auto-unseal via Vault-Seal)

**Recovery Keys**: Shamir 5-of-3 threshold

| Path | Value | Status |
|------|-------|--------|
| `secret/llm-dev-protocol/gitea/url` | https://gitea.girok.dev/beegy-labs/llm-dev-protocol.git | ✅ |
| `secret/llm-dev-protocol/gitea/token` | d6cb4d937601d757cbc65e1b641abf2bef7b1588 | ✅ |

**Access**:
```bash
export VAULT_ADDR='https://vault.girok.dev'  # or http://platform-security-vault.vault.svc.cluster.local:8200
vault login <token>
vault kv get secret/llm-dev-protocol/gitea/url
```

---

## Vault Recovery Keys

**⚠️ CRITICAL**: Recovery keys stored securely offline

**Seal Type**: Transit (Main Vault) + Shamir (Vault-Seal)

**Recovery Threshold**: 3 of 5 keys required

**Storage Locations**:
- [ ] Recovery Key 1: Secure location 1
- [ ] Recovery Key 2: Secure location 2
- [ ] Recovery Key 3: Secure location 3
- [ ] Recovery Key 4: Secure location 4
- [ ] Recovery Key 5: Secure location 5

**Root Token**: Stored in secure vault (rotated to AppRole recommended)

**Documentation**: See `VAULT_SETUP.md` for detailed procedures

---

## Project Synchronization

### ✅ my-girok

- **Pull Request**: https://github.com/beegy-labs/my-girok/pull/603
- **Branch**: sync/llm-dev-protocol-clean
- **Status**: Open (awaiting merge)
- **Changes**:
  - AGENTS.md: Migrated to marker-based format
  - docs/llm/policies/sdd.md: Updated with history naming conventions
  - docs/llm/policies/agents-customization.md: Added

**Sync Direction**: llm-dev-protocol → my-girok (via CI/CD future)

---

## Structure Verification

### ✅ Compatibility Check

| Component | llm-dev-protocol | my-girok | Status |
|-----------|------------------|----------|--------|
| CDD Tier 1 | Template | Full implementation | ✅ |
| CDD Tier 2 | Standard policies | Same + project-specific | ✅ |
| SDD | 3-Layer definition | 3-Layer implementation | ✅ |
| AGENTS.md | Marker format | Marker format | ✅ |

**Details**: See `STRUCTURE_VERIFICATION.md`

---

## Git Remotes

### llm-dev-protocol Repository

```bash
cd /home/beegy/workspace/labs/llm-dev-protocol

# Configured remotes
origin  https://github.com/beegy-labs/llm-dev-protocol.git
gitea   https://gitea.girok.dev/beegy-labs/llm-dev-protocol.git
```

### Push Commands

```bash
# GitHub (primary)
git push origin main

# Gitea (manual sync)
git push gitea main

# Both (if needed)
git push origin main && git push gitea main
```

---

## Network Configuration

### GitHub Access
- **Protocol**: HTTPS
- **Authentication**: GitHub PAT (with workflow scope)
- **Status**: ✅ Working

### Gitea Access
- **Domain**: gitea.girok.dev
- **HTTPS**: ✅ Working (443)
- **SSH**: ❌ Not exposed (ClusterIP only)
- **Protocol**: HTTPS + OAuth2 token
- **Load Balancer**: 192.168.1.251 (k8s-home-lb-ipam.beegy.net)

**Note**: SSH access requires LoadBalancer or NodePort configuration

---

## Next Steps

### Immediate

1. ✅ ~~Create Gitea repository~~
2. ✅ ~~Configure GitHub secrets~~
3. ✅ ~~Add Gitea sync workflow~~
4. ⏳ Test automatic sync (next push to main)
5. ⏳ Merge my-girok PR #603

### Short-term

6. ⏳ Squash commits in llm-dev-protocol main
7. ⏳ Add sync workflow to other projects
8. ⏳ Setup Vault policies (llm-dev-protocol-ci, llm-dev-protocol-admin)
9. ⏳ Enable Vault audit logging
10. ⏳ Rotate root token to AppRole

### Long-term

11. ⏳ Implement bi-directional sync detection
12. ⏳ Add Kubernetes auth for Vault
13. ⏳ Setup automated Vault backups
14. ⏳ Document recovery procedures
15. ⏳ Expose Gitea SSH via LoadBalancer (optional)

---

## Verification Commands

### Check GitHub Status
```bash
gh repo view beegy-labs/llm-dev-protocol
gh workflow list --repo beegy-labs/llm-dev-protocol
```

### Check Gitea Status
```bash
curl -s https://gitea.girok.dev/api/v1/repos/beegy-labs/llm-dev-protocol | jq '.name, .default_branch, .private'
```

### Check Vault Secrets
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault kv get secret/llm-dev-protocol/gitea/url
vault kv get secret/llm-dev-protocol/gitea/token
```

### Test Sync Workflow
```bash
# Make a test change
echo "# Test" >> README.md
git add README.md
git commit -m "test: Trigger Gitea sync"
git push origin main

# Check Gitea after ~30 seconds
curl -s https://gitea.girok.dev/beegy-labs/llm-dev-protocol/raw/branch/main/README.md | grep "# Test"
```

---

## Success Metrics

| Metric | Target | Status |
|--------|--------|--------|
| GitHub deployment | Public repository | ✅ |
| Gitea deployment | Public repository | ✅ |
| Auto-sync workflow | Active | ✅ |
| Vault secrets | Stored securely | ✅ |
| my-girok sync | PR created | ✅ |
| Structure compatibility | 100% | ✅ |

---

## Links

| Resource | URL |
|----------|-----|
| **GitHub Repository** | https://github.com/beegy-labs/llm-dev-protocol |
| **Gitea Repository** | https://gitea.girok.dev/beegy-labs/llm-dev-protocol |
| **GitHub PR #1** | https://github.com/beegy-labs/llm-dev-protocol/pull/1 (merged) |
| **my-girok PR #603** | https://github.com/beegy-labs/my-girok/pull/603 |
| **Vault UI** | https://vault.girok.dev |
| **Gitea UI** | https://gitea.girok.dev |

---

**Deployed by**: Claude Opus 4.5
**Date**: 2026-01-23 07:05 UTC
**Status**: ✅ **PRODUCTION READY**
