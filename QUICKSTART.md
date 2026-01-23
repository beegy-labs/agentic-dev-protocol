# Quick Start Guide

> Get started with llm-dev-protocol in 5 minutes

## For New Projects

### 1. Initialize Project Structure

```bash
# From your project root
PROJECT_ROOT=/path/to/your/project
LDP_ROOT=/path/to/llm-dev-protocol

# Copy base structure
cp -r $LDP_ROOT/.ai $PROJECT_ROOT/
cp -r $LDP_ROOT/docs $PROJECT_ROOT/
cp -r $LDP_ROOT/.specs $PROJECT_ROOT/

# Copy AGENTS.md with markers
cp $LDP_ROOT/AGENTS.md $PROJECT_ROOT/

# Copy agent templates
cp $LDP_ROOT/CLAUDE.md.template $PROJECT_ROOT/CLAUDE.md
cp $LDP_ROOT/GEMINI.md.template $PROJECT_ROOT/GEMINI.md
```

### 2. Customize AGENTS.md

Edit the **PROJECT CUSTOM** section in `AGENTS.md`:

```markdown
<!-- BEGIN: PROJECT CUSTOM -->

## Project-Specific Configuration

### Architecture & Stack

| Layer    | Tech              | Version |
| -------- | ----------------- | ------- |
| Frontend | React             | 19.2    |
| Backend  | NestJS            | 11.1    |
| Database | PostgreSQL        | 16      |

### Project-Specific Rules

| Rule           | Description                   |
| -------------- | ----------------------------- |
| Test Coverage  | 80% minimum                   |
| Types First    | Define in packages/types      |

<!-- END: PROJECT CUSTOM -->
```

### 3. Register Project

Add your project to `llm-dev-protocol/projects.json`:

```json
{
  "name": "your-project",
  "path": "../your-project",
  "enabled": true,
  "sync": {
    "AGENTS.md": true,
    "docs/llm/policies/development-methodology.md": true,
    "docs/llm/policies/cdd.md": true,
    "docs/llm/policies/sdd.md": true,
    "docs/llm/policies/add.md": true
  }
}
```

### 4. Test Sync

```bash
cd llm-dev-protocol

# Dry run to preview
./scripts/sync-standards.sh --dry-run

# Actual sync
./scripts/sync-standards.sh
```

---

## For Existing Projects

### 1. Backup

```bash
cd /path/to/your/project

# Backup existing AGENTS.md if it exists
cp AGENTS.md AGENTS.md.backup 2>/dev/null || true
```

### 2. Migrate AGENTS.md

```bash
cd /path/to/llm-dev-protocol

# Dry run to preview migration
./scripts/migrate-agents-md.sh /path/to/your/project --dry-run

# Actual migration
./scripts/migrate-agents-md.sh /path/to/your/project
```

This will:
- Detect project-specific content
- Add standard policy markers
- Add custom section markers
- Preserve your existing content

### 3. Review & Edit

Open `AGENTS.md` and review the **PROJECT CUSTOM** section:

```bash
# Review the migrated file
cat /path/to/your/project/AGENTS.md

# Edit custom section
vim /path/to/your/project/AGENTS.md
# (Edit only between PROJECT CUSTOM markers)
```

### 4. Validate

```bash
cd llm-dev-protocol

# Validate structure
./scripts/validate-structure.sh /path/to/your/project
```

---

## Daily Workflow

### When llm-dev-protocol Updates

```bash
cd llm-dev-protocol

# Pull latest standards
git pull origin main

# Sync to all projects
./scripts/sync-standards.sh

# Or sync to specific project
./scripts/sync-agents-md.sh \
  AGENTS.md \
  /path/to/project/AGENTS.md
```

### When Your Project Needs Custom Rules

1. **Edit PROJECT CUSTOM section** in `AGENTS.md`:

```markdown
<!-- BEGIN: PROJECT CUSTOM -->

## Project-Specific Configuration

### New Compliance Requirement

| Regulation | Applies To | Requirement          |
| ---------- | ---------- | -------------------- |
| GDPR       | User data  | Right to be forgotten|
| CCPA       | California | Data export          |

<!-- END: PROJECT CUSTOM -->
```

2. **Commit**:

```bash
git add AGENTS.md
git commit -m "docs: add GDPR/CCPA compliance requirements"
```

3. **Sync remains safe**: Next `sync-standards.sh` will preserve your custom section

---

## Example Scenarios

### Scenario 1: Multi-Project Organization

You have 5 projects: `project-a`, `project-b`, `project-c`, `project-d`, `project-e`

```bash
# Setup (once)
cd llm-dev-protocol
# Add all 5 projects to projects.json

# Daily: Update standards and sync all
git pull origin main
./scripts/sync-standards.sh

# Result: All 5 projects get updated standards
# But each keeps their custom sections intact
```

### Scenario 2: New Team Member

New developer joins, needs to understand all projects:

```bash
# 1. Clone llm-dev-protocol
git clone https://github.com/yourorg/llm-dev-protocol.git

# 2. Read methodology
cat docs/llm/policies/development-methodology.md

# 3. Check each project's AGENTS.md
for project in project-a project-b project-c; do
  echo "=== $project ==="
  cat ../$project/AGENTS.md | grep -A 50 "BEGIN: PROJECT CUSTOM"
done

# Now understands: standard methodology + each project's specifics
```

### Scenario 3: Compliance Audit

Need to verify all projects follow security standards:

```bash
cd llm-dev-protocol

# Validate all projects
jq -r '.projects[] | select(.enabled == true) | .path' projects.json | \
while read path; do
  echo "Validating: $path"
  ./scripts/validate-structure.sh "$path"
done

# Check for compliance keywords in custom sections
grep -r "HIPAA\|GDPR\|PCI-DSS" ../*/AGENTS.md
```

---

## Troubleshooting

### Problem: Sync overwrites my custom content

**Cause**: Missing or malformed markers

**Solution**:
```bash
# Re-run migration
./scripts/migrate-agents-md.sh /path/to/project --force

# Or manually add markers
vim /path/to/project/AGENTS.md
# Add <!-- BEGIN: PROJECT CUSTOM --> and <!-- END: PROJECT CUSTOM -->
```

### Problem: Validation fails with line limit errors

**Cause**: Custom section too large (>200 lines)

**Solution**:
```markdown
<!-- BEGIN: PROJECT CUSTOM -->

## Project-Specific Configuration

| Topic    | Full Documentation                    |
| -------- | ------------------------------------- |
| Tech Stack | `docs/llm/architecture.md`          |
| Security   | `docs/llm/policies/security.md`     |
| Compliance | `docs/llm/policies/compliance.md`   |

**See linked docs for details**

<!-- END: PROJECT CUSTOM -->
```

### Problem: Merge conflicts in AGENTS.md

**Cause**: Editing standard section or concurrent updates

**Solution**:
```bash
# Accept upstream standard section
git checkout --theirs AGENTS.md

# Re-run sync to merge properly
cd /path/to/llm-dev-protocol
./scripts/sync-agents-md.sh AGENTS.md /path/to/project/AGENTS.md
```

---

## Best Practices

| Practice | Description |
| -------- | ----------- |
| **Sync Weekly** | Run `sync-standards.sh` weekly to stay updated |
| **Review PRs** | Check AGENTS.md changes in PRs carefully |
| **Keep Custom Small** | Use tables, link to detailed docs |
| **Document Why** | Explain why custom rules exist |
| **Validate Often** | Run validation before committing |

---

## Next Steps

- **Read**: [docs/llm/policies/agents-customization.md](docs/llm/policies/agents-customization.md)
- **Explore**: [docs/llm/policies/development-methodology.md](docs/llm/policies/development-methodology.md)
- **Customize**: Edit PROJECT CUSTOM section for your project
- **Automate**: Set up CI/CD for automatic sync

---

**Questions?** See [docs/llm/policies/agents-customization.md](docs/llm/policies/agents-customization.md) for detailed guide.
