# Error Handling Patterns

## Philosophy
- Fail fast and explicitly
- Always log errors with context
- User-facing errors should be actionable
- Never expose internal implementation details to users
- Use structured error responses

## Error Categories

### 1. Validation Errors (4xx)
User input issues, bad requests

### 2. System Errors (5xx)
Internal failures, service unavailable

### 3. Business Logic Errors
Rule violations, quota exceeded

### 4. External Integration Errors
Third-party API failures, timeout errors

## Implementation Pattern

### Base Exception Hierarchy

```python
class DueDiligenceBotError(Exception):
    """Base exception class for all application errors"""

    def __init__(
        self,
        message: str,
        code: str,
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.code = code
        self.details = details or {}
        super().__init__(self.message)


class ValidationError(DueDiligenceBotError):
    """Raised when input validation fails"""

    def __init__(self, message: str, field: Optional[str] = None):
        super().__init__(
            message=message,
            code="VALIDATION_ERROR",
            details={"field": field} if field else {}
        )


class ExternalAPIError(DueDiligenceBotError):
    """Raised when external API call fails"""

    def __init__(
        self,
        message: str,
        service: str,
        original_error: Optional[Exception] = None
    ):
        super().__init__(
            message=message,
            code="EXTERNAL_API_ERROR",
            details={
                "service": service,
                "original_error": str(original_error) if original_error else None
            }
        )


class DataProcessingError(DueDiligenceBotError):
    """Raised when data processing fails"""

    def __init__(self, message: str, data_type: Optional[str] = None):
        super().__init__(
            message=message,
            code="DATA_PROCESSING_ERROR",
            details={"data_type": data_type} if data_type else {}
        )


class RateLimitError(DueDiligenceBotError):
    """Raised when rate limit is exceeded"""

    def __init__(self, retry_after: Optional[int] = None):
        super().__init__(
            message="Rate limit exceeded. Please try again later.",
            code="RATE_LIMIT_EXCEEDED",
            details={"retry_after": retry_after} if retry_after else {}
        )
```

## Error Handling in Async Functions

### Standard Pattern
```python
import logging
from typing import Optional

logger = logging.getLogger(__name__)

async def fetch_company_data(
    company_name: str,
    correlation_id: str
) -> Optional[Dict[str, Any]]:
    """
    Fetch company data from external source.

    Args:
        company_name: Name of the company to check
        correlation_id: Request correlation ID for tracking

    Returns:
        Company data dict or None if not found

    Raises:
        ExternalAPIError: If API call fails
        ValidationError: If input is invalid
    """
    try:
        if not company_name.strip():
            raise ValidationError(
                message="Company name cannot be empty",
                field="company_name"
            )

        # Make API call
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"https://api.example.com/companies/{company_name}"
            )
            response.raise_for_status()
            return response.json()

    except httpx.HTTPStatusError as e:
        logger.error(
            f"HTTP error fetching company data",
            extra={
                "correlation_id": correlation_id,
                "company_name": company_name,
                "status_code": e.response.status_code,
                "error": str(e)
            }
        )
        raise ExternalAPIError(
            message=f"Failed to fetch company data",
            service="company_registry",
            original_error=e
        )

    except httpx.TimeoutException as e:
        logger.error(
            f"Timeout fetching company data",
            extra={
                "correlation_id": correlation_id,
                "company_name": company_name,
                "error": str(e)
            }
        )
        raise ExternalAPIError(
            message="Request timeout while fetching company data",
            service="company_registry",
            original_error=e
        )

    except Exception as e:
        logger.exception(
            f"Unexpected error fetching company data",
            extra={
                "correlation_id": correlation_id,
                "company_name": company_name
            }
        )
        raise
```

## Error Handling in Telegram Bot Handlers

### Pattern for Bot Handlers
```python
from telegram import Update
from telegram.ext import ContextTypes

async def handle_company_check(
    update: Update,
    context: ContextTypes.DEFAULT_TYPE
) -> None:
    """Handle company check command"""
    correlation_id = str(uuid.uuid4())

    try:
        company_name = " ".join(context.args)

        if not company_name:
            await update.message.reply_text(
                "Please specify the company name.\n"
                "Example: /check LLC Romashka"
            )
            return

        # Process request
        result = await fetch_company_data(company_name, correlation_id)

        await update.message.reply_text(
            f"Check results:\n{format_company_data(result)}"
        )

    except ValidationError as e:
        logger.warning(
            f"Validation error in company check",
            extra={"correlation_id": correlation_id, "error": str(e)}
        )
        await update.message.reply_text(
            f"Validation error: {e.message}"
        )

    except ExternalAPIError as e:
        logger.error(
            f"External API error in company check",
            extra={"correlation_id": correlation_id, "error": str(e)}
        )
        await update.message.reply_text(
            "Sorry, an error occurred while fetching data. "
            "Please try again later."
        )

    except RateLimitError as e:
        logger.warning(
            f"Rate limit exceeded",
            extra={"correlation_id": correlation_id}
        )
        await update.message.reply_text(
            "Rate limit exceeded. "
            f"Try again in {e.details.get('retry_after', 60)} seconds."
        )

    except Exception as e:
        logger.exception(
            f"Unexpected error in company check",
            extra={"correlation_id": correlation_id}
        )
        await update.message.reply_text(
            "An unexpected error occurred. "
            "Our team has been notified and is working on a solution."
        )
```

## Logging Standards

### Log Levels
- `DEBUG`: Detailed information for debugging
- `INFO`: General informational messages
- `WARNING`: Warning messages (non-critical issues)
- `ERROR`: Error messages (handled exceptions)
- `CRITICAL`: Critical errors (system failures)

### Structured Logging
Always include:
- `correlation_id`: Request tracking ID
- `user_id`: User identifier (if applicable)
- `action`: Action being performed
- Context-specific data

### What NOT to Log
- API keys, tokens, passwords
- Personal identifiable information (PII) unless necessary
- Full stack traces in production (use error tracking service)

```python
# Good logging
logger.info(
    "Company check initiated",
    extra={
        "correlation_id": correlation_id,
        "company_name": company_name,
        "user_id": user_id
    }
)

# Bad logging - exposes sensitive data
logger.info(f"API call with key: {api_key}")  # NEVER DO THIS
```

## Error Recovery Strategies

### Retry with Exponential Backoff
For transient errors (network issues, temporary API unavailability):

```python
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

@retry(
    retry=retry_if_exception_type(httpx.TimeoutException),
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
async def fetch_with_retry(url: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        response.raise_for_status()
        return response.json()
```

### Circuit Breaker Pattern
For preventing cascading failures:

```python
# Use library like 'pybreaker' for circuit breaker implementation
from pybreaker import CircuitBreaker

api_breaker = CircuitBreaker(
    fail_max=5,
    timeout_duration=60
)

@api_breaker
async def call_external_api():
    # API call implementation
    pass
```

## Error Monitoring
- Use Sentry or similar service for error tracking
- Set up alerts for critical errors
- Monitor error rates and patterns
- Create dashboards for error metrics
