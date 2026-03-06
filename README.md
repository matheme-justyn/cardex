# Cardex

[![Version](https://img.shields.io/badge/version-0.3.0-blue.svg)](./VERSION)
[![License](https://img.shields.io/badge/license-TBD-yellow.svg)](./LICENSE)

English | [繁體中文](./README.zh-TW.md)

> **Academic Knowledge Management System** — Complete lifecycle from PDF to structured knowledge cards

Cardex is a fully programmatic academic literature management system designed for researchers. It has no dependency on any GUI application; all data is stored in open formats (SQLite + Markdown) and can be visualized through self-hosted web services.

> ⚠️ **Pre-release**: This project is in active development (0.X versioning). Breaking changes may occur before 1.0.0 release.

## 📇 About the Name

**Cardex** is a portmanteau of "**Card Index**" — a tribute to the nearly extinct profession of **Card Catalog Filer**.

Before computerized catalogs became ubiquitous (circa 1980s–2000s), libraries employed dedicated staff to maintain wooden card catalog drawers. For every new book, these workers — predominantly women — handwrote or typed multiple index cards (one for author, title, and subject each) and filed them alphabetically in precise order. They spent countless hours building and maintaining the library's knowledge infrastructure, yet their contributions were often undervalued and overlooked.

Cardex honors this invisible labor and reimagines the card catalog for the digital age — where AI assists, but the human researcher remains in control.



---

- [What is Cardex?](#what-is-cardex)
- [Core Features](#core-features)
- [Quick Start](#quick-start)
- [Recommended Workflow](#recommended-workflow)
- [Documentation](#documentation)

---

## What is Cardex?

Cardex transforms your academic PDF collection into a queryable knowledge base:

- **Automatic metadata extraction** - Title, authors, venue, citations parsed automatically
- **Multi-angle summarization** - Generate different summaries with pluggable "Skills" (methodology, security, general, etc.)
- **Evidence grading** - Know which papers are backed by Nature/Science vs. preprints
- **Citation tracking** - See what you've cited but haven't read yet
- **AI argumentation** - Generate evidence-backed arguments from your library

---

## ✨ Core Features
---
### 🎯 Design Philosophy

- **Fully Programmatic** - CLI-first, no GUI lock-in
- **Open Formats** - SQLite + Markdown (portable, Git-friendly)
- **Self-hosted** - Your data stays on your machine
- **Editor-agnostic** - Use VSCode, Obsidian, or any Markdown editor

### 💡 What Makes Cardex Different?

1. **Skill System** - Generate multiple views of the same paper
   - Apply different analytical lenses (methodology, security, evidence strength)
   - Extensible via YAML config files

2. **Evidence Grading** - Automatically assess source quality
   - Tier 1: Nature/Science/CORE A* journals + RCT methodology
   - Know which claims are backed by strong evidence

3. **Argue Engine** - Build evidence-backed arguments
   - Ask a research question
   - AI searches your library and ranks by evidence strength
   - Get structured arguments with inline citations

4. **Citation Alerts** - Track what you should read next
   - Papers cited multiple times but not yet in your library
   - Understand research lineage and networks


## 🚀 Quick Start

> ⚠️ **Phase 0 in development** - Installation instructions below are planned, not yet functional.

```bash
# Install
pip install cardex

# Initialize (one-time setup)
cardex init
# This creates ~/.cardex/config.yaml and prompts for your PDF folder

# Start the web interface
cardex serve
# Open http://localhost:8501

# Or use CLI directly
cardex scan                          # Find all PDFs in configured folder
cardex ingest path/to/paper.pdf     # Process a single paper
cardex summarize --skill methodology # Generate methodology summary
```

---
---

## 🔄 Recommended Workflow

### Option 1: VSCode + Foam (Recommended)

1. **Initial setup**:
   ```bash
   cardex init  # Configure library folder
   cardex serve # Start web service in background
   ```

2. **Daily workflow**:
   - Drop new PDFs into your inbox folder
   - Cardex auto-scans and processes them
   - Open `markdown/papers/` in VSCode with Foam extension
   - Take notes, add tags, link between papers using `[[wikilinks]]`
   - Use web UI when you need citation graphs or argument generation

3. **Writing mode**:
   - Open Argue Engine in web UI
   - Input your thesis statement
   - Get evidence-backed argument with citations
   - Export to Markdown and refine in VSCode

### Option 2: Pure Web UI

- Start `cardex serve`
- Upload PDFs via web interface
- Read summaries, explore citation graph, generate arguments all in browser

### Option 3: CLI Power User

```bash
# Batch ingest
cardex ingest ~/Downloads/*.pdf

# Generate summaries for all papers
cardex summarize --all --skills general,methodology

# Search your library
cardex search "transformer architecture"

# Export to BibTeX
cardex export --format bibtex > library.bib
```

## 📖 Documentation

- **[PRD](./docs/PRD.md)** - Complete product requirements
- **[Data Model](./docs/data-model.md)** - Database schema and file layout
- **[Technology Stack](./docs/technology-stack.md)** - Why we chose each tool
- **[Phase 0 Spec](./docs/phase-0-service-foundation.md)** - Current development phase

### Tech Stack Overview

- **Backend**: Python + FastAPI
- **Frontend**: Streamlit (Phase 0-1) → React (Phase 2+)
- **Database**: SQLite + SQLAlchemy
- **AI/RAG**: LlamaIndex + LiteLLM (supports OpenAI, Anthropic, Ollama)
- **Vector Store**: ChromaDB
- **PDF Processing**: PyMuPDF
- **CLI**: Click

See [docs/technology-stack.md](./docs/technology-stack.md) for detailed rationale.

---

## 🗓️ Development Status

**Current Phase**: Phase 0 - Service Foundation

✅ **Completed**:
- Project structure and documentation
- Technology stack decisions
- Data model design

🚧 **In Progress**:
- Configuration system (`~/.cardex/config.yaml`)
- PDF scanner (discover PDFs in folder)
- Basic web UI (display PDF list)
- CLI commands (`cardex init`, `cardex serve`)

📋 **Next Up**:
- Phase 1: Ingest pipeline (metadata extraction, enrichment)
- Phase 2: Skill system (multi-angle summarization)
- Phase 3: Citation graph and Argue Engine

---

## 🤝 Contributing

This project is primarily driven by the author's own needs, but community issues and feature suggestions are welcome.

To contribute code:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (follow conventions in [AGENTS.md](./AGENTS.md))
4. Push to your branch
5. Open a Pull Request

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details

---

## 📄 License

License TBD - Will choose an open source license, see [LICENSE](./LICENSE)

---

## 🙏 Acknowledgments

Cardex is inspired by:
- Zotero (literature management)
- Obsidian (knowledge linking)
- LlamaIndex (RAG architecture)
- And all researchers struggling with academic research 📚

---

**Based on**: [my-vibe-scaffolding](https://github.com/matheme-justyn/my-vibe-scaffolding) v1.10.0

For more guidance on writing READMEs, see [.template/docs/README_GUIDE.md](./.template/docs/README_GUIDE.md)
