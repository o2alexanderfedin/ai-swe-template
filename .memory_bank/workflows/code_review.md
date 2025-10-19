# Code Review Process

## 1. General Check

### 1.1 Pull Request Quality
- [ ] Pull Request contains a clear description of changes
- [ ] Description includes:
  - Context: what and why is being done
  - Technical solution: how it's implemented
  - Testing: how to verify
  - Screenshots/examples (if applicable)
- [ ] PR is linked to corresponding ticket/issue
- [ ] PR title follows Conventional Commits format
- [ ] PR size is reasonable (no more than 500 lines of changes, preferably <300)

### 1.2 Scope Check
- [ ] All modified files are related to the task being solved
- [ ] No unrelated changes (scope creep)
- [ ] No commented-out code
- [ ] No debug prints or console.log
- [ ] No dead code (unused imports, functions)

### 1.3 Commit History
- [ ] Commits have meaningful messages
- [ ] Follow Conventional Commits format
- [ ] Commit history is logical and clear
- [ ] No fixup commits for typos (should be squashed)

## 2. Coding Standards Compliance

### 2.1 Code Style
- [ ] Code complies with **[coding standards](../guides/coding_standards.md)**
- [ ] Variable, function, and class naming follows conventions:
  - `snake_case` for variables and functions
  - `PascalCase` for classes
  - `UPPER_SNAKE_CASE` for constants
- [ ] Formatting is consistent with Black
- [ ] Maximum line length: 100 characters

### 2.2 Type Hints
- [ ] All functions have type hints for parameters and return value
- [ ] Correct types from `typing` are used
- [ ] No use of `Any` (if present - must be justified)
- [ ] Example:
  ```python
  # Good
  def fetch_data(url: str, timeout: int = 30) -> Dict[str, Any]:
      pass

  # Bad
  def fetch_data(url, timeout=30):  # No type hints
      pass
  ```

### 2.3 Docstrings
- [ ] All public functions and classes have docstrings
- [ ] Docstrings follow Google style
- [ ] Docstrings contain:
  - Brief description
  - Args with types and descriptions
  - Returns with description
  - Raises for exceptions
  - Example (if applicable)
- [ ] Example:
  ```python
  async def analyze_company(
      company_name: str,
      correlation_id: str
  ) -> CompanyAnalysis:
      """Analyze company data and generate report.

      Args:
          company_name: Name of the company to analyze
          correlation_id: Request correlation ID for tracking

      Returns:
          CompanyAnalysis object with analysis results

      Raises:
          ValidationError: If company_name is invalid
          ExternalAPIError: If external API call fails
      """
      pass
  ```

## 3. Architecture and Patterns

### 3.1 Architectural Compliance
- [ ] Changes don't violate architectural principles from **[../patterns/](../patterns/)**
- [ ] New components follow established patterns
- [ ] Proper separation of responsibilities between modules:
  - `bot/` - Telegram handlers only
  - `core/` - business logic
  - `integrations/` - external API clients
  - `data/` - data processing and storage

### 3.2 Code Reuse
- [ ] No duplication of functionality existing in other parts of the project
- [ ] Existing Pydantic models are used
- [ ] Existing utility functions are used
- [ ] API clients from `integrations/` are reused

### 3.3 Dependency Management
- [ ] If new dependencies were added:
  - They are truly necessary
  - **[../tech_stack.md](../tech_stack.md)** is updated
  - Compatibility with current stack is verified
  - Necessity is justified (no lightweight alternatives)

## 4. Code Quality

### 4.1 Single Responsibility Principle
- [ ] Each function has one responsibility
- [ ] Each class has one responsibility
- [ ] Functions don't exceed 50 lines
- [ ] Files don't exceed 500 lines

### 4.2 Code Complexity
- [ ] No overly complex functions
- [ ] Nesting level doesn't exceed 3-4
- [ ] Complex conditions are extracted to separate functions with clear names
- [ ] Example:
  ```python
  # Good
  def is_eligible_for_discount(user: User) -> bool:
      return (
          user.is_premium
          and user.purchases_count > 10
          and user.account_age_days > 30
      )

  if is_eligible_for_discount(user):
      apply_discount()

  # Bad
  if user.is_premium and user.purchases_count > 10 and user.account_age_days > 30:
      apply_discount()
  ```

### 4.3 Error Handling
- [ ] Error handling follows **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Specific exceptions are used (not bare `Exception`)
- [ ] No empty `except` blocks or `except: pass`
- [ ] All errors are logged with context
- [ ] User-facing errors don't contain internal details
- [ ] Example:
  ```python
  # Good
  try:
      result = await fetch_data(url)
  except httpx.HTTPStatusError as e:
      logger.error(f"HTTP error: {e.response.status_code}", extra={"correlation_id": correlation_id})
      raise ExternalAPIError(f"API returned {e.response.status_code}")
  except httpx.TimeoutException:
      logger.error("Request timeout", extra={"correlation_id": correlation_id})
      raise ExternalAPIError("Request timeout")

  # Bad
  try:
      result = await fetch_data(url)
  except:  # Too broad!
      pass  # Silently ignoring!
  ```

### 4.4 Magic Numbers and Strings
- [ ] No "magic" numbers - named constants are used
- [ ] No hardcoded strings - constants or config are used
- [ ] Example:
  ```python
  # Good
  MAX_RETRIES = 3
  DEFAULT_TIMEOUT = 30

  @retry(stop=stop_after_attempt(MAX_RETRIES))
  async def fetch_data(url: str, timeout: int = DEFAULT_TIMEOUT):
      pass

  # Bad
  @retry(stop=stop_after_attempt(3))  # What is 3?
  async def fetch_data(url: str, timeout: int = 30):  # What is 30?
      pass
  ```

## 5. Async Code Quality

### 5.1 Async Best Practices
- [ ] All I/O operations are asynchronous
- [ ] No blocking operations in async functions
- [ ] `httpx.AsyncClient` is used instead of `requests`
- [ ] `aiofiles` is used for file operations
- [ ] Example:
  ```python
  # Good
  async def fetch_data(url: str) -> Dict[str, Any]:
      async with httpx.AsyncClient() as client:
          response = await client.get(url)
          return response.json()

  # Bad - blocks event loop!
  async def fetch_data(url: str) -> Dict[str, Any]:
      response = requests.get(url)  # Blocking I/O!
      return response.json()
  ```

### 5.2 Resource Management
- [ ] Async context managers are used for resources
- [ ] Proper cleanup of resources (clients, connections, files)
- [ ] No resource leaks
- [ ] Example:
  ```python
  # Good - automatic cleanup
  async with httpx.AsyncClient() as client:
      response = await client.get(url)

  # Bad - risk of resource leak
  client = httpx.AsyncClient()
  response = await client.get(url)
  # What if exception? Client not closed!
  ```

### 5.3 Concurrency
- [ ] `asyncio.gather()` is used for parallel operations
- [ ] No race conditions
- [ ] Proper use of locks (if needed)
- [ ] Example:
  ```python
  # Good - parallel execution
  results = await asyncio.gather(
      fetch_data(url1),
      fetch_data(url2),
      fetch_data(url3)
  )

  # Bad - sequential execution
  result1 = await fetch_data(url1)
  result2 = await fetch_data(url2)
  result3 = await fetch_data(url3)
  ```

## 6. Testing

### 6.1 Test Coverage
- [ ] All new functions are covered by unit tests
- [ ] Code coverage >= 80% for new code
- [ ] Critical business logic has 100% coverage

### 6.2 Test Quality
- [ ] Tests follow AAA pattern (Arrange-Act-Assert)
- [ ] Tests are independent of each other
- [ ] Tests have clear names (`test_function_name_expected_behavior`)
- [ ] Fixtures are used for setup/teardown
- [ ] Example:
  ```python
  @pytest.mark.asyncio
  async def test_fetch_company_data_returns_valid_data():
      # Arrange
      client = CompanyClient(api_key="test_key")
      expected_company = "Test Corp"

      # Act
      result = await client.fetch_company_data(expected_company)

      # Assert
      assert result.name == expected_company
      assert result.inn is not None
  ```

### 6.3 Test Execution
- [ ] All tests pass: `pytest`
- [ ] No warnings in tests
- [ ] Tests execute quickly (<5 minutes for entire suite)

### 6.4 Edge Cases
- [ ] Edge cases are tested
- [ ] Error handling is tested
- [ ] Input validation is tested
- [ ] For async code, timeouts are tested

## 7. Security

### 7.1 Secrets Management
- [ ] No hardcoded passwords, API keys, tokens
- [ ] All secrets in environment variables
- [ ] `python-dotenv` or `pydantic-settings` is used
- [ ] `.env` file is in `.gitignore`

### 7.2 Input Validation
- [ ] All user input is validated
- [ ] Pydantic models are used for validation
- [ ] No possibility of injection attacks

### 7.3 SQL Security
- [ ] Parameterized queries are used
- [ ] No string concatenations for SQL
- [ ] Example:
  ```python
  # Good
  query = "SELECT * FROM companies WHERE name = %s"
  cursor.execute(query, (company_name,))

  # Bad - SQL injection risk!
  query = f"SELECT * FROM companies WHERE name = '{company_name}'"
  cursor.execute(query)
  ```

### 7.4 Data Exposure
- [ ] Logs don't contain sensitive data (API keys, passwords, PII)
- [ ] Error messages don't show internal details to users
- [ ] User-facing messages don't contain stack traces

## 8. Performance

### 8.1 Efficiency
- [ ] No N+1 queries
- [ ] No excessive API calls
- [ ] Caching is used where appropriate
- [ ] Batch operations for bulk processing

### 8.2 Resource Usage
- [ ] Large data is processed in streaming fashion (not loaded entirely in memory)
- [ ] Generators are used for large collections
- [ ] Connection pooling for database

### 8.3 Async Optimization
- [ ] Parallel operations execute concurrently
- [ ] No excessive `await` statements (blocking parallelism)

## 9. Documentation

### 9.1 Code Documentation
- [ ] Documentation is updated if public API changed
- [ ] Complex algorithms have explanatory comments
- [ ] Comments explain WHY, not WHAT
- [ ] TODO comments contain context and assignee

### 9.2 Memory Bank Updates
- [ ] **[../tech_stack.md](../tech_stack.md)** is updated when dependencies are added
- [ ] **[../guides/](../guides/)** are updated when new subsystems are added
- [ ] **[../patterns/](../patterns/)** are updated when new patterns are introduced
- [ ] **[../current_tasks.md](../current_tasks.md)** is updated (task in Done)

### 9.3 API Documentation
- [ ] New API endpoints are documented
- [ ] Request/response examples are added
- [ ] Error codes are documented

## 10. Project-Specific Checks

### 10.1 Telegram Bot Code
- [ ] All user-facing messages in Russian
- [ ] Help texts added for new commands
- [ ] Graceful error handling for user errors
- [ ] Logging with `correlation_id` for all operations
- [ ] User doesn't see internal error details
- [ ] Handling of incorrect user input

### 10.2 External API Integration
- [ ] All responses wrapped in Pydantic models
- [ ] Retry mechanism for transient errors
- [ ] Timeout handling
- [ ] Logging of all API calls with `correlation_id`
- [ ] Circuit breaker (for critical integrations)
- [ ] API keys from environment variables

### 10.3 Database Code
- [ ] Parameterized queries (no SQL injection risk)
- [ ] Proper transaction management
- [ ] Connection pooling
- [ ] Logging of all DB operations
- [ ] Indexes for frequently queried fields

### 10.4 AI/LLM Integration
- [ ] API keys in environment variables
- [ ] Rate limiting implemented
- [ ] Retry mechanism for API errors
- [ ] Logging of LLM calls with token usage
- [ ] Fallback for API unavailability cases
- [ ] User prompts sanitized

## 11. Final Check

### 11.1 CI/CD
- [ ] No merge conflicts
- [ ] CI/CD pipeline passes successfully
- [ ] All linters pass (Black, Ruff, mypy)
- [ ] All tests pass

### 11.2 Acceptance Criteria
- [ ] All acceptance criteria from specification are met
- [ ] Feature works according to requirements
- [ ] No known bugs or limitations (or they are documented)

### 11.3 Backwards Compatibility
- [ ] Changes don't break existing functionality
- [ ] API contracts are not violated
- [ ] Database migrations are backwards compatible (if applicable)

### 11.4 Deployment Readiness
- [ ] Environment variables are documented
- [ ] Deployment instructions are updated (if needed)
- [ ] Database migrations are ready (if needed)
- [ ] No breaking changes (or they are documented)

## Final Readiness Checklist

- [ ] All sections of this checklist are completed
- [ ] Code complies with **[coding standards](../guides/coding_standards.md)**
- [ ] Architectural patterns from **[../patterns/](../patterns/)** are followed
- [ ] Error handling follows **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Technology stack complies with **[../tech_stack.md](../tech_stack.md)**
- [ ] All tests pass with coverage >= 80%
- [ ] Documentation is updated
- [ ] No security issues
- [ ] No performance problems
- [ ] Code is ready for production deployment

## Review Comment Templates

### For Approval (LGTM)
```
✅ Code Review LGTM

Verified:
- Architecture and patterns
- Code quality and standards
- Tests and coverage
- Security
- Documentation

Great work! 🚀
```

### For Requesting Changes
```
⚠️ Code Review - Changes Requested

Main issues:
1. [Critical issue 1 with code reference]
2. [Critical issue 2 with code reference]

Recommendations:
- [Non-critical recommendation 1]
- [Non-critical recommendation 2]

Ready for re-review after critical issues are fixed.
```

### For Comments
```
💬 Comment

Question/suggestion regarding [specific code location]:
[Details]

Doesn't block merge, but worth discussing.
```
