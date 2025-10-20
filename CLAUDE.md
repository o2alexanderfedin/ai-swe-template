# Claude Code Configuration for {{PROJECT_NAME}}

## At the Start of ANY Work Session

**MANDATORY** perform the following actions:

1. Read the **`.memory_bank/README.md`** file completely.
2. Follow the mandatory reading sequence instructions from this file:
   - **[Tech Stack](.memory_bank/tech_stack.md)**: Learn which technologies, libraries and versions we use
   - **[Coding Standards](.memory_bank/guides/coding_standards.md)**: Formatting rules, naming conventions and best practices
   - **[Current Tasks](.memory_bank/current_tasks.md)**: List of active tasks and current team focus
3. Follow links to relevant documents depending on task type:
   - For new features → study specification in `.memory_bank/specs/`
   - For bugs → study workflow `.memory_bank/workflows/bug_fix.md`
   - For technology questions → check `.memory_bank/tech_stack.md`

---

## About the Project: {{PROJECT_NAME}}

**{{PROJECT_NAME}}** - {{PROJECT_DESC}}

### Key Project Features:

#### 1. {{LANGUAGE}} Architecture
- Using **{{LANGUAGE}}** with full type annotations
- **Framework**: {{FRAMEWORK}}
- **Asynchronous architecture**: all I/O operations via async/await
- Command and callback query handlers in `bot/` module (or main application logic)

#### 2. AI/LLM Integration (if applicable)
- **OpenAI API (GPT-4)** for analysis and report generation
- **LangChain** for orchestrating AI agents
- All LLM calls must be wrapped in retry mechanisms
- Use structured outputs for parsing LLM responses

#### 3. Async/Await Patterns
**CRITICALLY IMPORTANT:**
- All I/O operations (HTTP requests, database queries, file operations) MUST be asynchronous
- Use `async def` and `await` for all functions with I/O
- For HTTP requests use **httpx**, NOT requests
- For database queries use async drivers (asyncpg for PostgreSQL)
- **FORBIDDEN** to block event loop with synchronous calls

Correct approach example:
```python
import httpx
from typing import Dict, Any

async def fetch_company_data(company_id: str) -> Dict[str, Any]:
    """Asynchronously load company data."""
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/companies/{company_id}")
        response.raise_for_status()
        return response.json()
```

#### 4. External API Integrations
All external integrations must:
- Be located in `integrations/` module
- Have clear interface (Pydantic models for request/response)
- Include error handling according to `.memory_bank/patterns/error_handling.md`
- Use retry mechanisms for unstable APIs
- Have fallback strategies when service is unavailable
- Log all requests for debugging

Integration structure example:
```python
# integrations/company_registry.py
from typing import Optional
from pydantic import BaseModel
import httpx

class CompanyInfo(BaseModel):
    """Company data model."""
    name: str
    inn: str
    registration_date: str
    status: str

class CompanyRegistryClient:
    """Client for working with company registry."""

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.example.com"

    async def get_company(self, inn: str) -> Optional[CompanyInfo]:
        """Get company information by INN."""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{self.base_url}/companies/{inn}",
                headers={"Authorization": f"Bearer {self.api_key}"}
            )
            if response.status_code == 404:
                return None
            response.raise_for_status()
            return CompanyInfo(**response.json())
```

#### 5. Application-Specific Patterns
**When working with the application:**
- Use handlers for commands (`/start`, `/help`, `/check`) if applicable
- Use callback_query handlers for inline buttons (Telegram bots)
- Use FSM (Finite State Machine) for complex dialogs if applicable
- Handle errors gracefully - always send understandable message to user
- Use typing indicators (`send_chat_action`) for long operations if applicable
- Limit message size (Telegram limit: 4096 characters) if applicable

Handler example:
```python
from aiogram import Router, types
from aiogram.filters import Command

router = Router()

@router.message(Command("check"))
async def handle_check_command(message: types.Message) -> None:
    """Handler for /check command to start verification."""
    await message.answer("Sending verification request...")
    # Processing logic
```

#### 6. Data Processing & Storage
- **PostgreSQL** for storing structured data (companies, reports, users)
- **Redis** for caching and task queues
- All database models must be in `data/models.py`
- Use migrations (Alembic) for database schema changes
- Data validation via Pydantic before saving

---

## Self-Documentation Principle

**IMPORTANT**: You not only read from Memory Bank, but also **update it**.

When performing tasks you MUST:
- Update status in `.memory_bank/current_tasks.md` (To Do → In Progress → Done)
- Create/update documentation in `.memory_bank/guides/` when implementing new subsystems
- Update `.memory_bank/tech_stack.md` when adding new dependencies
- Create new patterns in `.memory_bank/patterns/` when making architectural decisions
- Add specifications in `.memory_bank/specs/` for new features

---

## Workflow Selection: Choosing the Right Process

Before starting any task, determine its type and choose the corresponding workflow:

### 1. New Feature
**When to use**: Adding new capability to the bot
**Workflow**: `.memory_bank/workflows/new_feature.md`
**Examples**:
- Adding new bot command
- Integration with new external API
- Creating new report type

### 2. Bug Fix
**When to use**: Something doesn't work as expected
**Workflow**: `.memory_bank/workflows/bug_fix.md`
**Examples**:
- Bot doesn't respond to command
- Error in data processing
- Incorrect logic in existing function

### 3. Code Review
**When to use**: Quality check before merge
**Workflow**: `.memory_bank/workflows/code_review.md`
**What to check**:
- Compliance with coding standards
- Correct async/await usage
- Error handling
- Type hints
- Tests

---

## Forbidden Actions

**NEVER** do the following:

1. **Don't add new dependencies** without updating `.memory_bank/tech_stack.md`
2. **Don't violate patterns** from `.memory_bank/patterns/`
3. **Don't reinvent** what already exists in the project
4. **Don't use `Any`** in type hints - always specify concrete types
5. **Don't do synchronous I/O** in asynchronous code
6. **Don't store secrets** in code - only via environment variables
7. **Don't write SQL manually** - use ORM or parameterized queries
8. **Don't ignore errors** through empty `except` blocks

---

## Mandatory Checks Before Starting Work

Before writing code ALWAYS check:

1. **Tech Stack** (`.memory_bank/tech_stack.md`):
   - Which libraries are allowed for this task?
   - Which practices are forbidden?

2. **Existing Components**:
   - Does this functionality already exist?
   - Which modules can be reused?

3. **Patterns** (`.memory_bank/patterns/`):
   - How to properly handle errors in this project?
   - Which API standards to use?

4. **Current Tasks** (`.memory_bank/current_tasks.md`):
   - Does my task conflict with others?
   - Need to update status?

---

## When Context is Lost

If you feel context was lost or compressed:

1. Use `/refresh_context` command (if available)
2. Re-read `.memory_bank/README.md`
3. Study recent commits to understand current state:
   ```bash
   git log --oneline -10
   ```
4. Check current project status:
   ```bash
   git status
   ```

---

## Type Safety Requirements

All functions MUST have complete type hints:

```python
from typing import Dict, List, Optional, Any
from pydantic import BaseModel

# CORRECT
async def process_company(
    company_id: str,
    include_details: bool = False
) -> Dict[str, Any]:
    """Process company data."""
    ...

# INCORRECT (missing type hints)
async def process_company(company_id, include_details=False):
    ...
```

---

## Testing Requirements

For each new function you MUST:
1. Write unit tests in `tests/`
2. Use `pytest` and `pytest-asyncio`
3. Minimum 80% code coverage
4. Test edge cases and error handling

Test example:
```python
import pytest
from unittest.mock import AsyncMock

@pytest.mark.asyncio
async def test_fetch_company_data():
    """Test fetching company data."""
    # Arrange
    company_id = "test_123"

    # Act
    result = await fetch_company_data(company_id)

    # Assert
    assert result is not None
    assert "name" in result
```

---

## Error Handling Requirements

All external calls must have error handling:

```python
import logging
from typing import Optional

logger = logging.getLogger(__name__)

async def safe_api_call(url: str) -> Optional[dict]:
    """Safe external API call."""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, timeout=10.0)
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as e:
        logger.error(f"HTTP error calling {url}: {e}")
        return None
    except Exception as e:
        logger.exception(f"Unexpected error calling {url}: {e}")
        return None
```

---

## Logging Standards

- Use `logging` module, NOT `print()`
- Logging levels:
  - `DEBUG`: Detailed information for debugging
  - `INFO`: General information about operation
  - `WARNING`: Warnings (something wrong but works)
  - `ERROR`: Errors (functionality broken)
  - `CRITICAL`: Critical errors (system cannot work)
- Always include context in log messages

```python
logger.info(f"Processing company {company_id}, user {user_id}")
logger.error(f"Failed to fetch data for {company_id}: {error}")
```

---

## Environment Configuration

All configuration parameters must be in `.env` file:

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings."""
    telegram_bot_token: str
    openai_api_key: str
    database_url: str
    redis_url: str

    class Config:
        env_file = ".env"

settings = Settings()
```

**NEVER** commit `.env` file to git!

---

## Git Workflow

1. **Branch Naming**:
   - `feature/add-company-search` - new feature
   - `bugfix/fix-telegram-handler` - bug fix
   - `docs/update-readme` - documentation

2. **Commit Messages** (Conventional Commits):
   - `feat: add company search endpoint`
   - `fix: handle timeout in API calls`
   - `docs: update API documentation`
   - `refactor: simplify error handling`
   - `test: add tests for company service`

3. **Before Committing**:
   - Run tests: `pytest`
   - Check formatting: `black .`
   - Check types: `mypy .`
   - Check linting: `ruff check .`

---

## Performance Considerations

1. **Use connection pooling** for database and HTTP clients
2. **Cache** frequent requests in Redis
3. **Use batch operations** where possible
4. **Limit concurrent requests** to external APIs
5. **Use indices** in database queries

---

**Remember**: Memory Bank is the single source of truth. Trust it more than your assumptions.

**Main Principle**: If unsure - ask the user or re-read documentation in Memory Bank.
