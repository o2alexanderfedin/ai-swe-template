# API Standards

## Naming Conventions
- Endpoints use lowercase with underscores: `/api/company_check`, `/api/reports/generate`
- Resource-based URLs, not action-based
- API versioning in URL: `/api/v1/...`

## Request/Response Format
- All requests/responses use JSON
- Date formats: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)
- All dates in UTC timezone

## Standard Response Structure

### Success Response
```json
{
  "success": true,
  "data": {
    // response payload
  },
  "meta": {
    "timestamp": "2024-10-19T12:00:00Z",
    "version": "v1"
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {
      "field": "additional context"
    }
  },
  "meta": {
    "timestamp": "2024-10-19T12:00:00Z",
    "version": "v1"
  }
}
```

## External API Integration Standards

### Base Class for Integrations
All integrations with external APIs must inherit from the base class:

```python
from abc import ABC, abstractmethod
from typing import Any, Dict, Optional
import httpx

class BaseAPIIntegration(ABC):
    """Base class for all external API integrations"""

    def __init__(self, api_key: Optional[str] = None, base_url: str = ""):
        self.api_key = api_key
        self.base_url = base_url
        self.client = httpx.AsyncClient(timeout=30.0)

    @abstractmethod
    async def fetch_data(self, query: str) -> Dict[str, Any]:
        """Fetch data from external API"""
        pass

    async def _make_request(
        self,
        method: str,
        endpoint: str,
        **kwargs
    ) -> Dict[str, Any]:
        """Make HTTP request with error handling"""
        # Implementation with retry logic
        pass

    async def close(self):
        """Close HTTP client"""
        await self.client.aclose()
```

### Retry Logic
- Use exponential backoff for retry attempts
- Maximum 3 attempts for transient errors (5xx, timeout)
- Do not retry for client errors (4xx)

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
async def fetch_with_retry(url: str) -> Dict[str, Any]:
    # implementation
    pass
```

## Authentication
- API keys are passed via the `Authorization: Bearer {token}` header
- Secrets are stored in environment variables
- Use `python-dotenv` for local development

## Rate Limiting
- Implement rate limiting to protect from abuse
- Use Redis for storing counters
- Standard limits:
  - 100 requests/minute for authenticated users
  - 10 requests/minute for anonymous users

## Data Validation
- Use Pydantic models for all request/response
- Validate input data at the API endpoint level
- Explicitly define types for all fields

```python
from pydantic import BaseModel, Field, validator

class CompanyCheckRequest(BaseModel):
    company_name: str = Field(..., min_length=1, max_length=200)
    inn: Optional[str] = Field(None, regex=r'^\d{10}|\d{12}$')

    @validator('company_name')
    def validate_company_name(cls, v):
        if not v.strip():
            raise ValueError('Company name cannot be empty')
        return v.strip()
```

## Logging Standards
- Log all external API requests
- Include correlation ID for tracing
- Do not log sensitive data (API keys, personal info)

```python
import logging

logger = logging.getLogger(__name__)

async def make_api_call(endpoint: str, correlation_id: str):
    logger.info(
        f"API call to {endpoint}",
        extra={
            "correlation_id": correlation_id,
            "endpoint": endpoint,
            "method": "GET"
        }
    )
```

## Versioning Strategy
- Use URL-based versioning: `/api/v1/`, `/api/v2/`
- Support at least 2 versions simultaneously
- Deprecate old versions with at least 3 months warning
