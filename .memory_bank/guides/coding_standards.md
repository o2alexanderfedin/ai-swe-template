# Coding Standards

## General Principles
- Code readability over cleverness
- Self-documenting code with minimal but meaningful comments
- Follow DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- TRIZ (Especially, minimal or zero changes to get the desired behavior)
- YAGNI (You Aren't Gonna Need It)
- Explicit is better than implicit (The Zen of Python)

## Python Style Guide (PEP 8+)

### Naming Conventions

#### Variables and Functions
- Use descriptive names: `get_company_profile()` not `getCP()`
- Snake_case for variables and functions: `company_name`, `fetch_data()`
- Boolean variables: `is_active`, `has_permission`, `can_access`
- Constants: `UPPER_SNAKE_CASE`: `MAX_RETRIES`, `API_TIMEOUT`

#### Classes
- PascalCase for class names: `CompanyChecker`, `ReportGenerator`
- Private methods start with underscore: `_internal_method()`
- Dunder methods for special Python methods: `__init__()`, `__str__()`

#### Files and Directories
- Modules: `snake_case.py`: `company_checker.py`, `data_processor.py`
- Packages: lowercase, no underscores if possible: `integrations/`, `reports/`
- Tests: `test_module_name.py`: `test_company_checker.py`

### Type Hints
**MANDATORY** to use type hints for all functions, methods and variables:

```python
from typing import Optional, List, Dict, Any

def fetch_company_data(
    company_name: str,
    include_financials: bool = False
) -> Optional[Dict[str, Any]]:
    """Fetch company data from registry"""
    pass

# Type hints for variables
companies: List[str] = []
config: Dict[str, Any] = {}
result: Optional[CompanyData] = None
```

### Docstrings (Google Style)

```python
def calculate_risk_score(
    company_data: Dict[str, Any],
    weights: Optional[Dict[str, float]] = None
) -> float:
    """Calculate risk score for a company.

    Args:
        company_data: Dictionary containing company information
        weights: Optional custom weights for risk factors.
            If None, default weights are used.

    Returns:
        Risk score between 0.0 and 1.0

    Raises:
        ValueError: If company_data is missing required fields
        DataProcessingError: If calculation fails

    Example:
        >>> data = {"revenue": 1000000, "debt": 500000}
        >>> score = calculate_risk_score(data)
        >>> print(f"Risk score: {score:.2f}")
    """
    pass
```

## Code Organization

### File Structure
Maximum file length: 500 lines. If longer — split into modules.

### Function Length
- Maximum function length: 50 lines
- If longer — decompose into smaller functions
- One function = one responsibility (Single Responsibility Principle)

### Class Organization
```python
class CompanyChecker:
    """Company verification service"""

    # Class variables
    DEFAULT_TIMEOUT = 30

    def __init__(self, api_key: str):
        """Initialize checker with API key"""
        # Instance variables
        self.api_key = api_key
        self._client = self._create_client()

    # Public methods
    async def check_company(self, name: str) -> CompanyData:
        """Public API method"""
        pass

    # Private methods (start with _)
    def _create_client(self) -> httpx.AsyncClient:
        """Create HTTP client"""
        pass

    # Special methods (dunder)
    def __repr__(self) -> str:
        return f"CompanyChecker(api_key='***')"
```

## Async/Await Best Practices

### Always Use Async for I/O
```python
# Good - async for I/O operations
async def fetch_data(url: str) -> Dict[str, Any]:
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()

# Bad - blocking I/O in async function
async def fetch_data_bad(url: str) -> Dict[str, Any]:
    response = requests.get(url)  # BLOCKS event loop!
    return response.json()
```

### Proper Resource Management
```python
# Good - using async context manager
async def process_file(filepath: str):
    async with aiofiles.open(filepath, 'r') as f:
        content = await f.read()
        return content

# Good - ensure cleanup
async def fetch_multiple(urls: List[str]):
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return responses
```

## Comments and Documentation

### When to Comment
```python
# Good - explaining WHY, not WHAT
def calculate_score(value: float) -> float:
    # We multiply by 0.8 because regulatory requirements
    # mandate a 20% safety margin (see RFC-2024-05)
    return value * 0.8

# Bad - stating the obvious
def add_numbers(a: int, b: int) -> int:
    # Add a and b together
    return a + b  # return the sum
```

### TODO Comments
```python
# TODO(username): Add caching for frequently requested companies
# FIXME(username): This breaks when company name contains special chars
# NOTE: This is a temporary workaround until API v2 is released
```

## Formatting

### Line Length
- Maximum line length: 100 characters
- Use Black formatter for consistent formatting
- Configure in `pyproject.toml`:

```toml
[tool.black]
line-length = 100
target-version = ['py311']
```

### Imports Organization
```python
# Standard library imports
import asyncio
import logging
from typing import Optional, Dict, Any

# Third-party imports
import httpx
from pydantic import BaseModel
from telegram import Update

# Local application imports
from core.models import CompanyData
from integrations.registry import RegistryClient
```

### String Formatting
```python
# Prefer f-strings
name = "Company"
message = f"Checking {name} status"

# For logging, use lazy formatting
logger.info("Processing company: %s", company_name)

# For SQL queries, use parameterized queries
query = "SELECT * FROM companies WHERE name = %s"
```

## Error Handling

### Be Specific with Exceptions
```python
# Good - specific exception handling
try:
    result = await fetch_data(url)
except httpx.HTTPStatusError as e:
    logger.error(f"HTTP error: {e.response.status_code}")
    raise ExternalAPIError(f"API returned {e.response.status_code}")
except httpx.TimeoutException:
    logger.error("Request timeout")
    raise ExternalAPIError("Request timeout")

# Bad - catching everything
try:
    result = await fetch_data(url)
except Exception:  # Too broad!
    pass  # Silently ignoring errors!
```

### Never Use Bare Except
```python
# NEVER do this
try:
    result = dangerous_operation()
except:  # Catches KeyboardInterrupt, SystemExit!
    pass

# Always specify exception type
try:
    result = dangerous_operation()
except ValueError as e:
    logger.error(f"Value error: {e}")
```

## Best Practices

### Pydantic Models for Data Validation
```python
from pydantic import BaseModel, Field, validator

class CompanyRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    inn: Optional[str] = Field(None, regex=r'^\d{10}|\d{12}$')

    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError('Company name cannot be empty')
        return v.strip()

    class Config:
        frozen = True  # Immutable
```

### Use Context Managers
```python
# Good
async with httpx.AsyncClient() as client:
    response = await client.get(url)

# Bad - resource leak risk
client = httpx.AsyncClient()
response = await client.get(url)
# What if exception happens? Client not closed!
```

### Prefer Composition Over Inheritance
```python
# Good - composition
class ReportGenerator:
    def __init__(self, data_fetcher: DataFetcher, formatter: Formatter):
        self.data_fetcher = data_fetcher
        self.formatter = formatter

# Avoid deep inheritance hierarchies
```

### Environment Variables
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    telegram_bot_token: str
    openai_api_key: str
    database_url: str

    class Config:
        env_file = '.env'

settings = Settings()
```

## Testing Considerations

### Write Testable Code
```python
# Good - easy to test
async def fetch_data(client: httpx.AsyncClient, url: str):
    response = await client.get(url)
    return response.json()

# Bad - hard to test (creates own client)
async def fetch_data_bad(url: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()
```

### Use Dependency Injection
```python
# Good - dependencies are explicit
class CompanyChecker:
    def __init__(self, api_client: APIClient, db: Database):
        self.api_client = api_client
        self.db = db

# Bad - hidden dependencies
class CompanyChecker:
    def __init__(self):
        self.api_client = APIClient()  # Hard to mock!
        self.db = Database()  # Hard to test!
```

## Code Review Checklist
- [ ] All functions have type hints
- [ ] Public functions have docstrings
- [ ] No overly long functions (>50 lines)
- [ ] No overly long files (>500 lines)
- [ ] Async/await used correctly for I/O
- [ ] No blocking operations in async code
- [ ] Proper exception handling
- [ ] No bare `except:` clauses
- [ ] No secrets in code
- [ ] Code formatted with Black
- [ ] Imports organized correctly
- [ ] Tests written for new functionality
