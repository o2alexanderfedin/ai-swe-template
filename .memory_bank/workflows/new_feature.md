# New Feature Development Process

## 1. Preparation and Planning

### 1.1 Git Branch Setup
- [ ] Create a branch from `develop` following the template `feature/TICKET-NUMBER-short-description`
  - Example: `feature/DD-45-company-financial-analysis`
  - Follow the convention from **[../tech_stack.md](../tech_stack.md#version-control)**

### 1.2 Task Tracking
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "In Progress"
- [ ] Add `[FEATURE]` label to the task

### 1.3 Read Specification
- [ ] Read the full specification in **[../specs/](../specs/)** to understand the scope of work
- [ ] Ensure the following are clear:
  - Business goals of the feature (WHY)
  - Acceptance criteria
  - API contracts (if applicable)
  - Data structures
  - Dependencies on other components
- [ ] Ask clarifying questions if anything is unclear

### 1.4 Study Context
- [ ] Study **[coding standards](../guides/coding_standards.md)**
- [ ] Study **[architectural patterns](../patterns/)** relevant to the feature
- [ ] Study **[testing strategy](../guides/testing_strategy.md)**
- [ ] Check **[../product_brief.md](../product_brief.md)** to understand business context

## 2. Analysis and Design

### 2.1 Identify Existing Components
- [ ] Find existing components to reuse:
  - Pydantic models in `core/models/`
  - API clients in `integrations/`
  - Utility functions
  - Database models
- [ ] Check **[../tech_stack.md](../tech_stack.md)** for the list of available libraries
- [ ] Ensure no duplication of existing functionality

### 2.2 Technology Check
- [ ] Verify that all necessary technologies are approved in **[../tech_stack.md](../tech_stack.md)**
- [ ] If a new dependency is needed:
  - Justify the necessity
  - Check compatibility with existing stack
  - Get approval for addition
  - **MUST** update **[../tech_stack.md](../tech_stack.md)**

### 2.3 Design Plan
- [ ] Create a list of files to create/modify:
  - Models (Pydantic schemas)
  - Business logic (core/)
  - API integrations (integrations/)
  - Bot handlers (bot/)
  - Database migrations (if needed)
  - Tests
- [ ] Define the public API of new modules
- [ ] Design data structures
- [ ] Define error handling strategy for the feature

## 3. Development

### 3.1 Data Models
- [ ] Create/update Pydantic models for data validation
- [ ] Follow patterns from **[../guides/coding_standards.md](../guides/coding_standards.md#pydantic-models-for-data-validation)**
- [ ] Add validators for business rules
- [ ] Use type hints for all fields
- [ ] Example structure:
  ```python
  from pydantic import BaseModel, Field, validator

  class CompanyFinancialData(BaseModel):
      company_name: str = Field(..., min_length=1)
      revenue: Optional[Decimal] = None
      profit: Optional[Decimal] = None

      @validator('revenue', 'profit')
      def validate_positive(cls, v):
          if v is not None and v < 0:
              raise ValueError('Must be non-negative')
          return v
  ```

### 3.2 Business Logic Implementation
- [ ] Implement core business logic according to specification
- [ ] Follow **[architectural patterns](../patterns/)**
- [ ] Use async/await for all I/O operations
- [ ] Add proper error handling according to **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Reuse existing utilities and components
- [ ] Maximum function length: 50 lines (if longer - decompose)

### 3.3 External API Integration (if applicable)
- [ ] Create client class in `integrations/`
- [ ] Use `httpx.AsyncClient` for async HTTP requests
- [ ] Wrap all responses in Pydantic models
- [ ] Follow **[../patterns/api_standards.md](../patterns/api_standards.md)**
- [ ] Add retry logic for transient errors
- [ ] Add circuit breaker to prevent cascading failures
- [ ] Example structure:
  ```python
  from tenacity import retry, stop_after_attempt, wait_exponential

  class FinancialDataClient:
      def __init__(self, api_key: str):
          self.api_key = api_key
          self._client = httpx.AsyncClient()

      @retry(stop=stop_after_attempt(3), wait=wait_exponential())
      async def get_company_financials(self, inn: str) -> CompanyFinancialData:
          try:
              response = await self._client.get(
                  f"{self.base_url}/companies/{inn}/financials",
                  headers={"Authorization": f"Bearer {self.api_key}"}
              )
              response.raise_for_status()
              return CompanyFinancialData(**response.json())
          except httpx.HTTPStatusError as e:
              raise ExternalAPIError(
                  message="Failed to fetch financial data",
                  service="financial_api",
                  original_error=e
              )
  ```

### 3.4 Telegram Bot Handlers (if applicable)
- [ ] Create/update handlers in `bot/`
- [ ] Use async handlers
- [ ] Add proper error handling for user-facing errors
- [ ] All messages in Russian
- [ ] Generate `correlation_id` for tracing
- [ ] Add user input validation
- [ ] Example structure:
  ```python
  async def handle_financial_analysis(
      update: Update,
      context: ContextTypes.DEFAULT_TYPE
  ) -> None:
      correlation_id = str(uuid.uuid4())

      try:
          company_name = " ".join(context.args)

          if not company_name:
              await update.message.reply_text(
                  "Please specify the company name.\n"
                  "Example: /financial LLC Romashka"
              )
              return

          # Process and respond
          result = await analyze_company_financials(company_name, correlation_id)
          await update.message.reply_text(format_financial_report(result))

      except ValidationError as e:
          await update.message.reply_text(f"Error: {e.message}")
      except ExternalAPIError:
          await update.message.reply_text(
              "Failed to retrieve data. Please try again later."
          )
  ```

### 3.5 Database Operations (if applicable)
- [ ] Create/update database models
- [ ] Use parameterized queries (NEVER concatenate SQL)
- [ ] Add proper transaction management
- [ ] Add logging for all DB operations
- [ ] Create database migration (if needed)

### 3.6 Code Quality During Development
- [ ] All functions have type hints
- [ ] All public functions have docstrings (Google style)
- [ ] Follow Single Responsibility Principle
- [ ] No "magic" numbers - use named constants
- [ ] No code duplication
- [ ] Async code contains no blocking operations

## 4. Testing

### 4.1 Unit Tests
- [ ] Write unit tests for all new functions
- [ ] Follow AAA pattern (Arrange-Act-Assert)
- [ ] Follow **[testing strategy](../guides/testing_strategy.md)**
- [ ] Use pytest for all tests
- [ ] For async code use `pytest-asyncio`
- [ ] Example test structure:
  ```python
  import pytest
  from unittest.mock import AsyncMock, patch

  @pytest.mark.asyncio
  async def test_fetch_company_financials_success():
      # Arrange
      client = FinancialDataClient(api_key="test_key")
      expected_data = CompanyFinancialData(
          company_name="Test Corp",
          revenue=Decimal("1000000")
      )

      # Act
      with patch.object(client._client, 'get') as mock_get:
          mock_response = AsyncMock()
          mock_response.json.return_value = expected_data.dict()
          mock_get.return_value = mock_response

          result = await client.get_company_financials("1234567890")

      # Assert
      assert result.company_name == "Test Corp"
      assert result.revenue == Decimal("1000000")
  ```

### 4.2 Integration Tests
- [ ] Write integration tests to verify component interaction
- [ ] Test end-to-end flows
- [ ] Use test fixtures for setup/teardown

### 4.3 Test Coverage
- [ ] Run tests: `pytest`
- [ ] Check coverage: `pytest --cov=. --cov-report=html`
- [ ] Ensure coverage >= 80% for new code
- [ ] All tests pass without warnings

### 4.4 Manual Testing
- [ ] Test the feature manually in development environment
- [ ] Check all user flows
- [ ] Check edge cases
- [ ] For Telegram bot - test in the test bot

## 5. Code Quality

### 5.1 Linting and Formatting
- [ ] Run Black: `poetry run black .`
- [ ] Run Ruff: `poetry run ruff check .`
- [ ] Run mypy: `poetry run mypy .`
- [ ] Fix all found issues

### 5.2 Security Review
- [ ] No hardcoded secrets, API keys, passwords
- [ ] User input is validated
- [ ] No SQL injection vulnerabilities
- [ ] Logs don't contain sensitive data
- [ ] Async resources properly managed (using context managers)

### 5.3 Performance Review
- [ ] No N+1 queries
- [ ] No excessive API calls
- [ ] Large data is processed efficiently
- [ ] Async is used for parallel operations

## 6. Documentation

### 6.1 Code Documentation
- [ ] All public functions have docstrings
- [ ] Complex algorithms have explanatory comments
- [ ] Comments explain WHY, not WHAT
- [ ] TODO comments contain author name and context

### 6.2 Update Memory Bank
- [ ] Update **[../tech_stack.md](../tech_stack.md)** if new dependencies were added
- [ ] Create/update guide in **[../guides/](../guides/)** if this is a new subsystem
- [ ] Create/update pattern in **[../patterns/](../patterns/)** if a new architectural pattern was introduced
- [ ] Add usage examples for the new feature

### 6.3 API Documentation (if applicable)
- [ ] Document all new API endpoints
- [ ] Add request/response examples
- [ ] Document error codes

## 7. Completion

### 7.1 Acceptance Criteria Check
- [ ] Verify that all acceptance criteria from the specification are met
- [ ] Go through the checklist from the specification
- [ ] Ensure there are no missing requirements

### 7.2 Architecture Review
- [ ] Ensure architectural principles are not violated
- [ ] Check that there's no code duplication
- [ ] Ensure existing components are used
- [ ] Verify that new code follows established patterns

### 7.3 Task Status Update
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "Done"
- [ ] Add a brief description of the implementation

### 7.4 Commit and Push
- [ ] Create commits with meaningful messages (Conventional Commits):
  ```
  feat(module): brief description of the feature

  - Implementation details
  - Main changes
  - Closes #TICKET-NUMBER
  ```
- [ ] Push the branch: `git push -u origin feature/TICKET-NUMBER-short-description`

### 7.5 Pull Request
- [ ] Create a Pull Request with detailed description:
  - **Feature Description**: What was implemented?
  - **Business Value**: Why is this needed?
  - **Technical Solution**: How was it implemented?
  - **Testing**: How was it tested?
  - **Screenshots/examples**: Visual examples of functionality (if applicable)
  - **Checklist**: All acceptance criteria met
- [ ] List all modified/created files and their purpose
- [ ] Link PR to ticket/issue

### 7.6 Self Review
- [ ] Conduct self-review using the checklist from **[code_review.md](./code_review.md)**
- [ ] Ensure the code is ready for review by other developers

## 8. Project-Specific Checks

### For Telegram Bot Features
- [ ] All user-facing messages in Russian
- [ ] Help texts added for new commands
- [ ] Graceful error handling implemented for user errors
- [ ] Logging with correlation_id added for all operations
- [ ] Behavior tested with incorrect input
- [ ] User doesn't see internal error details

### For External API Integration
- [ ] All responses wrapped in Pydantic models
- [ ] Retry mechanism implemented for transient errors
- [ ] Timeout handling added
- [ ] All API calls logged with correlation_id
- [ ] Circuit breaker added (if applicable)
- [ ] API keys stored in environment variables

### For Async Code
- [ ] No blocking I/O in async functions
- [ ] Async context managers used for resources
- [ ] Proper cleanup of resources
- [ ] No race conditions
- [ ] `asyncio.gather()` used for parallel operations

### For Database Features
- [ ] Parameterized queries used
- [ ] Proper transaction management
- [ ] Connection pooling configured correctly
- [ ] All DB operations logged
- [ ] Necessary indexes created
- [ ] Database migration created and tested

### For AI/LLM Integration
- [ ] API keys in environment variables
- [ ] Rate limiting implemented
- [ ] Retry mechanism added
- [ ] All LLM calls logged with correlation_id and token usage
- [ ] Fallback implemented for API unavailability cases
- [ ] User prompts sanitized to prevent injection

## Merge Readiness Checklist
- [ ] All tests pass
- [ ] Code coverage >= 80% for new code
- [ ] All linters pass without errors
- [ ] Type checking (mypy) passes without errors
- [ ] All acceptance criteria from specification met
- [ ] Documentation updated (code docs + Memory Bank)
- [ ] Self-review completed
- [ ] Pull Request created with full description
- [ ] No TODO comments (or they are documented in issues)
- [ ] No duplication of existing functionality
- [ ] Existing components used where possible
- [ ] New dependencies added to **[../tech_stack.md](../tech_stack.md)**
- [ ] Architectural principles not violated
