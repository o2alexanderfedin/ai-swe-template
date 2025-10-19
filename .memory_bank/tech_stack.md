# Technology Stack and Conventions

## Core Stack
- **Backend Framework**: Python 3.11+ (modern, type-safe approach)
- **Bot Framework**: Python Telegram Bot / aiogram (for Telegram integration)
- **AI/LLM Integration**:
  - OpenAI API (GPT-4) for analysis and report generation
  - LangChain for AI agent orchestration
- **Database**:
  - PostgreSQL for structured data storage
  - Redis for caching and task queues
- **Web Scraping**:
  - BeautifulSoup4 / lxml for parsing
  - Selenium for dynamic pages
- **API Integration**:
  - httpx for asynchronous HTTP requests
  - pydantic for data validation

## Development Tools
- **Dependency Management**: Poetry
- **Code Quality**:
  - black (formatting)
  - ruff (linting)
  - mypy (type checking)
- **Testing**:
  - pytest for unit and integration tests
  - pytest-asyncio for asynchronous tests
- **Environment**: python-dotenv for configuration management

## Project Structure
```
due_diligence_bot/
├── bot/              # Telegram bot handlers
├── core/             # Business logic
├── integrations/     # External API integrations
├── data/             # Data processing and storage
├── reports/          # Report generation
└── tests/            # Test suite
```

## Prohibited Practices
- Using `Any` in type hints. All types must be explicitly defined
- Synchronous I/O operations in asynchronous code (blocking event loop)
- Storing secrets and API keys in code (use .env files)
- Direct SQL queries without parameterization (SQL injection risk)
- Ignoring errors through `pass` or empty `except` blocks

## API Conventions
- All external API requests must go through modules in `integrations/`
- Error handling must follow the scheme described in **[./patterns/error_handling.md](./patterns/error_handling.md)**
- All API responses must be wrapped in Pydantic models for validation
- Use retry mechanisms for unstable external APIs

## Coding Standards
- Use async/await for all I/O operations
- Follow PEP 8 for code style
- Maximum line length: 100 characters
- Use type hints for all functions and methods
- Document public API through docstrings (Google style)

## Environment Variables
Mandatory environment variables:
- `TELEGRAM_BOT_TOKEN` - Telegram bot token
- `OPENAI_API_KEY` - OpenAI API key
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string

## Version Control
- Use semantic versioning (MAJOR.MINOR.PATCH)
- Conventional Commits for commit messages
- Branch naming: `feature/`, `bugfix/`, `hotfix/`, `docs/`
