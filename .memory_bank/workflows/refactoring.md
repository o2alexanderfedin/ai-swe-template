# Refactoring Process

## Introduction

Refactoring is changing the internal structure of code without changing its external behavior. The goal is to improve readability, maintainability, performance, or code architecture.

**Key Principle**: Refactoring should be safe and incremental. Take small steps, constantly verify that nothing is broken.

## 1. Preparation and Planning

### 1.1 Git Branch Setup
- [ ] Create a branch from `develop` following the template `refactor/TICKET-NUMBER-short-description`
  - Example: `refactor/DD-78-extract-company-validation`
  - Follow the convention from **[../tech_stack.md](../tech_stack.md#version-control)**

### 1.2 Task Tracking
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "In Progress"
- [ ] Add `[REFACTOR]` label to the task

### 1.3 Identify Refactoring Target
- [ ] Identify code that requires refactoring
- [ ] Classify the type of refactoring:
  - **Extract Method**: Extract part of code into a separate function
  - **Extract Class**: Create a new class from part of existing one
  - **Rename**: Rename to improve readability
  - **Remove Duplication**: Eliminate code duplication
  - **Simplify Conditional**: Simplify complex conditions
  - **Optimize Performance**: Improve performance
  - **Improve Error Handling**: Improve error handling
  - **Modernize Code**: Update to modern Python practices

### 1.4 Understand Current Code
- [ ] Study existing code thoroughly:
  - What does the code do?
  - What are the dependencies?
  - Where is it used?
  - What tests cover this code?
- [ ] Analyze related documents:
  - **[../guides/coding_standards.md](../guides/coding_standards.md)**
  - **[../patterns/](../patterns/)**
- [ ] Define scope of changes

### 1.5 Safety Check
- [ ] Ensure existing code is covered by tests
- [ ] If no tests exist - write them BEFORE refactoring
- [ ] Run all tests and ensure they pass
- [ ] Record current behavior as baseline

## 2. Analysis and Design

### 2.1 Define Success Criteria
- [ ] Define specific refactoring goals:
  - What should improve? (readability, performance, maintainability)
  - What metrics to use? (complexity, coupling, cohesion)
  - How to measure success?

### 2.2 Plan Incremental Steps
- [ ] Break refactoring into small, safe steps
- [ ] Define order of changes
- [ ] Define checkpoints for verification
- [ ] Example plan for Extract Method:
  1. Extract code into new function
  2. Add type hints and docstring
  3. Replace original code with call to new function
  4. Run tests
  5. Commit

### 2.3 Check Existing Components
- [ ] Check if there's already a ready solution in the codebase
- [ ] Find existing components to reuse
- [ ] Check **[../tech_stack.md](../tech_stack.md)** for available libraries

### 2.4 Assess Risk
- [ ] Assess refactoring risk:
  - **Low risk**: Local changes, well covered by tests
  - **Medium risk**: Affects several modules, partially covered by tests
  - **High risk**: Affects core functionality, few tests
- [ ] For high risk refactoring - consider splitting into several PRs

## 3. Performing Refactoring

### 3.1 General Principles
- [ ] **Red-Green-Refactor** cycle:
  1. Ensure tests pass (Green)
  2. Make a small change
  3. Run tests - they should pass
  4. Commit
  5. Repeat
- [ ] Make small, atomic commits
- [ ] Tests should pass after each step
- [ ] Don't add new functionality during refactoring

### 3.2 Extract Method Refactoring
If you need to extract part of code into a separate function:

- [ ] Identify code block to extract
- [ ] Define input parameters and return value
- [ ] Create new function with clear name
- [ ] Add type hints for all parameters and return value
- [ ] Add docstring (Google style)
- [ ] Copy code to new function
- [ ] Replace original code with call to new function
- [ ] Run tests
- [ ] Example:
  ```python
  # Before
  async def process_company(company_name: str) -> Report:
      # 50 lines of validation logic
      if not company_name:
          raise ValidationError("Empty name")
      if len(company_name) < 2:
          raise ValidationError("Name too short")
      # ... more validation

      # 100 lines of processing logic
      data = await fetch_data(company_name)
      # ... processing

      return Report(data)

  # After - extracted validation
  async def process_company(company_name: str) -> Report:
      _validate_company_name(company_name)
      data = await fetch_data(company_name)
      # ... processing
      return Report(data)

  def _validate_company_name(name: str) -> None:
      """Validate company name.

      Args:
          name: Company name to validate

      Raises:
          ValidationError: If validation fails
      """
      if not name:
          raise ValidationError("Empty name")
      if len(name) < 2:
          raise ValidationError("Name too short")
      # ... more validation
  ```

### 3.3 Extract Class Refactoring
If a class is too large and does too much:

- [ ] Identify a group of related methods and data
- [ ] Create new class with clear name
- [ ] Move related methods to new class
- [ ] Update original class - use composition
- [ ] Add type hints and docstrings
- [ ] Update tests
- [ ] Example:
  ```python
  # Before - God Object
  class CompanyAnalyzer:
      def analyze(self, company: str) -> Report:
          financial_data = self._fetch_financials(company)
          financial_score = self._calculate_financial_score(financial_data)
          legal_data = self._fetch_legal_records(company)
          legal_risk = self._assess_legal_risk(legal_data)
          news_data = self._fetch_news(company)
          sentiment = self._analyze_sentiment(news_data)
          return Report(financial_score, legal_risk, sentiment)

  # After - extracted classes
  class CompanyAnalyzer:
      def __init__(self):
          self.financial_analyzer = FinancialAnalyzer()
          self.legal_analyzer = LegalAnalyzer()
          self.sentiment_analyzer = SentimentAnalyzer()

      def analyze(self, company: str) -> Report:
          financial_score = self.financial_analyzer.analyze(company)
          legal_risk = self.legal_analyzer.analyze(company)
          sentiment = self.sentiment_analyzer.analyze(company)
          return Report(financial_score, legal_risk, sentiment)
  ```

### 3.4 Remove Duplication
If there's repeated code:

- [ ] Find all places with duplication
- [ ] Define common logic
- [ ] Create common function/class
- [ ] Replace all duplicates with calls to common function
- [ ] Parameterize differences
- [ ] Run tests
- [ ] Example:
  ```python
  # Before - duplication
  async def fetch_company_from_source_a(inn: str) -> CompanyData:
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(f"https://source-a.com/api/{inn}")
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from source A: {e}")
          raise ExternalAPIError("Source A unavailable")

  async def fetch_company_from_source_b(inn: str) -> CompanyData:
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(f"https://source-b.com/companies/{inn}")
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from source B: {e}")
          raise ExternalAPIError("Source B unavailable")

  # After - extracted common logic
  async def fetch_company_from_api(
      url: str,
      source_name: str
  ) -> CompanyData:
      """Fetch company data from external API.

      Args:
          url: API endpoint URL
          source_name: Name of the data source for logging

      Returns:
          CompanyData object

      Raises:
          ExternalAPIError: If API call fails
      """
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(url)
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from {source_name}: {e}")
          raise ExternalAPIError(f"{source_name} unavailable")

  async def fetch_company_from_source_a(inn: str) -> CompanyData:
      return await fetch_company_from_api(
          url=f"https://source-a.com/api/{inn}",
          source_name="Source A"
      )

  async def fetch_company_from_source_b(inn: str) -> CompanyData:
      return await fetch_company_from_api(
          url=f"https://source-b.com/companies/{inn}",
          source_name="Source B"
      )
  ```

### 3.5 Simplify Conditional Logic
If conditions are too complex:

- [ ] Extract complex conditions into functions with clear names
- [ ] Use early returns to reduce nesting
- [ ] Apply pattern matching (Python 3.10+) if appropriate
- [ ] Example:
  ```python
  # Before - complex nested conditions
  def calculate_discount(user: User, order: Order) -> Decimal:
      if user.is_premium:
          if order.total > 10000:
              if user.loyalty_points > 1000:
                  return order.total * Decimal("0.25")
              else:
                  return order.total * Decimal("0.15")
          else:
              return order.total * Decimal("0.10")
      else:
          if order.total > 5000:
              return order.total * Decimal("0.05")
          else:
              return Decimal("0")

  # After - simplified with extracted functions
  def calculate_discount(user: User, order: Order) -> Decimal:
      if not user.is_premium:
          return _calculate_regular_discount(order)
      return _calculate_premium_discount(user, order)

  def _calculate_regular_discount(order: Order) -> Decimal:
      """Calculate discount for regular users."""
      if order.total > 5000:
          return order.total * Decimal("0.05")
      return Decimal("0")

  def _calculate_premium_discount(user: User, order: Order) -> Decimal:
      """Calculate discount for premium users."""
      if order.total <= 10000:
          return order.total * Decimal("0.10")

      discount_rate = Decimal("0.25") if user.loyalty_points > 1000 else Decimal("0.15")
      return order.total * discount_rate
  ```

### 3.6 Improve Async Code
If async code can be improved:

- [ ] Replace blocking operations with async
- [ ] Use `asyncio.gather()` for parallel operations
- [ ] Use async context managers
- [ ] Remove race conditions
- [ ] Example:
  ```python
  # Before - sequential async calls
  async def fetch_all_data(company: str) -> CompanyReport:
      financial = await fetch_financial_data(company)
      legal = await fetch_legal_data(company)
      news = await fetch_news_data(company)
      return CompanyReport(financial, legal, news)

  # After - parallel async calls
  async def fetch_all_data(company: str) -> CompanyReport:
      financial, legal, news = await asyncio.gather(
          fetch_financial_data(company),
          fetch_legal_data(company),
          fetch_news_data(company)
      )
      return CompanyReport(financial, legal, news)
  ```

### 3.7 Modernize Code
If code uses outdated patterns:

- [ ] Replace old type hints with modern ones (Python 3.10+):
  - `list[str]` instead of `List[str]`
  - `dict[str, int]` instead of `Dict[str, int]`
  - `X | None` instead of `Optional[X]`
- [ ] Use f-strings instead of `.format()` or `%`
- [ ] Use dataclasses or Pydantic instead of regular classes
- [ ] Use pathlib instead of os.path
- [ ] Example:
  ```python
  # Before - old style
  from typing import List, Optional, Dict
  import os

  def process_files(
      file_paths: List[str],
      config: Optional[Dict[str, str]] = None
  ) -> List[str]:
      results = []
      for path in file_paths:
          full_path = os.path.join("/data", path)
          if os.path.exists(full_path):
              results.append("File exists: %s" % path)
      return results

  # After - modern Python 3.11+
  from pathlib import Path

  def process_files(
      file_paths: list[str],
      config: dict[str, str] | None = None
  ) -> list[str]:
      results = []
      base_path = Path("/data")

      for path in file_paths:
          full_path = base_path / path
          if full_path.exists():
              results.append(f"File exists: {path}")

      return results
  ```

## 4. Testing

### 4.1 Continuous Testing
- [ ] Run tests after each small change
- [ ] Command: `pytest -v`
- [ ] For async tests: `pytest -v --asyncio-mode=auto`
- [ ] Ensure all tests pass

### 4.2 Test Coverage
- [ ] Verify test coverage hasn't decreased
- [ ] Command: `pytest --cov=. --cov-report=html`
- [ ] Ensure coverage >= 80%

### 4.3 Add New Tests (if needed)
- [ ] If refactoring created new public functions - add tests for them
- [ ] If untested edge cases were revealed - add tests
- [ ] Follow **[testing strategy](../guides/testing_strategy.md)**

### 4.4 Integration Testing
- [ ] Run integration tests (if available)
- [ ] Test manually in development environment
- [ ] For Telegram bot - test in the test bot

## 5. Code Quality Verification

### 5.1 Linting and Formatting
- [ ] Run Black: `poetry run black .`
- [ ] Run Ruff: `poetry run ruff check .`
- [ ] Run mypy: `poetry run mypy .`
- [ ] Fix all found issues

### 5.2 Code Quality Metrics
- [ ] Verify that refactoring actually improved the code:
  - Did function complexity decrease?
  - Did readability improve?
  - Did duplication decrease?
  - Did structure improve?

### 5.3 Performance Check (if applicable)
- [ ] If refactoring goal is performance:
  - Measure performance before and after
  - Ensure there's improvement
  - Add performance tests (if applicable)

## 6. Documentation

### 6.1 Code Documentation
- [ ] Update docstrings for modified functions/classes
- [ ] Add comments explaining WHY (if needed)
- [ ] Remove outdated comments

### 6.2 Update Memory Bank (if needed)
- [ ] Update **[../guides/](../guides/)** if practices changed
- [ ] Update **[../patterns/](../patterns/)** if patterns changed
- [ ] Add new best practices revealed during refactoring

### 6.3 Document Breaking Changes (if any)
- [ ] If refactoring changed public API:
  - Document breaking changes
  - Create migration guide
  - Update version (semantic versioning)

## 7. Completion

### 7.1 Self Review
- [ ] Conduct self-review:
  - Are all refactoring goals achieved?
  - Did the code actually improve?
  - Was new functionality accidentally added?
  - Do all tests pass?

### 7.2 Task Status Update
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "Done"
- [ ] Add description of performed refactoring

### 7.3 Commit and Push
- [ ] Create meaningful commits (Conventional Commits):
  ```
  refactor(module): brief description of refactoring

  - What was improved
  - Why it was done
  - Before/after metrics (if applicable)
  ```
- [ ] Push the branch: `git push -u origin refactor/TICKET-NUMBER-short-description`

### 7.4 Pull Request
- [ ] Create Pull Request with description:
  - **Motivation**: Why is refactoring needed?
  - **Changes**: What changed?
  - **Impact**: How did this improve the code? (metrics, readability, etc.)
  - **Testing**: How to verify nothing is broken?
  - **Breaking Changes**: Are there breaking changes? (should be "No" for pure refactoring)
- [ ] Add "before/after" code examples
- [ ] Link PR to ticket/issue

### 7.5 Final Check
- [ ] Conduct full review using checklist from **[code_review.md](./code_review.md)**
- [ ] Ensure that:
  - External behavior hasn't changed
  - All tests pass
  - Code quality improved
  - No regression

## 8. Specific Refactoring Types

### 8.1 Database Schema Refactoring
If refactoring affects database schema:

- [ ] Create backwards-compatible migration
- [ ] Define data migration strategy:
  1. Add new fields/tables
  2. Migrate data
  3. Update code to use new schema
  4. Remove old fields/tables (in separate release)
- [ ] Test migration on production data copy
- [ ] Prepare rollback plan

### 8.2 API Refactoring
If refactoring affects public API:

- [ ] Maintain backwards compatibility
- [ ] Use deprecation warnings for old API
- [ ] Document migration path
- [ ] Create migration guide for users
- [ ] Define timeline for removing deprecated API

### 8.3 Performance Refactoring
If goal is to improve performance:

- [ ] Measure baseline performance (profiling)
- [ ] Identify bottlenecks
- [ ] Apply optimizations
- [ ] Measure improvement
- [ ] Ensure readability didn't suffer significantly
- [ ] Add performance tests to prevent regression

## 9. Anti-patterns and Mistakes

### What NOT to do during refactoring:

- [ ] ❌ **Don't add new functionality** - refactoring should only change structure
- [ ] ❌ **Don't make large changes at once** - small incremental steps
- [ ] ❌ **Don't refactor without tests** - write tests first
- [ ] ❌ **Don't change behavior** - external behavior should remain the same
- [ ] ❌ **Don't optimize prematurely** - first ensure it's a real bottleneck
- [ ] ❌ **Don't refactor for refactoring's sake** - there must be a clear goal
- [ ] ❌ **Don't skip tests** - run after each step

## Merge Readiness Checklist

- [ ] All tests pass
- [ ] Test coverage hasn't decreased
- [ ] All linters pass
- [ ] Type checking passes
- [ ] External behavior hasn't changed
- [ ] Code improved (more readable/maintainable/performant)
- [ ] Documentation updated
- [ ] Self-review completed
- [ ] Pull Request created with clear description
- [ ] No accidentally added new functionality
- [ ] All refactoring goals achieved

## Examples of Successful Refactoring

### Example: Extract Validation Logic
```python
# Before - validation mixed with business logic
async def create_company_report(company_name: str, user_id: int) -> Report:
    if not company_name:
        raise ValidationError("Company name is required")
    if len(company_name) < 2:
        raise ValidationError("Company name too short")
    if not company_name.isascii():
        raise ValidationError("Company name must be ASCII")

    # Business logic
    data = await fetch_company_data(company_name)
    return generate_report(data)

# After - extracted validation
async def create_company_report(company_name: str, user_id: int) -> Report:
    _validate_company_name(company_name)
    data = await fetch_company_data(company_name)
    return generate_report(data)

def _validate_company_name(name: str) -> None:
    """Validate company name format.

    Args:
        name: Company name to validate

    Raises:
        ValidationError: If validation fails
    """
    if not name:
        raise ValidationError("Company name is required")
    if len(name) < 2:
        raise ValidationError("Company name too short")
    if not name.isascii():
        raise ValidationError("Company name must be ASCII")
```

Result:
- ✅ Main function readability improved
- ✅ Validation logic is reusable
- ✅ Easier to test
- ✅ Easier to maintain and extend
