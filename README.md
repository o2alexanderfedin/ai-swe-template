# Due Diligence Bot

An intelligent Telegram bot for automated comprehensive company and project verification (due diligence), powered by AI and implementing the AI SWE (Software Engineering) methodology.

## Overview

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
