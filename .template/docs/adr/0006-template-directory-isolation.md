# Template File Isolation Strategy

## Problem

When creating a project from this template, certain directories contain **template infrastructure** that should be preserved across updates, but **not mixed** with project-specific content:

```
docs/              ← Template docs + Your project docs (CONFLICT!)
scripts/           ← Template tools + Your project scripts (CONFLICT!)
i18n/              ← Template i18n system
languages/         ← Template language modules
```

**Result**: Template updates overwrite your project files.

---

## Solution: .template/ Directory Isolation

Move template infrastructure to `.template/` directory. Keep project directories clean.

### New Structure

```
project-root/
├── .template/              # Template infrastructure (preserved across updates)
│   ├── VERSION
│   ├── docs/               # Template documentation
│   │   ├── DOCUMENTATION_GUIDELINES.md
│   │   ├── README_GUIDE.md
│   │   └── adr/            # Example ADRs (0002-0004)
│   ├── scripts/            # Template tools
│   │   ├── init-project.sh
│   │   ├── bump-version.sh
│   │   └── lib-config.sh
│   ├── i18n/               # i18n system
│   └── languages/          # Language modules
│
├── docs/                   # YOUR project docs (never overwritten)
│   └── adr/
│       └── 0001-*.md       # Your ADRs
├── scripts/                # YOUR project scripts
│   └── deploy.sh
├── AGENTS.md               # Hybrid: Template base + Your customizations
├── README.md               # YOUR project README
└── .template-version       # Track template version
```

---

## Migration Plan

### Phase 1: Structural Reorganization

1. **Create `.template/` directory**
   ```bash
   mkdir -p .template/{docs,scripts}
   ```

2. **Move template infrastructure**
   ```bash
   # Template docs (not project-specific)
   mv docs/DOCUMENTATION_GUIDELINES.md .template/docs/
   mv docs/README_GUIDE.md .template/docs/
   
   # Example ADRs (keep 0001, move examples)
   mkdir -p .template/docs/adr
   mv docs/adr/0002-example-*.md .template/docs/adr/
   mv docs/adr/0003-example-*.md .template/docs/adr/
   mv docs/adr/0004-example-*.md .template/docs/adr/
   
   # Template tools (keep user tools like wl)
   mv scripts/init-project.sh .template/scripts/
   mv scripts/bump-version.sh .template/scripts/
   mv scripts/lib-config.sh .template/scripts/
   
   # i18n system (entire directory)
   mv i18n .template/
   
   # Language modules
   mv languages .template/
   ```

3. **Keep in project root**
   ```bash
   # User-facing tools
   scripts/wl
   scripts/smart-cleanup.sh
   scripts/worklog-*.sh
   
   # Core ADR
   docs/adr/0001-record-architecture-decisions.md
   docs/adr/0005-single-instance-opencode-workflow.md
   ```

### Phase 2: Update References

Update all references to moved files:

**AGENTS.md**:
```markdown
### Required Reading
- `.template/docs/DOCUMENTATION_GUIDELINES.md` (MUST READ)
- `.template/docs/README_GUIDE.md`
- `.template/docs/TEMPLATE_SYNC.md`
```

**README.md**:
```markdown
### 使用此模板建立新專案

```bash
./.template/scripts/init-project.sh
```

參考 [.template/docs/README_GUIDE.md](./.template/docs/README_GUIDE.md)
```

**scripts/init-project.sh** (inside .template/):
```bash
# Update paths
TEMPLATE_VERSION=$(cat .template/VERSION)
```

### Phase 3: Update .gitignore

```gitignore
# Template version tracking (user creates this)
.template-version

# Do NOT ignore .template/ - it's part of the template
```

---

## Benefits

### 1. Clear Separation
```
.template/        ← Template infrastructure (sync-safe)
docs/, scripts/   ← Your project content (never touched by template sync)
```

### 2. Safe Template Updates
```bash
# Update template
git remote add template https://github.com/matheme-justyn/my-vibe-scaffolding.git
git fetch template
git checkout template/main -- .template/

# Your project files untouched!
```

### 3. Easy Identification
```bash
ls .template/     # Template infrastructure
ls docs/          # Project documentation
ls scripts/       # Project automation
```

---

## Updated File Placement Rules

| File Type | Location | Example |
|-----------|----------|---------|
| **Template infrastructure** | `.template/` | `init-project.sh`, `README_GUIDE.md` |
| **Template examples** | `.template/docs/adr/` | `0002-example-tech-stack.md` |
| **Your ADRs** | `docs/adr/` | `0001-*.md`, `0005-*.md` |
| **Your docs** | `docs/` | Project-specific documentation |
| **User tools** | `scripts/` | Project-specific scripts |
| **Template tools (used once)** | `.template/scripts/` | `init-project.sh`, `bump-version.sh` |
| **Template tools (ongoing)** | `scripts/` | `wl`, `smart-cleanup.sh` |

---

## Decision: Which Files Stay in Root?

### Template Infrastructure → .template/
- ✅ `init-project.sh` (used once at project creation)
- ✅ `bump-version.sh` (template maintainer tool)
- ✅ `lib-config.sh` (internal library)
- ✅ `README_GUIDE.md` (template documentation)
- ✅ `DOCUMENTATION_GUIDELINES.md` (template documentation)
- ✅ Example ADRs (0002-0004)
- ✅ `i18n/` (template feature)
- ✅ `languages/` (template feature)

### User Tools → scripts/
- ✅ `wl` (daily use)
- ✅ `smart-cleanup.sh` (ongoing use, project-specific config)
- ✅ `worklog-*.sh` (if kept, but wl is preferred)

### Hybrid → Root (with guidance)
- ✅ `AGENTS.md` (template base + project customization)
- ✅ `README.md` (replaced by user)
- ✅ `config.toml` (template example → user customizes)

---

## Implementation

See:
- **Migration script**: `.template/scripts/migrate-to-template-dir.sh` (TODO)
- **Updated init script**: `.template/scripts/init-project.sh` (updated paths)
- **Documentation**: All references updated to `.template/` paths

---

**Status**: Proposed
**Date**: 2026-02-26
**Next**: Decision needed - implement this structure?
