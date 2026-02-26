# Installing My Vibe Scaffolding

This scaffolding provides a comprehensive project template with AI agent support, i18n, version management, and best practices.

## Installation Options

Choose the appropriate method based on your needs:

### Option 1: New Project (Recommended)

**Use this when starting a brand new project.**

1. **Use GitHub Template**:
   - Visit https://github.com/matheme-justyn/my-vibe-scaffolding
   - Click "Use this template" → "Create a new repository"
   - Clone your new repository

2. **Initialize Project**:
   ```bash
   cd your-project-name
   ./.template/scripts/init-project.sh
   ```

3. **Install Git Hooks** (version enforcement):
   ```bash
   ./.template/scripts/install-hooks.sh
   ```

4. **Done!** Start building your project.

---

### Option 2: Integrate into Existing Project

**Use this when you want to add scaffolding features to an existing project.**

⚠️ **Warning**: This will add/overwrite files. Commit your work first!

1. **Add as Remote**:
   ```bash
   git remote add scaffolding https://github.com/matheme-justyn/my-vibe-scaffolding.git
   git fetch scaffolding
   ```

2. **Merge Scaffolding** (interactive):
   ```bash
   # Create a branch for the merge
   git checkout -b integrate-scaffolding
   
   # Merge (will have conflicts, that's expected)
   git merge scaffolding/main --allow-unrelated-histories
   ```

3. **Resolve Conflicts**:
   - Keep your existing `README.md`, `LICENSE`, `CONTRIBUTING.md` (your project's)
   - Keep scaffolding's `.template/` directory (new infrastructure)
   - Keep scaffolding's `AGENTS.md` if you don't have one, or merge
   - Keep scaffolding's `config.toml.example` as reference

4. **Configure for Your Project**:
   ```bash
   # Set mode to project (not scaffolding)
   cp config.toml.example config.toml
   # Edit config.toml: set mode = "project"
   
   # Install hooks
   ./.template/scripts/install-hooks.sh
   ```

5. **Commit and Continue**:
   ```bash
   git add -A
   git commit -m "chore: integrate my-vibe-scaffolding template"
   git checkout main
   git merge integrate-scaffolding
   ```

---

### Option 3: Cherry-Pick Features

**Use this when you only want specific features.**

Pick what you need:

#### A. Version Management + Git Hooks
```bash
# Download hook
curl -o .git/hooks/pre-push https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.template/hooks/pre-push
chmod +x .git/hooks/pre-push

# Create VERSION file
echo "1.0.0" > VERSION
git add VERSION
```

#### B. AI Agent Configuration (AGENTS.md)
```bash
curl -o AGENTS.md https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/AGENTS.md
# Edit AGENTS.md for your project
```

#### C. i18n System
```bash
# Download i18n structure
mkdir -p i18n/locales/en-US i18n/locales/zh-TW
curl -o config.toml.example https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/config.toml.example

# Download locale files
curl -o i18n/locales/zh-TW/agents.toml https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.template/i18n/locales/zh-TW/agents.toml
# ... etc
```

#### D. Documentation Structure
```bash
# Create docs structure
mkdir -p docs/adr

# Download ADR template
curl -o docs/adr/0001-record-architecture-decisions.md https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.template/docs/adr/0001-record-architecture-decisions.md
```

---

## Configuration

After installation, configure for your needs:

### 1. Set Working Mode

Edit `config.toml`:
```toml
[project]
mode = "project"  # "scaffolding" if you're developing the template itself
```

### 2. Set Language

Edit `config.toml`:
```toml
[i18n]
primary_locale = "zh-TW"  # or "en-US", "ja-JP", etc.
fallback_locale = "en-US"
```

### 3. Update Project Info

Edit `README.md`, `AGENTS.md` with your project details.

### 4. Choose License

See `.template/docs/PROJECT_LICENSE_GUIDE.md` for guidance.

---

## What You Get

- **AI Agent Configuration**: `AGENTS.md` with coding conventions, commit format
- **Version Management**: Automatic version checking on git push
- **i18n Support**: Multi-language documentation (BCP 47)
- **Project Guides**: LICENSE, CONTRIBUTING, SECURITY setup guides
- **Documentation Structure**: ADR templates, organization guidelines
- **Working Modes**: Scaffolding vs Project mode separation

---

## Updating

To sync with latest scaffolding updates:

```bash
git remote add scaffolding https://github.com/matheme-justyn/my-vibe-scaffolding.git
git fetch scaffolding
git merge scaffolding/main
```

Or see detailed sync guide: `.template/docs/TEMPLATE_SYNC.md`

---

## Troubleshooting

### "VERSION NOT UPDATED" error when pushing

This is the version enforcement hook working correctly!

Fix:
```bash
./.template/scripts/bump-version.sh patch  # or minor/major
git push && git push --tags
```

### Conflicts during merge

This is normal when integrating into existing projects. Resolve carefully:
- Keep your project's identity files (README, LICENSE)
- Keep scaffolding's `.template/` infrastructure
- Merge AGENTS.md if you have one

### Language not switching

1. Check `config.toml` exists (copy from `.example`)
2. Verify locale directory: `i18n/locales/{your-lang}/`
3. Ensure OpenCode reads `AGENTS.md` (it should by default)

---

## Support

- Issues: https://github.com/matheme-justyn/my-vibe-scaffolding/issues
- Documentation: See `.template/docs/` directory
- Changelog: `CHANGELOG.md`

---

## Learn More

- [README Guide](./.template/docs/README_GUIDE.md) - How to write project README
- [Documentation Guidelines](./.template/docs/DOCUMENTATION_GUIDELINES.md) - File organization
- [License Guide](./.template/docs/PROJECT_LICENSE_GUIDE.md) - Choosing a license
- [Contributing Guide](./.template/docs/PROJECT_CONTRIBUTING_GUIDE.md) - Setting contribution policy
- [Security Guide](./.template/docs/PROJECT_SECURITY_GUIDE.md) - Creating security policy
