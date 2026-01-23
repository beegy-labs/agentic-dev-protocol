# Vault Setup - llm-dev-protocol

> **Created**: 2026-01-23
> **Purpose**: Secure credential management for llm-dev-protocol infrastructure

---

## Overview

This document describes the Vault setup for managing secrets used by llm-dev-protocol, including:

- GitHub Actions secrets
- Gitea synchronization credentials
- CI/CD tokens
- Project-specific credentials

---

## Vault Architecture

### Main Vault

**Purpose**: Primary secrets storage for llm-dev-protocol and related projects

**Unsealing Method**: Shamir's Secret Sharing (5 keys, threshold 3)

**Access**: Root token + Recovery keys

### Vault-Seal

**Purpose**: Auto-unseal for Main Vault (transit encryption)

**Configuration**: Transit engine for unsealing Main Vault automatically

---

## Recovery Keys Storage

### ⚠️ CRITICAL: Recovery Keys Management

Recovery keys MUST be stored securely and separately:

1. **Physical Storage** (Recommended)
   - Print recovery keys
   - Store in separate secure locations (safe deposit boxes, etc.)
   - Minimum 3 different physical locations

2. **Digital Storage** (Encrypted)
   - Use password manager (1Password, Bitwarden, etc.)
   - Encrypt with strong passphrase
   - Store encrypted file in separate secure storage

3. **Team Distribution**
   - Distribute keys across trusted team members
   - Each person holds 1-2 keys
   - Require 3 keys minimum to unseal

### Recovery Key Rotation

- **Frequency**: Every 90 days or after personnel changes
- **Process**: `vault operator rekey`
- **Documentation**: Update this file after rotation

---

## Vault Secrets Structure

### Path: `secret/llm-dev-protocol/`

```
secret/llm-dev-protocol/
├── github/
│   ├── sync_token          # GitHub PAT for CI/CD
│   └── webhook_secret      # Webhook validation
├── gitea/
│   ├── url                 # https://gitea.girok.dev/beegy-labs/llm-dev-protocol.git
│   ├── token               # Gitea OAuth2 token
│   └── webhook_secret      # Gitea webhook secret
└── projects/
    ├── my-girok/
    │   ├── repo_url
    │   └── sync_token
    └── {project}/
        ├── repo_url
        └── sync_token
```

---

## GitHub Actions Integration

### Required Secrets

| Secret Name | Source | Purpose |
|-------------|--------|---------|
| `GITEA_URL` | Vault: `secret/llm-dev-protocol/gitea/url` | Gitea repository URL |
| `GITEA_TOKEN` | Vault: `secret/llm-dev-protocol/gitea/token` | Gitea authentication |
| `SYNC_TOKEN` | Vault: `secret/llm-dev-protocol/github/sync_token` | GitHub API access |

### Secret Injection Methods

#### Option 1: Manual (Current)
```bash
# Read from Vault
vault kv get -field=url secret/llm-dev-protocol/gitea/url

# Set in GitHub
gh secret set GITEA_URL --repo beegy-labs/llm-dev-protocol
```

#### Option 2: Vault GitHub Actions (Future)
```yaml
- uses: hashicorp/vault-action@v2
  with:
    url: https://vault.girok.dev
    method: kubernetes
    role: llm-dev-protocol
    secrets: |
      secret/llm-dev-protocol/gitea/url | GITEA_URL ;
      secret/llm-dev-protocol/gitea/token | GITEA_TOKEN
```

---

## Initial Setup Commands

### 1. Store Gitea Credentials

```bash
# Set Vault address
export VAULT_ADDR='https://vault.girok.dev'

# Login with root token (first time only)
# NOTE: Replace with actual root token from secure storage
vault login hvs.XXXXXXXXXXXXXXXXXXXXXXXX

# Create Gitea secrets
vault kv put secret/llm-dev-protocol/gitea/url \
  value="https://gitea.girok.dev/beegy-labs/llm-dev-protocol.git"

vault kv put secret/llm-dev-protocol/gitea/token \
  value="d6cb4d937601d757cbc65e1b641abf2bef7b1588"

vault kv put secret/llm-dev-protocol/gitea/webhook_secret \
  value="$(openssl rand -hex 32)"
```

### 2. Store GitHub Credentials

```bash
# Generate GitHub PAT with repo + workflow scopes
# Then store:
vault kv put secret/llm-dev-protocol/github/sync_token \
  value="ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

vault kv put secret/llm-dev-protocol/github/webhook_secret \
  value="$(openssl rand -hex 32)"
```

### 3. Create GitHub Secrets from Vault

```bash
# Read from Vault and set in GitHub
GITEA_URL=$(vault kv get -field=value secret/llm-dev-protocol/gitea/url)
GITEA_TOKEN=$(vault kv get -field=value secret/llm-dev-protocol/gitea/token)

gh secret set GITEA_URL --body "$GITEA_URL" --repo beegy-labs/llm-dev-protocol
gh secret set GITEA_TOKEN --body "$GITEA_TOKEN" --repo beegy-labs/llm-dev-protocol
```

---

## Access Control

### Vault Policies

#### llm-dev-protocol-ci (for GitHub Actions)

```hcl
# Read-only access to llm-dev-protocol secrets
path "secret/data/llm-dev-protocol/*" {
  capabilities = ["read", "list"]
}
```

#### llm-dev-protocol-admin (for administrators)

```hcl
# Full access to llm-dev-protocol secrets
path "secret/data/llm-dev-protocol/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/llm-dev-protocol/*" {
  capabilities = ["list", "read", "delete"]
}
```

### Create Policies

```bash
vault policy write llm-dev-protocol-ci /path/to/llm-dev-protocol-ci.hcl
vault policy write llm-dev-protocol-admin /path/to/llm-dev-protocol-admin.hcl
```

---

## Kubernetes Service Account (Future)

For self-hosted GitHub Actions runner in Kubernetes:

```bash
# Enable Kubernetes auth
vault auth enable kubernetes

# Configure Kubernetes auth
vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc:443"

# Create role for GitHub Actions runner
vault write auth/kubernetes/role/llm-dev-protocol \
  bound_service_account_names=github-actions-runner \
  bound_service_account_namespaces=ci \
  policies=llm-dev-protocol-ci \
  ttl=1h
```

---

## Monitoring & Audit

### Enable Audit Logging

```bash
vault audit enable file file_path=/vault/logs/audit.log
```

### Monitor Secret Access

```bash
# View recent secret access
vault audit list

# Check who accessed secrets
cat /vault/logs/audit.log | jq 'select(.request.path | contains("llm-dev-protocol"))'
```

---

## Disaster Recovery

### Backup Vault Data

```bash
# Snapshot Vault data
vault operator raft snapshot save backup.snap

# Store snapshot securely
aws s3 cp backup.snap s3://vault-backups/llm-dev-protocol/$(date +%Y%m%d).snap
```

### Restore Process

1. Unseal Vault with recovery keys (3 of 5 required)
2. Login with root token
3. Restore from snapshot if needed:
   ```bash
   vault operator raft snapshot restore backup.snap
   ```

---

## Security Best Practices

### ✅ DO

- Rotate recovery keys every 90 days
- Use time-limited tokens (TTL)
- Enable MFA for root token access
- Audit log reviews weekly
- Backup snapshots daily
- Store recovery keys separately

### ❌ DON'T

- Store recovery keys in plain text
- Commit root token to Git
- Share recovery keys via email/chat
- Use root token for daily operations
- Disable audit logging
- Store all keys in one location

---

## Troubleshooting

### Vault Sealed

```bash
# Check seal status
vault status

# Unseal (requires 3 of 5 keys)
vault operator unseal [KEY1]
vault operator unseal [KEY2]
vault operator unseal [KEY3]
```

### Lost Root Token

```bash
# Generate new root token using recovery keys
vault operator generate-root -init
vault operator generate-root -decode=[ENCODED_TOKEN] -otp=[OTP]
```

### Revoke Compromised Token

```bash
vault token revoke [TOKEN]
vault token revoke -mode=orphan [TOKEN]  # Don't revoke child tokens
```

---

## Next Steps

1. ✅ Store recovery keys securely (5 separate locations)
2. ⏳ Create Vault policies (llm-dev-protocol-ci, llm-dev-protocol-admin)
3. ⏳ Store Gitea credentials in Vault
4. ⏳ Store GitHub credentials in Vault
5. ⏳ Inject secrets to GitHub Actions
6. ⏳ Enable audit logging
7. ⏳ Setup automated backups
8. ⏳ Document recovery procedures
9. ⏳ Rotate root token (use AppRole instead)
10. ⏳ Setup Kubernetes auth for self-hosted runner

---

## References

| Resource | URL |
|----------|-----|
| Vault Documentation | https://developer.hashicorp.com/vault/docs |
| Shamir's Secret Sharing | https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing |
| Vault GitHub Actions | https://github.com/hashicorp/vault-action |
| Recovery Keys Best Practices | https://developer.hashicorp.com/vault/docs/concepts/seal |

---

**⚠️ WARNING**: This file contains references to sensitive operations. Do NOT commit actual recovery keys or root token to version control.

**Status**: Initial setup - Recovery keys stored securely offline
