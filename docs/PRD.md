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

## 3.1 Paradigm System（派典系統）

**NEW ARCHITECTURE (March 2026)**: Cardex introduces a **Paradigm-driven analysis system** to enable cross-cutting perspectives on the same literature corpus.

### 3.1.1 Core Concept

A **Paradigm（派典）** is a configuration file that defines:
- A **researcher's cognitive framework** (theoretical stance, methodological preferences)
- A **research topic's analytical lens** (core questions, theoretical frameworks)
- A **research school's perspective** (shared beliefs, values, exemplars)

**Key Innovation**: The same PDF can be analyzed through **multiple paradigms**, generating different analysis cards that reflect different theoretical perspectives.

### 3.1.2 Paradigm Types

| Type | Description | Example |
|------|-------------|---------|
| **Researcher** | Individual researcher's digital twin | "Robin - IHL Privacy Researcher" |
| **Topic** | Research topic framework | "Data Privacy in Armed Conflict" |
| **School** | Academic school of thought | "Critical Legal Studies" |

### 3.1.3 Workflow

```
Input: Batch of PDFs (e.g., 20 papers in "1_國際法/" folder)
↓
Apply Paradigm: "IHL Data Privacy" paradigm configuration
↓
Generate Analysis Cards: Each paper analyzed through paradigm's lenses
↓
Synthesis: Aggregate all analysis cards into comprehensive review
```

### 3.1.4 File Structure

```
~/.cardex/
├── paradigms/
│   ├── example.paradigm          # Template (committed to git)
│   ├── ihl_data_privacy.paradigm # User-created (gitignored)
│   └── robin_researcher.paradigm # User-created (gitignored)
└── .gitignore                    # Ignores *.paradigm except example.paradigm
```

### 3.1.5 Paradigm File Format

A paradigm file (`.paradigm`) is YAML-based:

```yaml
# paradigms/ihl_data_privacy.paradigm
name: "國際法與武裝衝突中的數據地位"
type: topic  # researcher | topic | school

# 核心問題
core_questions:
  - "數據在 IHL 下的法律定位是什麼？"
  - "隱私權在戰時如何適用？"

# 理論框架
theoretical_frameworks:
  - "International Humanitarian Law (IHL)"
  - "International Human Rights Law (IHRL)"

# 學派（如果是 topic type）
schools:
  - name: "數據=財產派"
    representatives: ["Blank", "Jensen"]
    thesis: "將數據定義為受 IHL 保護的財產"
  
  - name: "隱私權持續適用派"
    representatives: ["O'Connell", "Watt"]
    thesis: "隱私權在戰時不中止"

# 分析視角（Lenses）
lenses:
  - name: "Legal Status of Data"
    prompt: "prompts/legal_status_of_data.md"
    output_structure: |
      ### 核心貢獻
      [論文對數據法律地位的貢獻]
      
      ### 立場分析
      - 支持/反對/中立：[判斷]
      - 關鍵論證：[摘錄]
```

### 3.1.6 Integration with Skill System

- **Paradigm**: User-facing configuration layer (what perspective to use)
- **Lens**: Analysis angle within a paradigm (how to extract insights)
- **Skill**: Technical implementation layer (prompt + LLM engine)

**Relationship**:
```
Paradigm (派典配置)
  └─ Lenses (分析視角)
      └─ Skills (技術實作) ← Reuses existing Skill engine
```

### 3.1.7 Concerto System（協奏系統）

**Concerto（協奏曲）**: A dialogue between your research paradigm and audience expectations.

**Musical Metaphor**:
- **Solo (獨奏)**: Your research perspective defined by the Paradigm
- **Orchestra (樂團)**: The expectations and standards of your target audience
- **Concerto (協奏)**: The harmonious collaboration between both

**Example Concerti**:

| Concerto | Solo | Orchestra | Output Style |
|----------|------|-----------|--------------|
| `journal_submission` | Your research findings | Academic journal standards | Formal, evidence-based, 8000 words |
| `policy_brief` | Your research findings | Policymaker expectations | Concise, action-oriented, 2000 words |
| `conference_presentation` | Your research findings | Academic conference norms | Structured slides, 20 minutes |
| `public_lecture` | Your research findings | General public understanding | Accessible language, storytelling |

**File Location**: `~/.cardex/concerti/`


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

#### paradigms

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | UUID |
| `name` | TEXT | Paradigm name (e.g., "IHL Data Privacy") |
| `type` | TEXT | researcher / topic / school |
| `file_path` | TEXT | Path to .paradigm file |
| `core_questions` | TEXT | JSON array of research questions |
| `theoretical_frameworks` | TEXT | JSON array of frameworks |
| `created_at` | TEXT | ISO 8601 timestamp |
| `updated_at` | TEXT | ISO 8601 timestamp |

#### analyses

Replaces the original `summaries` table to reflect paradigm-driven analysis.

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | UUID |
| `paper_id` | TEXT FK | → papers.id |
| `paradigm_id` | TEXT FK | → paradigms.id |
| `lens_name` | TEXT | Name of the lens used (e.g., "Legal Status of Data") |
| `content` | TEXT | Markdown content of the analysis card |
| `generated_at` | TEXT | ISO 8601 timestamp |
| `model` | TEXT | LLM model identifier used |

#### syntheses

Stores aggregated knowledge syntheses from multiple analysis cards.

| Column | Type | Description |
|--------|------|-------------|
| `id` | TEXT PK | UUID |
| `paradigm_id` | TEXT FK | → paradigms.id |
| `concerto` | TEXT | Concerto type (e.g., journal_submission, policy_brief) |
| `paper_ids` | TEXT | JSON array of paper IDs included |
| `content` | TEXT | Markdown content of synthesis |
| `generated_at` | TEXT | ISO 8601 timestamp |
| `model` | TEXT | LLM model identifier used |


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

### 6.3 Paradigm-Driven Workflow: Two-Page Design

**NEW (March 2026)**: Cardex introduces a two-page workflow for paradigm-driven analysis.

#### Page 1: Paradigm Analysis (派典分析)

**Purpose**: Select paradigm + papers → Generate analysis cards

**UI Layout**:

```
┌───────────────────────────────────────────────────────────┐
│  🎼 Paradigm Analysis                                      │
├───────────────────────────────────────────────────────────┤
│  Step 1: Select Paradigm                                     │
│  ┌────────────────────────────────────────────────────┐  │
│  │ ▼ Select Paradigm                                │  │
│  │   ● IHL Data Privacy                              │  │
│  │   ○ Robin - IHL Researcher                       │  │
│  │   + Create New Paradigm                          │  │
│  └────────────────────────────────────────────────────┘  │
│  Type: Topic | Lenses: 4 | Questions: 2                     │
├───────────────────────────────────────────────────────────┤
│  Step 2: Select Papers                                       │
│  ┌────────────────────────────────────────────────────┐  │
│  │ 🔍 Search or filter...                          │  │
│  └────────────────────────────────────────────────────┘  │
│  [📁 1_國際法] [📁 2_數據權利] [📁 3_技術架構]           │
│                                                             │
│  ☐ Select All (23 papers)                                │
│  ☑ [O'Connell 2022] Privacy Rights...                     │
│  ☑ [Blank 2022] Data as Property...                       │
│  ☐ [West 2022] Precautionary Principle...                 │
│  Selected: 2 papers                                          │
├───────────────────────────────────────────────────────────┤
│  Step 3: Configure Lenses                                    │
│  ☑ Legal Status of Data                                   │
│  ☑ Privacy Rights Continuity                              │
│  ☐ Legal Gaps Identification                              │
│                                                             │
│        [🎼 Generate Analysis Cards]                      │
│                                                             │
│  Estimated: 4 cards (2 papers × 2 lenses)                  │
└───────────────────────────────────────────────────────────┘
```

**Key Features**:
- Quick folder buttons (📁) for common paper groups
- Real-time card count estimate
- Smart defaults (all lenses checked)
- Progress indicator during generation

**Workflow**:
1. User selects a paradigm (e.g., "IHL Data Privacy")
2. User selects papers (folder-based or individual)
3. User configures which lenses to apply (default: all)
4. System generates analysis cards (paper × lens combinations)
5. Results saved to `~/.cardex/analyses/` and database

**State Persistence**: Selected paradigm and generated analyses carry over to Page 2

#### Page 2: Concerto Synthesis (協奏匯總)

**Purpose**: Select concerto + analysis cards → Generate synthesis document

**Key Features**:
- Paradigm selector (pre-selected if coming from Page 1)
- Analysis card browser with filters (lens, date range, paper)
- Card preview modal
- Concerto selector with audience/tone/length details
- Synthesis configuration (output path, custom settings)
- Progress indicator with synthesis stages

**Workflow**:
1. User selects paradigm (auto-selected if from Page 1)
2. User browses and selects analysis cards
3. User chooses concerto (e.g., "Journal Submission", "Policy Brief")
4. System generates synthesis document following concerto template
5. Output saved to `synthesis/` folder and database

**Detailed Specification**: See [docs/gui-paradigm-specification.md](./gui-paradigm-specification.md)

## 6.5 Paradigm-Driven CLI Commands

**NEW (March 2026)**: Cardex introduces paradigm-based analysis commands.

### Paradigm Management

```bash
# List all paradigms
cardex paradigm list

# Show paradigm details
cardex paradigm show <name>

# Create new paradigm (interactive or from template)
cardex paradigm create --type topic --name "IHL Data Privacy"
cardex paradigm create --type researcher --name "Robin"
cardex paradigm create --type school --name "Critical Legal Studies"

# Edit paradigm (opens in $EDITOR)
cardex paradigm edit <name>

# Validate paradigm file syntax
cardex paradigm validate <file.paradigm>
```

### Paradigm Analysis

```bash
# Analyze batch of PDFs with a paradigm
cardex analyze \
  --paradigm "IHL Data Privacy" \
  --files "1_國際法/*.pdf"

# Analyze entire folder recursively
cardex analyze \
  --paradigm "IHL Data Privacy" \
  --folder "1_國際法" \
  --recursive

# Analyze specific files
cardex analyze \
  --paradigm "IHL Data Privacy" \
  --files "[O_Connell 2022].pdf" "[Blank 2022].pdf"

# Specify which lenses to use (default: all lenses in paradigm)
cardex analyze \
  --paradigm "IHL Data Privacy" \
  --lenses "Legal Status of Data,Privacy Continuity"
```

### View Analysis Results

```bash
# Show all analyses for a paper
cardex show "[O_Connell 2022]"

# Show specific paradigm's analysis
cardex show "[O_Connell 2022]" --paradigm "IHL Data Privacy"

# Show specific lens analysis
cardex show "[O_Connell 2022]" \
  --paradigm "IHL Data Privacy" \
  --lens "Legal Status of Data"
```

### Synthesis Commands

```bash
# Create synthesis from paradigm analyses
cardex synthesis create \
  --paradigm "IHL Data Privacy" \
  --folder "1_國際法" \
  --output synthesis/ihl_privacy_review.md

# Specify concerto (output style for different audiences)
# Concerto: A dialogue between your research paradigm and audience expectations
cardex synthesis create \
  --paradigm "IHL Data Privacy" \
  --folder "1_國際法" \
  --concerto journal_submission \
  --output submission_draft.md

# Synthesis with specific lenses only
cardex synthesis create \
  --paradigm "IHL Data Privacy" \
  --folder "1_國際法" \
  --lenses "Legal Status of Data" \
  --output legal_status_review.md
```

### Background Execution

```bash
# Run analysis in background (for large batches)
cardex analyze \
  --paradigm "IHL Data Privacy" \
  --folder "1_國際法" \
  --background

# Check background job status
cardex jobs list
cardex jobs show <job_id>
```

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
| **M0** | Service Foundation | **NEW - Current Priority**: Config system (YAML), CLI (init/serve), PDF scanner, Streamlit UI (list view only). Goal: See what PDFs you have. [Details](./phase-0-service-foundation.md) |
| **M1** | Core scaffold | SQLite schema, CLI skeleton, Docker Compose, folder structure |
|---|-----------|-------|
| **M1** | Core scaffold | SQLite schema, CLI skeleton, Docker Compose, folder structure |
| **M2** | Ingest pipeline | Steps 1–7 of ingest: file check, ~~OCR~~, metadata, naming, move |
| **M3** | LlamaIndex integration | ~~Embedding~~, ~~vector store~~, basic query engine (deferred to M4+) |
| **M4** | Skill system + summarization | Skill YAML spec, default Skills, summary card generation |
| **M5** | Citation graph | Reference extraction, unread alert system, research group tracking |
| **M6** | Web UI v1 | FastAPI + Streamlit prototype covering Library, Paper Detail, Alerts views |
| **M7** | Argue Engine | Semantic search + evidence-weighted argument composition |
| **M8** | Web UI v2 | Full React frontend, Citation Graph view, Skills management view |

**Current Priority**: M0 (Service Foundation) → M1, M2 (simplified), M6 (Streamlit)

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

**Phase 0 (Service Foundation) is successful if:**

- [ ] User can run `cardex init` and configure library path
- [ ] User can run `cardex serve` and see web UI in browser
- [ ] Web UI displays list of all PDFs in configured folder
- [ ] User can search/filter PDFs by filename
- [ ] User can toggle recursive scan on/off
- [ ] No crashes when folder is empty or contains non-PDF files

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
