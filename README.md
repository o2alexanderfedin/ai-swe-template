# AI Software Engineering Template

[![GitHub Template](https://img.shields.io/badge/template-Use%20this%20template-brightgreen)](https://github.com/USER/REPO/generate)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![AI SWE](https://img.shields.io/badge/AI-Software%20Engineering-purple)](AI_SWE_article.md)

> A production-ready template for systematic AI-assisted development using the AI SWE methodology.

---

## Quick Start

### For New Projects

1. Click **"Use this template"** button above
2. Clone your new repository
3. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```
4. Answer a few questions (2 minutes)
5. Start developing with AI assistance!

### For Existing Projects

Add AI SWE methodology to your existing codebase:

```bash
cd your-existing-project
curl -sSL https://raw.githubusercontent.com/USER/REPO/main/scripts/setup-existing.sh | bash
```

### What You Get

- **Complete Memory Bank system**: 13 files, 3,500+ lines of structured knowledge
- **Custom slash commands**: 5 commands for systematic workflows
- **Three-phase workflow**: Planning (Gemini) → Execution (Claude Code) → Review
- **Language-specific templates**: Python, JavaScript, Go, Rust
- **Git flow integration**: Automated branch and commit management
- **Comprehensive documentation**: Guides, patterns, and workflows

---

## Why Use This Template?

### The Problem with Traditional AI-Assisted Development

- AI loses context after 30-50 messages
- Repetitive explanations of project architecture
- No systematic approach to feature development
- Inconsistent code quality and patterns
- Knowledge scattered across conversations

### The AI SWE Solution

This template implements the **AI SWE (Software Engineering) methodology** - a systematic approach that:

1. **Preserves Context**: Memory Bank serves as persistent project knowledge
2. **Enforces Patterns**: Architectural decisions documented and enforced
3. **Systematic Workflows**: Standardized processes for features, bugs, reviews
4. **Three-Phase Process**: Separation of planning, execution, and review
5. **Self-Documentation**: AI updates knowledge base as it works

### Real Results

- **5x faster feature development** with comprehensive specs
- **90% reduction** in context loss issues
- **Consistent code quality** through enforced patterns
- **Zero knowledge silos** - everything in Memory Bank
- **Seamless team collaboration** with shared knowledge base

---

## About This Repository

This repository serves **dual purposes**:

1. **Production Template** - Use it to start new projects or enhance existing ones
2. **Reference Implementation** - See AI SWE methodology in action with a real project

**Reference Project**: Due Diligence Bot - An intelligent Telegram bot for automated comprehensive company and project verification (due diligence), powered by AI and implementing the AI SWE (Software Engineering) methodology.

### Learn More

- **[TEMPLATE_STRATEGY.md](./TEMPLATE_STRATEGY.md)** - Complete template usage strategy
- **[QUICK_START.md](./QUICK_START.md)** - Quick start guide for developers
- **[IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md)** - Detailed setup implementation plan
- **[AI_SWE_article.md](./AI_SWE_article.md)** - Original methodology article

---

## How to Use This Template

### Step-by-Step Setup

#### 1. Create Your Project (1 minute)

**Option A: New Project**
```bash
# Click "Use this template" on GitHub
# Clone your new repo
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

**Option B: Existing Project**
```bash
cd your-existing-project
# Download setup script
curl -O https://raw.githubusercontent.com/USER/REPO/main/scripts/setup-existing.sh
chmod +x setup-existing.sh
```

#### 2. Run Setup Script (1-2 minutes)

```bash
./scripts/setup.sh
```

The script will ask:
- **Project name**: e.g., "My Awesome API"
- **Description**: Brief project description
- **Primary language**: python, javascript, go, or rust
- **Framework**: FastAPI, Express, Next.js, etc. (optional)
- **Use AI/LLM**: Yes/No
- **Database**: PostgreSQL, MongoDB, None, etc.

#### 3. Customize Memory Bank (5-15 minutes)

The setup creates `.memory_bank/` with templates. Review and customize:

```bash
# Essential customization
nano .memory_bank/product_brief.md      # Your business context
nano .memory_bank/tech_stack.md         # Your tech stack specifics
nano .memory_bank/current_tasks.md      # Your initial tasks

# Optional: Add project-specific patterns
nano .memory_bank/patterns/[your_pattern].md
nano .memory_bank/guides/[your_guide].md
```

#### 4. Install Custom Commands (1 minute)

Commands should be automatically installed to `~/.config/claude/commands/`. Verify:

```bash
ls ~/.config/claude/commands/
# Should show: m_bug.md, m_feature.md, m_review.md, m_self_review.md, refresh_context.md
```

#### 5. Start Using (Immediately!)

```bash
# In Claude Code
/refresh_context

# Your Memory Bank is loaded and ready!
# Now use workflows:
/m_feature "Add user authentication"
/m_bug "Fix login redirect issue"
/m_review
```

### Usage Patterns

#### For Solo Developers

1. **Planning**: Use Gemini with `repomix` for specs
2. **Execution**: Use Claude Code with Memory Bank
3. **Review**: Use Gemini for review checklist, Claude Code for self-review

#### For Teams

1. **Shared Memory Bank**: Single source of truth
2. **Consistent Patterns**: Everyone follows same standards
3. **Knowledge Accumulation**: Memory Bank grows with project
4. **Onboarding**: New members read Memory Bank

#### For Different Project Types

**Web Applications**:
- Use JavaScript/TypeScript template
- Customize for React/Vue/Angular
- Add frontend-specific patterns

**APIs/Backends**:
- Use Python/Go template
- Customize for FastAPI/Django/Express
- Add API-specific patterns

**Data Science/ML**:
- Use Python template
- Add ML-specific patterns
- Include experiment tracking guides

**CLI Tools**:
- Use Go/Rust template
- Add CLI-specific patterns
- Include distribution guides

---

## Reference Implementation: Due Diligence Bot

> **Note**: The sections below describe the reference implementation included in this template. When you use this template for your project, this content will be replaced with your project-specific information during setup.

### Overview

Due Diligence Bot automates the process of collecting, analyzing, and reporting information for investment decisions, business partnerships, and M&A due diligence. It combines web scraping, external API integrations, and AI-powered analysis to deliver structured reports in hours instead of days.

### Key Features

- **Automated Data Collection**: Aggregates information from registries, news sources, and financial databases
- **AI-Powered Analysis**: Uses GPT-4 and LangChain for intelligent data structuring
- **Structured Reporting**: Generates comprehensive PDF reports with findings and recommendations
- **Change Monitoring**: Tracks status changes in monitored entities
- **Interactive Interface**: Telegram bot for easy access and interaction

### Technology Stack

- **Backend**: Python 3.11+ with full type safety
- **Bot Framework**: aiogram (Telegram)
- **AI/LLM**: OpenAI GPT-4, LangChain
- **Database**: PostgreSQL (structured data), Redis (caching/queues)
- **Testing**: pytest, pytest-asyncio
- **Code Quality**: black, ruff, mypy

For complete tech stack details, see [.memory_bank/tech_stack.md](.memory_bank/tech_stack.md)

---

## AI SWE Methodology

This project uses the **AI SWE (Software Engineering) methodology** - a systematic approach to AI-assisted development that maintains context, enforces best practices, and ensures quality.

### Three-Phase Workflow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  PLANNING   │────▶│  EXECUTION   │────▶│   REVIEW    │
│  (Gemini)   │     │ (Claude Code)│     │  (Gemini +  │
│             │     │              │     │ Claude Code)│
└─────────────┘     └──────────────┘     └─────────────┘
```

1. **Planning (Gemini)**: Create detailed specifications with full project context (2M token window)
2. **Execution (Claude Code)**: Implement features following workflows and patterns from Memory Bank
3. **Review (Gemini + Claude Code)**: Validate implementation against spec with automated self-review

### Memory Bank Architecture

The **Memory Bank** (`.memory_bank/`) is the single source of truth for the project. Before any task, read:

1. [.memory_bank/README.md](.memory_bank/README.md) - Navigation hub
2. [.memory_bank/tech_stack.md](.memory_bank/tech_stack.md) - Technology decisions
3. [.memory_bank/current_tasks.md](.memory_bank/current_tasks.md) - Current work status

**Structure**:
- `guides/` - Development guides (coding standards, testing strategy)
- `patterns/` - Architectural patterns (API standards, error handling)
- `workflows/` - Task workflows (new feature, bug fix, code review, self-review, refactoring)
- `specs/` - Feature specifications

### Custom Commands

5 custom commands enforce systematic workflows:

- `/refresh_context` - Restore AI context when compressed
- `/m_bug [description]` - Fix bug following standardized workflow
- `/m_feature [description]` - Implement feature systematically
- `/m_review [files]` - Conduct comprehensive code review
- `/m_self_review [checklist]` - Self-validate against acceptance criteria

For detailed command documentation, see [COMMANDS_DOCUMENTATION.md](COMMANDS_DOCUMENTATION.md)

---

## Getting Started

### Prerequisites

- Python 3.11+
- Poetry (dependency management)
- PostgreSQL 14+
- Redis 7+
- Telegram Bot Token
- OpenAI API Key

### Installation

1. **Clone repository**:
   ```bash
   git clone <repository-url>
   cd due_diligence_bot
   ```

2. **Install dependencies**:
   ```bash
   poetry install
   ```

3. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your credentials:
   # - TELEGRAM_BOT_TOKEN
   # - OPENAI_API_KEY
   # - DATABASE_URL
   # - REDIS_URL
   ```

4. **Setup database**:
   ```bash
   poetry run alembic upgrade head
   ```

5. **Run bot**:
   ```bash
   poetry run python -m bot
   ```

### For Developers: AI SWE Setup

1. **Read Memory Bank**:
   ```bash
   cat .memory_bank/README.md
   ```

2. **Read Claude Code Configuration**:
   ```bash
   cat CLAUDE.md
   ```

3. **Verify Custom Commands**:
   ```bash
   ls ~/.config/claude/commands/
   # Should show: m_bug.md, m_feature.md, m_review.md, m_self_review.md, refresh_context.md
   ```

4. **Review Complete Setup**:
   See [AI_SWE_SETUP_VALIDATION.md](AI_SWE_SETUP_VALIDATION.md) for comprehensive validation report

---

## Development Workflow

### Starting a New Feature

1. **Planning Phase** (Gemini):
   ```bash
   # Package project context
   repomix
   # Upload to Gemini, request detailed specification
   # Save to .memory_bank/specs/feature-name.md
   ```

2. **Execution Phase** (Claude Code):
   ```
   /refresh_context
   /m_feature [Feature description]
   ```
   Claude Code reads spec, follows workflow, implements systematically

3. **Review Phase** (Gemini + Claude Code):
   ```
   # In Gemini: "Generate review checklist"

   # In Claude Code:
   /m_self_review
   [Paste checklist from Gemini]
   ```

### Fixing a Bug

```
/refresh_context
/m_bug [Bug description]
```

### Conducting Code Review

```
/m_review [optional: specific files]
```

For detailed workflows, see [.memory_bank/workflows/](.memory_bank/workflows/)

---

## Project Structure

```
due_diligence_bot/
├── .memory_bank/           # AI SWE Memory Bank (single source of truth)
│   ├── README.md          # Navigation hub
│   ├── product_brief.md   # Business context
│   ├── tech_stack.md      # Technology decisions
│   ├── current_tasks.md   # Task tracking
│   ├── guides/            # Development guides
│   ├── patterns/          # Architectural patterns
│   ├── workflows/         # Task workflows
│   └── specs/             # Feature specifications
│
├── bot/                   # Telegram bot handlers
├── core/                  # Business logic
├── integrations/          # External API integrations
├── data/                  # Data models and storage
├── reports/               # Report generation
├── tests/                 # Test suite
│
├── CLAUDE.md              # Claude Code configuration
├── COMMANDS_DOCUMENTATION.md  # Custom commands guide
├── IMPLEMENTATION_PLAN.md     # AI SWE setup plan
├── AI_SWE_SETUP_VALIDATION.md # Setup validation report
└── AI_SWE_article.md      # Original methodology article
```

---

## Git Workflow

### Branch Naming

- `feature/TICKET-NUM-description` - New features
- `bugfix/TICKET-NUM-description` - Bug fixes
- `hotfix/TICKET-NUM-description` - Urgent production fixes
- `docs/description` - Documentation updates

### Commit Messages

Following [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(module): add company financial analysis
fix(bot): handle timeout in API calls
docs(readme): update installation instructions
refactor(core): simplify error handling
test(integration): add tests for company service
```

### Workflow

1. Create branch from `main`
2. Implement following AI SWE methodology
3. Run tests and linters
4. Create PR with detailed description
5. Self-review with `/m_self_review`
6. Address review feedback
7. Merge when approved

---

## Testing

### Run Tests

```bash
# All tests
poetry run pytest

# With coverage
poetry run pytest --cov=. --cov-report=html

# Specific test file
poetry run pytest tests/test_bot.py

# Async tests
poetry run pytest -v tests/test_async.py
```

### Coverage Requirements

- Minimum 80% coverage for new code
- All public APIs must have tests
- Use AAA pattern (Arrange-Act-Assert)

See [.memory_bank/guides/testing_strategy.md](.memory_bank/guides/testing_strategy.md) for details

---

## Code Quality

### Before Committing

```bash
# Format code
poetry run black .

# Lint
poetry run ruff check .

# Type check
poetry run mypy .
```

### Standards

- Follow PEP 8
- Use type hints for all functions
- Maximum line length: 100 characters
- Use async/await for all I/O operations
- Document public APIs with docstrings (Google style)

See [.memory_bank/guides/coding_standards.md](.memory_bank/guides/coding_standards.md) for complete standards

---

## Documentation

### Key Documents

- **[.memory_bank/README.md](.memory_bank/README.md)** - Start here for any task
- **[CLAUDE.md](CLAUDE.md)** - Claude Code configuration and project context
- **[COMMANDS_DOCUMENTATION.md](COMMANDS_DOCUMENTATION.md)** - Custom commands reference
- **[AI_SWE_SETUP_VALIDATION.md](AI_SWE_SETUP_VALIDATION.md)** - Complete setup validation
- **[IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)** - AI SWE setup implementation plan
- **[AI_SWE_article.md](AI_SWE_article.md)** - Original methodology article

### Development Guides

- [Coding Standards](.memory_bank/guides/coding_standards.md)
- [Testing Strategy](.memory_bank/guides/testing_strategy.md)

### Architectural Patterns

- [API Standards](.memory_bank/patterns/api_standards.md)
- [Error Handling](.memory_bank/patterns/error_handling.md)

### Workflows

- [New Feature](.memory_bank/workflows/new_feature.md)
- [Bug Fix](.memory_bank/workflows/bug_fix.md)
- [Code Review](.memory_bank/workflows/code_review.md)
- [Self Review](.memory_bank/workflows/self_review.md)
- [Refactoring](.memory_bank/workflows/refactoring.md)

---

## Contributing

### For Team Members

1. **Always start with Memory Bank**:
   - Read `.memory_bank/README.md`
   - Follow the mandatory reading sequence
   - Check `current_tasks.md` for active work

2. **Use systematic workflows**:
   - Don't ad-hoc implement features
   - Use `/m_feature` or `/m_bug` commands
   - Follow the three-phase methodology

3. **Maintain Memory Bank**:
   - Update `tech_stack.md` when adding dependencies
   - Create guides for new subsystems
   - Document architectural decisions
   - Keep `current_tasks.md` current

### For External Contributors

1. Fork the repository
2. Create feature branch
3. Follow coding standards and testing requirements
4. Ensure all tests pass
5. Submit PR with detailed description

---

## License

[License Type] - See LICENSE file for details

---

## Contact

- **Project Lead**: [Name]
- **Technical Questions**: [Contact]
- **Bug Reports**: [GitHub Issues]

---

## Acknowledgments

This project implements the **AI SWE methodology** as described in the article:
- [Original Article](https://habr.com/ru/articles/934806/) (Russian)
- English Translation: [AI_SWE_article.md](AI_SWE_article.md)

### Tools Used

- **repomix** - Project context packaging
- **Claude Code** - AI-assisted development
- **Gemini** - Specification planning and review
- **Memory Bank** - Knowledge architecture

---

**Current Status**: Memory Bank setup complete, ready for development
**Last Updated**: 2025-10-19
**Setup Validation**: See [AI_SWE_SETUP_VALIDATION.md](AI_SWE_SETUP_VALIDATION.md)
