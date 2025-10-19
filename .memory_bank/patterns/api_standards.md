# API Standards

## Naming Conventions
- Endpoints используют lowercase с подчеркиваниями: `/api/company_check`, `/api/reports/generate`
- Resource-based URLs, не action-based
- Версионирование API в URL: `/api/v1/...`

## Request/Response Format
- Все requests/responses используют JSON
- Date formats: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)
- Все даты в UTC timezone

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

### Базовый класс для интеграций
Все интеграции с внешними API должны наследоваться от базового класса:

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
- Использовать экспоненциальный backoff для повторных попыток
- Максимум 3 попытки для временных ошибок (5xx, timeout)
- Не повторять для клиентских ошибок (4xx)

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
- API ключи передаются через заголовок `Authorization: Bearer {token}`
- Секреты хранятся в переменных окружения
- Использовать `python-dotenv` для локальной разработки

## Rate Limiting
- Реализовать rate limiting для защиты от abuse
- Использовать Redis для хранения счетчиков
- Стандартные лимиты:
  - 100 requests/minute для authenticated users
  - 10 requests/minute для anonymous users

## Data Validation
- Использовать Pydantic models для всех request/response
- Валидировать входные данные на уровне API endpoint
- Явно определять типы для всех полей

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
- Логировать все внешние API запросы
- Включать correlation ID для трассировки
- Не логировать sensitive данные (API keys, personal info)

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
- Использовать URL-based versioning: `/api/v1/`, `/api/v2/`
- Поддерживать минимум 2 версии одновременно
- Deprecate старые версии с предупреждением минимум за 3 месяца
