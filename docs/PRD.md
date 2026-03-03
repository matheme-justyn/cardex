# Cardex - Product Requirements Document

**Version**: 0.1  
**Date**: March 2026  
**Status**: Draft

---

## 1. Product Overview

Cardex is a fully programmatic academic knowledge management system designed to handle the entire lifecycle of academic literature — from raw PDF ingestion to structured knowledge cards and AI-assisted argumentation. The system has no dependency on any GUI application; all data is stored in open formats (SQLite, Markdown) and can be visualized through self-hosted web services.

| Attribute | Value |
|-----------|-------|
| **Product Name** | Cardex |
| **Version** | 0.1 (Initial PRD) |
| **Target User** | Individual researcher / research team |
| **Interface** | Web UI (self-hosted) + Python CLI |
| **Storage** | SQLite (source of truth) + Markdown files |
| **AI Layer** | LlamaIndex + pluggable LLM backend |
| **License** | Open Source (TBD) |

---

## 2. Goals & Non-Goals

### 2.1 Goals

- Automate the ingestion, classification, and naming of academic PDFs
- Maintain a single source of truth (SQLite) for all literature metadata
- Generate multiple summary variants per paper using pluggable Skill definitions
- Track citation relationships and alert on unread referenced papers
- Evaluate and display evidence strength based on journal/conference quality
- Enable AI-assisted argumentation grounded in the user's own literature library
- Provide a self-hosted web UI for browsing, editing, and reviewing

### 2.2 Non-Goals

- Not a cloud service — no SaaS, no external data submission
- Not a citation manager with Word/LaTeX plugin (Zotero replacement is out of scope)
- Not a general-purpose RAG chatbot — focus is on structured knowledge cards
- Not a collaborative multi-user platform in v1

---

## 3. System Architecture

The system is organized as a layered pipeline. Each layer is independently operable via CLI and collectively accessible through the web UI.

| Layer | Name | Responsibility |
|-------|------|----------------|
| **Layer 1** | Ingest | File intake, integrity check, OCR detection, rename, folder placement |
| **Layer 2** | Metadata | Extract bibliographic data from PDF + enrich via Semantic Scholar / CrossRef APIs |
| **Layer 3** | Summarize | Run one or more Skill definitions to produce multiple summary cards per paper |
| **Layer 4** | Graph | Build citation graph, detect unread references, track research groups |
| **Layer 5** | Quality | Assign evidence weight based on journal/conference ranking (CORE, JCR, etc.) |
| **Layer 6** | Argue | Query the knowledge base; compose arguments with inline citations |
| **Layer 7** | Web UI | FastAPI backend + frontend for all read/write operations |

---

## 4. Data Model

### 4.1 SQLite Tables

#### papers

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | SHA256 of original file |
| `title` | TEXT | Extracted or manually corrected title |
| `authors` | TEXT | JSON array of author objects |
| `year` | INTEGER | Publication year |
| `venue` | TEXT | Journal or conference name |
| `venue_rank` | TEXT | e.g. CORE A*, Q1, N/A |
| `doi` | TEXT | DOI if available |
| `file_path` | TEXT | Relative path under library root |
| `status` | TEXT | unread / reading / done |
| `ocr_required` | INTEGER | 0 or 1 (v1: mark only, no OCR execution) |
| `ingested_at` | TEXT | ISO 8601 timestamp |

#### summaries

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | UUID |
| `paper_id` | TEXT FK | → papers.id |
| `skill_name` | TEXT | Name of the Skill used (e.g. security_eval, methodology) |
| `content` | TEXT | Markdown content of the summary card |
| `generated_at` | TEXT | ISO 8601 timestamp |
| `model` | TEXT | LLM model identifier used |

#### notes

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | UUID |
| `paper_id` | TEXT FK | → papers.id |
| `content` | TEXT | Markdown freeform note |
| `created_at` | TEXT | ISO 8601 timestamp |
| `updated_at` | TEXT | ISO 8601 timestamp |

#### citations

| Column | Type | Description |
|--------|------|-------------|
| `citing_id` | TEXT FK | → papers.id (the paper that cites) |
| `cited_doi` | TEXT | DOI of the cited paper |
| `cited_title` | TEXT | Title of the cited paper |
| `in_library` | INTEGER | 0 = not yet ingested, 1 = in library |
| `citation_count` | INTEGER | How many papers in library cite this |

### 4.2 File System Layout

The library root folder structure is defined by a configurable naming strategy. Default layout:

```
library/
├── 2024/
│   ├── Nature/
│   │   └── Smith_2024_Quantum_Computing.pdf
│   ├── ICML/
│   │   └── Chen_2024_Neural_Architecture.pdf
│   └── arXiv/
│       └── Lee_2024_Preprint.pdf
├── 2023/
│   └── ...
└── needs_ocr/
    └── unreadable_scan.pdf
```

Naming and folder logic is defined in a YAML strategy file and can be swapped without re-ingesting.

---

## 5. Skill System

A **Skill** is a YAML + Markdown definition file that tells Cardex how to summarize a paper from a particular analytical angle. Multiple Skills can be applied to the same paper, producing multiple independent summary cards.

### 5.1 Skill File Format

```yaml
name: security_eval
description: Security and threat model analysis
output_format: markdown
prompt_template: prompts/security_eval.md
model_preference: gpt-4  # or "default"
```

### 5.2 Built-in Skills (v1)

| Skill Name | Focus |
|------------|-------|
| **general** | Standard abstract + contribution + limitations summary |
| **methodology** | Focus on research design, datasets, evaluation metrics |
| **security_eval** | Threat model, attack surface, evaluation approach |
| **evidence_strength** | Study design quality, sample size, reproducibility |
| **citation_context** | Why this paper cites what it cites; theoretical lineage |

Users can add custom Skills by placing YAML + prompt Markdown files in the `skills/` directory.

---

## 6. Web Interface

The web interface is a self-hosted application providing full read/write access to the Cardex database. It is not required for system operation — the CLI is fully functional standalone — but it is the primary human interface.

### 6.1 Views

| View | Description |
|------|-------------|
| **Library** | Filterable, sortable table of all papers with status, rank, year, venue |
| **Paper Detail** | Full metadata, all summary cards by Skill, notes editor, citation graph |
| **Unread Alerts** | Papers referenced ≥ N times across the library but not yet ingested |
| **Citation Graph** | Interactive visualization of paper relationships |
| **Argue** | Topic input → AI assembles argument with inline citations from library |
| **Skills** | List and preview of available Skills; trigger re-summarization |
| **Settings** | Naming strategy, API keys, model selection, folder layout |

### 6.2 Tech Stack

| Component | Technology |
|-----------|------------|
| **Backend** | FastAPI (Python) |
| **Database** | SQLite via SQLAlchemy |
| **Frontend** | React + Tailwind (or Streamlit for v1 prototype) |
| **AI Layer** | LlamaIndex + configurable LLM (OpenAI / local Ollama) |
| **Deployment** | Docker Compose (single command startup) |

---

## 7. Ingest Pipeline Detail

The ingest pipeline is triggered by dropping files into a watch folder or calling the CLI directly. Each step is logged to the database.

| # | Step | Description |
|---|------|-------------|
| 1 | **File Check** | Verify PDF is not corrupted (can be opened, has extractable structure) |
| 2 | **OCR Detection** | Attempt text extraction; if character yield < threshold, flag for OCR |
| 3 | **OCR (if needed)** | **v1: Mark only, do not execute OCR**. Flag `ocr_required=1` in database |
| 4 | **Metadata Extract** | Extract title, authors, year from PDF text using LLM or heuristic parser |
| 5 | **API Enrichment** | Query Semantic Scholar + CrossRef by title/DOI to fill missing fields |
| 6 | **Venue Ranking** | Lookup journal/conference in CORE / JCR database; assign rank tier |
| 7 | **Naming & Move** | Apply naming strategy; move to correct subfolder; update SQLite |
| 8 | **Embedding** | Chunk PDF and generate embeddings via LlamaIndex; store vector index |
| 9 | **Summarize** | Apply default Skill(s); store summary cards in summaries table |
| 10 | **Citation Scan** | Extract reference list; cross-check against library; flag missing papers |

**v1 Simplification**: Steps 3 (OCR execution), 8 (Embedding), and 10 (Citation Scan) are deferred to later phases.

---

## 8. Evidence Quality System

Each paper receives an evidence tier based on its publication venue and study design. This tier is displayed in search results and used to weight AI-generated arguments.

| Tier | Criteria |
|------|----------|
| **Tier 1 — Strong** | CORE A* / Nature / Science / top-tier IEEE; RCT or systematic review methodology |
| **Tier 2 — Solid** | CORE A or B / Q1–Q2 journals; controlled study with clear methodology |
| **Tier 3 — Moderate** | CORE C / Q3–Q4 / workshop papers; observational or preliminary study |
| **Tier 4 — Weak** | Unranked venue; preprint only; opinion / position paper |
| **Tier 0 — Unknown** | Venue not found in ranking database; manual review required |

**Ranking data sources**: CORE Portal (conference rankings), Scimago Journal Rankings (SJR), and a locally maintained override CSV for domain-specific adjustments.

---

## 9. Argue Engine

The Argue Engine is the primary research output interface. Given a topic or thesis statement, it retrieves relevant knowledge cards, ranks them by evidence tier, and uses the LLM to compose a structured argument with inline citations.

### 9.1 Inputs

- Topic / thesis statement (free text)
- Optional: restrict to specific papers, years, venues, or evidence tiers
- Optional: output format (paragraph prose / structured outline / bullet points)

### 9.2 Process

1. Semantic search over LlamaIndex vector store → retrieve top-K relevant chunks
2. Re-rank by evidence tier (Tier 1 papers weighted higher)
3. Feed retrieved context + user's own notes into LLM prompt
4. LLM generates argument; every claim maps back to a specific paper + page
5. Output displayed in web UI with clickable citations; exportable to Markdown

### 9.3 Output Format

Each argument block contains: claim text, supporting evidence quote, source paper ID, page reference, and evidence tier badge. The full output is stored as a session in the database for later retrieval.

---

## 10. Development Milestones

| # | Milestone | Scope |
|---|-----------|-------|
| **M1** | Core scaffold | SQLite schema, CLI skeleton, Docker Compose, folder structure |
| **M2** | Ingest pipeline | Steps 1–7 of ingest: file check, ~~OCR~~, metadata, naming, move |
| **M3** | LlamaIndex integration | ~~Embedding~~, ~~vector store~~, basic query engine (deferred to M4+) |
| **M4** | Skill system + summarization | Skill YAML spec, default Skills, summary card generation |
| **M5** | Citation graph | Reference extraction, unread alert system, research group tracking |
| **M6** | Web UI v1 | FastAPI + Streamlit prototype covering Library, Paper Detail, Alerts views |
| **M7** | Argue Engine | Semantic search + evidence-weighted argument composition |
| **M8** | Web UI v2 | Full React frontend, Citation Graph view, Skills management view |

**v1 Priority**: M1, M2 (simplified), M6 (Streamlit)

---

## 11. Open Questions

| Question | Status | Decision |
|----------|--------|----------|
| Naming strategy format: YAML-based rule DSL vs. Python plugin? | Open | **v1: YAML + Jinja2 template** |
| OCR engine selection: Marker vs. Tesseract? | Open | **v1: Mark only, no execution** |
| Vector store backend: ChromaDB vs. Qdrant? | Open | **v1: ChromaDB** (in-process, simple) |
| Skill prompt versioning: re-summarization on prompt change? | Open | Manual trigger in v1 |
| Citation extraction: LLM parse vs. GROBID? | Open | **v1: LLM parse** |
| Authentication: single-user vs. basic auth? | Open | **v1: localhost, no auth** |

---

## 12. Success Criteria

**MVP (v0.1) is successful if:**

- [ ] User can drop PDF → see metadata extracted + file renamed/moved
- [ ] User can view paper list in Web UI (Streamlit)
- [ ] User can apply 1+ Skills → see summary cards generated
- [ ] All data persists in SQLite + Markdown

**v1.0 is successful if:**

- [ ] All M1–M6 milestones completed
- [ ] Stable for daily research workflow (author's use case)
- [ ] Documentation complete enough for external contributors

---

## Appendix: References

- [CORE Rankings](https://www.core.edu.au/conference-portal)
- [Scimago Journal Rankings](https://www.scimagojr.com/)
- [Semantic Scholar API](https://www.semanticscholar.org/product/api)
- [CrossRef API](https://www.crossref.org/documentation/retrieve-metadata/)
- [LlamaIndex Documentation](https://docs.llamaindex.ai/)
