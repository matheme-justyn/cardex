# SKILL.md Format Guide

**Version:** 1.0.0  
**Last Updated:** 2026-03-10  
**Standard:** Anthropic SKILL.md format + Community Extensions

---

## Overview

A **SKILL** is a reusable AI behavior pattern packaged as a standalone file. Think of it as a function for AI agents - encapsulating specific workflows, decision trees, or domain expertise.

**Key Benefits:**
- 🔄 **Reusable** across projects and AI tools
- 📦 **Portable** - works with OpenCode, Cursor, Windsurf, Claude
- 🎯 **Focused** - one skill, one job
- 📝 **Self-documenting** - frontmatter describes purpose

---

## File Structure

### Standard SKILL.md Layout

```
skill-name/
├── SKILL.md           # Main skill file (THIS FILE)
├── README.md          # Usage documentation (optional)
├── scripts/           # Helper scripts (optional)
├── templates/         # Code templates (optional)
└── resources/         # Reference materials (optional)
```

### Minimal vs Full Structure

**Minimal (Single File):**
```
brainstorming/
└── SKILL.md           # Everything in one file
```

**Full (Multi-File):**
```
frontend-design/
├── SKILL.md           # Core skill
├── README.md          # Extended docs
├── scripts/
│   ├── lint-ui.sh
│   └── generate-component.sh
├── templates/
│   ├── component.tsx
│   └── page.tsx
└── resources/
    ├── design-tokens.json
    └── a11y-checklist.md
```

---

## SKILL.md Anatomy

### 1. Frontmatter (YAML)

Required metadata at the top of the file:

```yaml
---
name: "skill-name"
version: "1.0.0"
description: "Brief one-line description"
author: "Your Name"
tags: ["category", "domain", "feature"]
requires: ["skill-dependency-1", "skill-dependency-2"]
compatible_tools: ["opencode", "cursor", "windsurf", "claude"]
---
```

**Field Descriptions:**

| Field | Required | Description |
|-------|----------|-------------|
| `name` | ✅ | Kebab-case identifier (e.g., `test-driven-development`) |
| `version` | ✅ | SemVer format (e.g., `1.2.3`) |
| `description` | ✅ | One-line summary (max 120 chars) |
| `author` | ✅ | Creator name or organization |
| `tags` | ✅ | Array of keywords for discovery |
| `requires` | ❌ | Dependencies on other skills |
| `compatible_tools` | ❌ | Tested AI tools (defaults to all) |

---

### 2. Skill Body (Markdown)

The actual AI instructions. Structure:

```markdown
# Skill Name

## Purpose

What this skill does and when to use it.

## When to Use

- Trigger phrase 1
- Trigger phrase 2
- Situation 3

## Instructions

Step-by-step AI behavior:

1. **Step One**: Do X
   - Sub-step A
   - Sub-step B

2. **Step Two**: Analyze Y
   ```bash
   # Example command
   npm run test
   ```

3. **Step Three**: Output format
   ```json
   {
     "result": "expected structure"
   }
   ```

## Examples

### Example 1: Basic Usage

Input:
```
User: "Add authentication"
```

AI Response:
```
[Step-by-step breakdown]
```

### Example 2: Advanced

[More complex scenario]

## Anti-Patterns

What NOT to do:
- ❌ Don't skip step 1
- ❌ Don't assume X without checking
```

---

## Complete Example

### Example 1: Simple Skill

**File:** `code-review/SKILL.md`

```markdown
---
name: "code-review"
version: "1.0.0"
description: "Systematic code review focusing on security, performance, and maintainability"
author: "Vibe Scaffolding"
tags: ["review", "quality", "security"]
compatible_tools: ["opencode", "cursor", "windsurf"]
---

# Code Review Skill

## Purpose

Perform thorough code reviews with focus on security vulnerabilities, performance bottlenecks, and code maintainability.

## When to Use

- User says "review this code"
- User says "check for issues"
- Before merging pull requests
- After implementing new features

## Instructions

### 1. Security Check

Review code for:
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- Authentication/authorization flaws
- Hardcoded secrets or credentials
- Insecure dependencies

### 2. Performance Analysis

Check for:
- N+1 query problems
- Inefficient loops
- Memory leaks
- Unnecessary re-renders (React/Vue)
- Blocking operations

### 3. Code Quality

Assess:
- Code readability
- Function complexity (cyclomatic complexity)
- DRY principle violations
- Proper error handling
- Test coverage

### 4. Report Format

Output as:

```markdown
## Security Issues
- [HIGH] Issue description (Line X)
- [MEDIUM] Issue description (Line Y)

## Performance Concerns
- [MEDIUM] N+1 query in UserController (Line Z)

## Code Quality
- [LOW] Function `processData` exceeds 50 lines

## Recommendations
1. Fix high-priority security issues first
2. Consider refactoring `processData` into smaller functions
```

## Anti-Patterns

- ❌ Don't report style issues as security problems
- ❌ Don't suggest fixes without explaining why
- ❌ Don't skip positive feedback (mention what's good)
```

---

### Example 2: Complex Skill with Dependencies

**File:** `api-design/SKILL.md`

```markdown
---
name: "api-design"
version: "2.1.0"
description: "RESTful API design following OpenAPI 3.0 standards"
author: "Vibe Scaffolding"
tags: ["api", "rest", "backend", "openapi"]
requires: ["code-review", "test-driven-development"]
compatible_tools: ["opencode", "cursor"]
---

# API Design Skill

## Purpose

Design RESTful APIs following industry best practices and OpenAPI 3.0 specification.

## When to Use

- User says "design an API for..."
- User says "create REST endpoints"
- Planning new backend services
- Documenting existing APIs

## Prerequisites

This skill requires:
- `test-driven-development` - for API testing strategy
- `code-review` - for security validation

## Instructions

### 1. Understand Requirements

Ask clarifying questions:
- What resources are being managed?
- What operations are needed (CRUD+)?
- Who are the API consumers?
- Authentication requirements?

### 2. Define Resource Structure

Create resource hierarchy:

```
/users                  # Collection
/users/{id}             # Resource
/users/{id}/posts       # Nested collection
```

### 3. HTTP Method Mapping

| Operation | Method | Endpoint | Idempotent |
|-----------|--------|----------|------------|
| List | GET | /users | ✅ |
| Get | GET | /users/{id} | ✅ |
| Create | POST | /users | ❌ |
| Update | PUT | /users/{id} | ✅ |
| Partial Update | PATCH | /users/{id} | ❌ |
| Delete | DELETE | /users/{id} | ✅ |

### 4. Design Response Format

Standard success response:

```json
{
  "data": {
    "id": "123",
    "type": "user",
    "attributes": {
      "name": "John Doe"
    }
  },
  "meta": {
    "timestamp": "2026-03-10T10:00:00Z"
  }
}
```

Standard error response:

```json
{
  "errors": [
    {
      "status": "400",
      "code": "INVALID_INPUT",
      "title": "Validation Error",
      "detail": "Email format is invalid",
      "source": {
        "pointer": "/data/attributes/email"
      }
    }
  ]
}
```

### 5. Document with OpenAPI

Generate OpenAPI 3.0 spec:

```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
```

### 6. Security Considerations

Include:
- Authentication scheme (Bearer token, API key)
- Rate limiting headers
- CORS configuration
- Input validation

## Examples

### Example: User Management API

**Requirements:**
```
User: "Design an API for managing blog users with posts and comments"
```

**AI Output:**

```markdown
## Resource Hierarchy

- `/users` - User collection
  - `/users/{userId}` - User resource
  - `/users/{userId}/posts` - User's posts
  - `/users/{userId}/posts/{postId}/comments` - Post comments

## Endpoints

### Users
- `GET /users` - List all users (paginated)
- `POST /users` - Create user
- `GET /users/{userId}` - Get user details
- `PUT /users/{userId}` - Update user
- `DELETE /users/{userId}` - Delete user

### Posts
- `GET /users/{userId}/posts` - List user's posts
- `POST /users/{userId}/posts` - Create post
- `GET /posts/{postId}` - Get post (alternative route)

[... full specification ...]
```

## Anti-Patterns

- ❌ Don't use verbs in URLs (`/getUser` → `/users`)
- ❌ Don't return 200 for errors
- ❌ Don't expose internal IDs in public APIs (use UUIDs)
- ❌ Don't forget versioning strategy (`/v1/users`)
```

---

## Best Practices

### 1. Skill Naming

**Good:**
- `test-driven-development`
- `frontend-design`
- `security-audit`

**Bad:**
- `TDD_Skill_Final_v2`
- `my-awesome-skill`
- `skill`

### 2. Version Management

Follow Semantic Versioning:
- `1.0.0` → `1.0.1` - Bug fix (typo correction)
- `1.0.0` → `1.1.0` - New feature (add example)
- `1.0.0` → `2.0.0` - Breaking change (change instruction format)

### 3. Tags

Use hierarchical tags:
- Domain: `frontend`, `backend`, `devops`, `testing`
- Language: `python`, `typescript`, `go`
- Feature: `security`, `performance`, `accessibility`

**Example:**
```yaml
tags: ["frontend", "react", "performance", "accessibility"]
```

### 4. Dependencies

Only declare **hard dependencies** (skill won't work without them):

```yaml
# Good
requires: ["code-review"]  # API design requires code review

# Bad
requires: ["git-workflow"]  # Not directly needed
```

### 5. Instructions Clarity

**Good:**
```markdown
### Step 1: Validate Input

Check that:
1. Email format matches regex: `^[a-z0-9]+@[a-z]+\.[a-z]{2,3}$`
2. Password length >= 8 characters
3. Username is alphanumeric
```

**Bad:**
```markdown
### Step 1

Validate stuff properly.
```

---

## Integration with AGENTS.md

Reference skills in your project's AGENTS.md:

```markdown
## AI Assistant Skills

Our project uses these skills:

- **brainstorming** (v1.0.0) - Feature ideation and planning
- **test-driven-development** (v2.1.0) - TDD workflow
- **api-design** (v2.1.0) - RESTful API design

Skills location: `.agents/skills/`

To use a skill:
```
@use brainstorming
User: "Design a user authentication system"
```

---

## Skill Discovery

### Local Skills

```bash
# List available skills
ls .agents/skills/

# Read skill documentation
cat .agents/skills/brainstorming/SKILL.md
```

### Template Skills

```bash
# Example skills provided by template
ls .template/docs/examples/skills/
```

### Community Skills

Curated collections (Phase 2):
- heilcheng/awesome-agent-skills
- anthropics/skills
- Project-specific skill repositories

---

## Validation Checklist

Before committing a new skill:

- [ ] Frontmatter has all required fields
- [ ] Version follows SemVer
- [ ] Description is under 120 characters
- [ ] Instructions are step-by-step (numbered)
- [ ] At least one example provided
- [ ] Anti-patterns documented
- [ ] Tags are relevant and specific
- [ ] Compatible tools tested
- [ ] Dependencies are necessary (not optional)
- [ ] README.md exists (if skill is complex)

---

## FAQ

### Q: SKILL.md vs AGENTS.md?

**AGENTS.md:**
- Project-wide conventions
- Coding standards
- Commit message format
- Team workflow

**SKILL.md:**
- Reusable behavior patterns
- Specific task workflows
- Domain expertise (TDD, API design)
- Portable across projects

### Q: When to create a new skill?

Create a skill when:
- ✅ Workflow is reusable (5+ projects benefit)
- ✅ Instructions are complex (10+ steps)
- ✅ Domain expertise is specialized (API design, security)

Don't create a skill for:
- ❌ One-off tasks
- ❌ Project-specific conventions (use AGENTS.md)
- ❌ Simple reminders (2-3 steps)

### Q: How to version skills?

- **PATCH** (1.0.0 → 1.0.1): Typo fixes, clarifications
- **MINOR** (1.0.0 → 1.1.0): Add examples, new optional steps
- **MAJOR** (1.0.0 → 2.0.0): Change instruction flow, remove steps

### Q: Can skills call other skills?

Yes, using `requires` field:

```yaml
requires: ["brainstorming", "code-review"]
```

AI should load dependencies before executing the skill.

---

## Next Steps

1. **Study Examples**: See `.template/docs/examples/skills/`
2. **Create Your First Skill**: Copy `template-skill/` as starting point
3. **Test with AI**: Load skill in OpenCode/Cursor and test
4. **Share**: Contribute useful skills back to community

---

## References

- **Anthropic Skills Format**: https://github.com/anthropics/skills
- **AGENTS.md Standard**: https://agents.md/
- **OpenAPI 3.0 Spec**: https://swagger.io/specification/
- **Semantic Versioning**: https://semver.org/

---

**Template Version:** 1.3.0  
**Maintained by:** Vibe Scaffolding Project
