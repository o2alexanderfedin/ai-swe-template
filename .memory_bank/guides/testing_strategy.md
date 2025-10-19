# Testing Strategy

## Testing Pyramid

Our testing strategy follows the classic testing pyramid:

1. **Unit Tests (70%)**: Testing individual functions and classes
2. **Integration Tests (20%)**: Testing interactions between modules
3. **End-to-End Tests (10%)**: Testing complete user scenarios

## Unit Testing Requirements

### Coverage Goals
- Minimum code coverage: **80%**
- Critical modules (payment processing, security): **95%+**
- Utilities and helpers: **90%+**

### Test File Naming
```
module_name.py → test_module_name.py
company_checker.py → test_company_checker.py
```

### Test Structure (AAA Pattern)

All tests should follow the **Arrange-Act-Assert** pattern:

```python
import pytest
from unittest.mock import Mock, AsyncMock
from company_checker import CompanyChecker

@pytest.mark.asyncio
async def test_check_company_success():
    # Arrange - setup test data and mocks
    mock_client = AsyncMock()
    mock_client.get.return_value = Mock(
        status_code=200,
        json=lambda: {"name": "Test Company", "inn": "1234567890"}
    )
    checker = CompanyChecker(api_client=mock_client)

    # Act - execute the action being tested
    result = await checker.check_company("Test Company")

    # Assert - verify the results
    assert result.name == "Test Company"
    assert result.inn == "1234567890"
    mock_client.get.assert_called_once()
```

## Testing Async Code

### Use pytest-asyncio
```python
import pytest

# Mark test as async
@pytest.mark.asyncio
async def test_async_function():
    result = await fetch_data("https://example.com")
    assert result is not None

# Async fixtures
@pytest.fixture
async def async_client():
    client = httpx.AsyncClient()
    yield client
    await client.aclose()
```

### Mocking Async Functions
```python
from unittest.mock import AsyncMock, patch

@pytest.mark.asyncio
async def test_with_async_mock():
    # Mock async function
    mock_fetch = AsyncMock(return_value={"data": "test"})

    with patch('module.fetch_data', mock_fetch):
        result = await process_data()
        assert result == {"data": "test"}
```

## Mocking Strategy

### External Dependencies Must Be Mocked
- Mock all external API calls
- Mock database operations
- Mock file system operations
- Mock time-dependent functions

```python
import pytest
from unittest.mock import Mock, patch
import httpx

@pytest.mark.asyncio
async def test_external_api_call():
    # Mock httpx.AsyncClient
    with patch('httpx.AsyncClient') as mock_client_class:
        mock_client = AsyncMock()
        mock_response = Mock()
        mock_response.json.return_value = {"status": "ok"}
        mock_client.get.return_value = mock_response
        mock_client_class.return_value.__aenter__.return_value = mock_client

        result = await fetch_external_data("test")
        assert result["status"] == "ok"
```

### Use Fixtures for Common Test Data
```python
import pytest

@pytest.fixture
def sample_company_data():
    """Provide sample company data for tests"""
    return {
        "name": "Test Company LLC",
        "inn": "1234567890",
        "registration_date": "2020-01-01"
    }

@pytest.fixture
def mock_database(monkeypatch):
    """Mock database connection"""
    mock_db = Mock()
    monkeypatch.setattr("app.database.get_db", lambda: mock_db)
    return mock_db

def test_save_company(sample_company_data, mock_database):
    save_company(sample_company_data)
    mock_database.insert.assert_called_once()
```

## Integration Testing

### Database Integration Tests
```python
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

@pytest.fixture(scope="module")
def test_db():
    """Create test database"""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()

def test_company_crud(test_db):
    # Test create, read, update, delete operations
    company = Company(name="Test", inn="1234567890")
    test_db.add(company)
    test_db.commit()

    retrieved = test_db.query(Company).filter_by(inn="1234567890").first()
    assert retrieved.name == "Test"
```

### API Integration Tests
```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_api_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post(
            "/api/v1/check_company",
            json={"name": "Test Company"}
        )
        assert response.status_code == 200
        assert "data" in response.json()
```

## Test Data Management

### Factories for Test Data
```python
from factory import Factory, Faker

class CompanyFactory(Factory):
    class Meta:
        model = Company

    name = Faker('company')
    inn = Faker('numerify', text='##########')
    registration_date = Faker('date')

# Usage in tests
def test_company_processing():
    company = CompanyFactory.create()
    result = process_company(company)
    assert result is not None
```

### Never Use Production Data in Tests
```python
# Bad - using production data
def test_check_company():
    result = check_company("Real Company Inc")  # NO!

# Good - using test data
def test_check_company():
    result = check_company("Test Company LLC")  # YES!
```

## Error Case Testing

### Test Both Success and Failure Cases
```python
@pytest.mark.asyncio
async def test_fetch_data_success():
    """Test successful data fetch"""
    result = await fetch_data("valid_id")
    assert result is not None

@pytest.mark.asyncio
async def test_fetch_data_not_found():
    """Test handling of not found error"""
    with pytest.raises(DataNotFoundError):
        await fetch_data("invalid_id")

@pytest.mark.asyncio
async def test_fetch_data_timeout():
    """Test handling of timeout"""
    with patch('httpx.AsyncClient.get', side_effect=httpx.TimeoutException):
        with pytest.raises(ExternalAPIError):
            await fetch_data("test_id")
```

### Parametrized Tests
```python
@pytest.mark.parametrize("inn,expected", [
    ("1234567890", True),   # Valid 10-digit INN
    ("123456789012", True), # Valid 12-digit INN
    ("123", False),         # Too short
    ("abc1234567", False),  # Contains letters
])
def test_inn_validation(inn, expected):
    result = validate_inn(inn)
    assert result == expected
```

## Running Tests

### Test Commands
```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_company_checker.py

# Run specific test
pytest tests/test_company_checker.py::test_check_company_success

# Run only unit tests
pytest -m unit

# Run only integration tests
pytest -m integration

# Run in parallel (faster)
pytest -n auto
```

### Test Markers
```python
import pytest

@pytest.mark.unit
def test_unit_function():
    pass

@pytest.mark.integration
@pytest.mark.asyncio
async def test_integration_function():
    pass

@pytest.mark.slow
def test_slow_operation():
    pass

# Skip test conditionally
@pytest.mark.skipif(sys.version_info < (3, 11), reason="Requires Python 3.11+")
def test_new_feature():
    pass
```

## Coverage Requirements

### Coverage Configuration
```ini
# .coveragerc or pyproject.toml
[tool.coverage.run]
source = ["app"]
omit = [
    "*/tests/*",
    "*/migrations/*",
    "*/__init__.py"
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]
```

### Coverage Goals by Module
- `core/`: 90%+
- `integrations/`: 85%+
- `bot/`: 80%+
- `data/`: 85%+
- `reports/`: 80%+

## Performance Testing

### Basic Performance Tests
```python
import time
import pytest

@pytest.mark.performance
def test_function_performance():
    start = time.time()
    result = expensive_operation()
    duration = time.time() - start

    assert duration < 1.0  # Should complete in under 1 second
    assert result is not None
```

## Testing Best Practices

### Do's
- Write tests before or alongside code (TDD/BDD)
- Keep tests independent (no shared state)
- Use descriptive test names: `test_check_company_returns_none_when_not_found`
- Test edge cases and boundary conditions
- Mock external dependencies
- Use fixtures for setup/teardown

### Don'ts
- Don't test implementation details, test behavior
- Don't write tests that depend on other tests
- Don't use sleep() for timing (use mocking)
- Don't skip tests without good reason
- Don't ignore failing tests
- Don't test third-party libraries (trust them)

## Continuous Integration

### Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest
        language: system
        pass_filenames: false
        always_run: true
```

### CI Pipeline Requirements
- All tests must pass before merge
- Coverage must not decrease
- No failing tests allowed in main branch
- Integration tests run on staging environment

## Test Documentation

### Example Test Module Structure
```python
"""
Tests for company checker module.

This module contains unit and integration tests for the CompanyChecker class.
Tests cover:
- Successful company lookup
- Handling of invalid input
- Error cases (API failures, timeouts)
- Edge cases (special characters, etc.)
"""

import pytest
from unittest.mock import AsyncMock
from app.company_checker import CompanyChecker

class TestCompanyChecker:
    """Test suite for CompanyChecker class"""

    @pytest.fixture
    async def checker(self):
        """Provide configured CompanyChecker instance"""
        return CompanyChecker(api_key="test_key")

    @pytest.mark.asyncio
    async def test_check_company_success(self, checker):
        """Test successful company verification"""
        # Test implementation
        pass

    @pytest.mark.asyncio
    async def test_check_company_not_found(self, checker):
        """Test handling when company is not found"""
        # Test implementation
        pass
```

## Debugging Failed Tests

### Useful pytest Options
```bash
# Show print statements
pytest -s

# Stop on first failure
pytest -x

# Show local variables on failure
pytest -l

# Verbose output
pytest -v

# Show slowest tests
pytest --durations=10
```

## Summary Checklist

Before committing code, ensure:
- [ ] All new code has tests
- [ ] All tests pass locally
- [ ] Coverage meets minimum requirements (80%)
- [ ] No skipped tests without justification
- [ ] Tests follow AAA pattern
- [ ] External dependencies are mocked
- [ ] Test names are descriptive
- [ ] Both success and error cases tested
