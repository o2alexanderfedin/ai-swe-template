# Bug Fix Process

## 1. Preparation and Analysis

### 1.1 Git Branch Setup
- [ ] Create a branch from `develop` following the template `bugfix/TICKET-NUMBER-short-description`
  - Example: `bugfix/DD-123-telegram-handler-crash`
  - Follow the convention from [../tech_stack.md](../tech_stack.md#version-control)

### 1.2 Task Tracking
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "In Progress"
- [ ] Add `[BUG]` label to the task for visual distinction

### 1.3 Bug Analysis
- [ ] Study the bug description and reproduce the problem
- [ ] Gather all available information:
  - Error logs with correlation_id for tracing
  - Reproduction steps
  - Expected vs. actual behavior
  - Environment information (Python version, dependencies)
- [ ] Generate hypotheses about the bug causes:
  - Logical errors in code
  - Concurrency issues (race conditions, deadlocks)
  - Incorrect edge case handling
  - Issues with external APIs

### 1.4 Code Localization
- [ ] Localize the problem in the codebase
- [ ] Find all relevant files:
  - Main module with the bug
  - Dependent modules
  - Tests for affected modules
- [ ] Analyze related documents:
  - **[../guides/](../guides/)** - for understanding the subsystem
  - **[../patterns/error_handling.md](../patterns/error_handling.md)** - if bug is related to error handling
  - **[../patterns/api_standards.md](../patterns/api_standards.md)** - if bug is in API integration

## 2. Development

### 2.1 Write Fix
- [ ] Make fixes to the code following **[coding standards](../guides/coding_standards.md)**:
  - Use type hints for all functions
  - Add docstrings for new/modified functions
  - Ensure proper error handling according to **[../patterns/error_handling.md](../patterns/error_handling.md)**
  - For async code - verify no blocking operations
- [ ] Add logging with `correlation_id` for debugging
- [ ] Ensure the fix addresses the root cause, not just the symptom

### 2.2 Code Review Self-Check
- [ ] Verify that the fix:
  - Is minimal - doesn't change more than necessary
  - Doesn't create new bugs in adjacent areas
  - Doesn't break existing API contracts
  - Follows project architectural patterns

## 3. Testing

### 3.1 Add/Update Tests
- [ ] Write a test that reproduces the bug (should fail before the fix)
- [ ] Ensure the test passes after the fix
- [ ] Add edge case tests to prevent regression
- [ ] Follow the **[testing strategy](../guides/testing_strategy.md)**

### 3.2 Run Full Test Suite
- [ ] Run all tests: `pytest`
- [ ] For async code: `pytest -v tests/ --asyncio-mode=auto`
- [ ] Ensure that:
  - All tests pass
  - No new warnings
  - Code coverage hasn't decreased

### 3.3 Manual Testing
- [ ] Test the fix manually in development environment
- [ ] Reproduce the original problem and ensure it's resolved
- [ ] Check edge cases
- [ ] For Telegram bot - test in the test bot

## 4. Code Quality

### 4.1 Linting and Formatting
- [ ] Run Black: `poetry run black .`
- [ ] Run Ruff: `poetry run ruff check .`
- [ ] Run mypy: `poetry run mypy .`
- [ ] Fix all found issues

### 4.2 Security Check
- [ ] Ensure the fix doesn't introduce:
  - SQL injection vulnerabilities
  - Secret leaks in logs
  - Unsafe deserialization
  - Issues with async resource management

## 5. Documentation

### 5.1 Code Documentation
- [ ] Update docstrings if function behavior has changed
- [ ] Add comments for complex fix logic
- [ ] Explain WHY, not WHAT in comments

### 5.2 Update Related Docs
- [ ] Update **[../guides/](../guides/)** if the bug revealed a documentation issue
- [ ] Update **[../patterns/](../patterns/)** if a new pattern needs to be documented
- [ ] Update **[../tech_stack.md](../tech_stack.md)** if the bug is related to a library version

## 6. Completion

### 6.1 Task Status Update
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "Done"
- [ ] Add a brief description of the solution to the task

### 6.2 Commit and Push
- [ ] Create a commit with a meaningful message:
  ```
  fix(module): brief description of the fix

  - Problem details
  - Solution details
  - Closes #TICKET-NUMBER
  ```
- [ ] Push the branch: `git push -u origin bugfix/TICKET-NUMBER-short-description`

### 6.3 Pull Request
- [ ] Create a Pull Request with description:
  - **Bug Description**: What was wrong?
  - **Root cause**: Why did this happen?
  - **Solution**: How was it fixed?
  - **Testing**: How to verify the bug is resolved?
  - **Side effects**: Are there any side effects?
- [ ] Add screenshots/logs if applicable
- [ ] Link PR to ticket/issue

### 6.4 Self Review
- [ ] Conduct self-review using the checklist from **[code_review.md](./code_review.md)**
- [ ] Ensure all criteria are met

## 7. Project-Specific Checks

### For Telegram Bot Handlers
- [ ] Test handling of incorrect user input
- [ ] Ensure all user-facing messages are in Russian
- [ ] Verify that correlation_id is passed to all calls for tracing
- [ ] Ensure errors don't show internal details to the user

### For External API Integration
- [ ] Add/update retry logic for transient errors
- [ ] Check timeout handling
- [ ] Ensure Pydantic models are used for response validation
- [ ] Log all API calls with correlation_id

### For Async Code
- [ ] Verify no blocking I/O in async functions
- [ ] Ensure proper use of async context managers
- [ ] Check proper cleanup of resources (using `async with`)
- [ ] Ensure there are no race conditions

### For Database Operations
- [ ] Use parameterized queries (no string concatenations)
- [ ] Verify transactions are properly committed/rolled back
- [ ] Ensure proper handling of connection pooling
- [ ] Add logging for all DB operations

## Merge Readiness Checklist
- [ ] All tests pass
- [ ] Code coverage hasn't decreased
- [ ] All linters pass without errors
- [ ] Documentation is updated
- [ ] Self-review completed
- [ ] Pull Request created with full description
- [ ] No TODO comments in code (or they are documented in issues)
- [ ] Fix addresses the root cause of the problem
- [ ] Tests added to prevent regression
