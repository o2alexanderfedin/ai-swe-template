# Self-Review Process

## Introduction

Self-Review is a systematic check of your own work before presenting it for code review. This is a critically important stage that:
- Improves code quality before code review
- Saves reviewers' time
- Helps find and fix problems independently
- Develops critical thinking

**When to conduct Self-Review:**
- Before creating a Pull Request
- After receiving a checklist from the planner (Gemini)
- After completing feature implementation or bug fix

## 1. Self-Review Preparation

### 1.1 Gather Context
- [ ] Open the original specification in **[../specs/](../specs/)**
- [ ] Study acceptance criteria from the specification
- [ ] Open all modified files for review
- [ ] Prepare test environment for verification

### 1.2 Mental Preparation
- [ ] Rest before review (fresh eyes)
- [ ] Set mindset for critical analysis of your work
- [ ] Imagine yourself as a code reviewer
- [ ] Forget about how long you worked on the code (sunk cost fallacy)

## 2. Acceptance Criteria Verification

### 2.1 Functional Completeness
- [ ] Compare each acceptance criteria point with the specification
- [ ] Ensure all requirements are met
- [ ] Verify there are no missing features
- [ ] For each unmet criterion:
  - Explain the reason
  - Create an issue for tracking
  - Document as a known limitation

### 2.2 Business Logic Verification
- [ ] Verify implementation matches business requirements
- [ ] Ensure edge cases are handled
- [ ] Check that boundary conditions are considered
- [ ] Test various user scenarios

## 3. Code Quality Self-Check

### 3.1 Readability Check
- [ ] Read the code as if seeing it for the first time
- [ ] Ensure logic is clear without comments
- [ ] Verify variable and function names are self-documenting
- [ ] Ensure code structure is logical
- [ ] Questions for yourself:
  - Is it clear what this code does?
  - Is it clear WHY it does this?
  - Are additional comments needed?

### 3.2 Complexity Check
- [ ] Find complex functions (>50 lines)
- [ ] Decompose long functions into smaller ones
- [ ] Check nesting level (maximum 3-4)
- [ ] Simplify complex conditions
- [ ] Extract magic numbers into constants

### 3.3 DRY Principle
- [ ] Find repeated code
- [ ] Extract duplication into separate functions
- [ ] Check for duplication of existing functionality
- [ ] Ensure existing components are reused

## 4. Architectural Compliance

### 4.1 Pattern Adherence
- [ ] Verify compliance with **[../patterns/api_standards.md](../patterns/api_standards.md)**
- [ ] Verify compliance with **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Ensure we follow project architectural decisions
- [ ] Check proper module separation:
  - `bot/` - Telegram handlers only
  - `core/` - business logic
  - `integrations/` - external API clients
  - `data/` - data processing

### 4.2 Dependency Check
- [ ] Ensure no unauthorized dependencies were added
- [ ] Check **[../tech_stack.md](../tech_stack.md)** for list of allowed libraries
- [ ] If a new dependency was added:
  - Is it truly necessary?
  - Is **[../tech_stack.md](../tech_stack.md)** updated?
  - Is there a more lightweight alternative?

### 4.3 Single Responsibility
- [ ] Each function does only one thing
- [ ] Each class has one responsibility
- [ ] No "God objects" or "God functions"

## 5. Type Safety & Standards

### 5.1 Type Hints Verification
- [ ] All functions have type hints for parameters
- [ ] All functions have type hints for return values
- [ ] No use of `Any` (or justified)
- [ ] Correct types from `typing` are used
- [ ] Run mypy: `poetry run mypy .`
- [ ] Fix all type checking errors

### 5.2 Coding Standards Check
- [ ] Code follows **[../guides/coding_standards.md](../guides/coding_standards.md)**
- [ ] Naming conventions are followed:
  - `snake_case` for variables and functions
  - `PascalCase` for classes
  - `UPPER_SNAKE_CASE` for constants
- [ ] Run Black: `poetry run black .`
- [ ] Run Ruff: `poetry run ruff check .`
- [ ] Fix all found issues

### 5.3 Documentation Check
- [ ] All public functions have docstrings (Google style)
- [ ] Docstrings contain:
  - Function description
  - Args with types
  - Returns
  - Raises
- [ ] Complex algorithms have comments
- [ ] Comments explain WHY, not WHAT

## 6. Async Code Review

### 6.1 Async Best Practices
- [ ] All I/O operations are asynchronous
- [ ] No blocking operations in async functions
- [ ] `httpx.AsyncClient` is used instead of `requests`
- [ ] Check for critical errors:
  ```python
  # BAD - blocks event loop!
  async def fetch_data():
      response = requests.get(url)  # ❌
      data = open('file.txt').read()  # ❌
      time.sleep(5)  # ❌

  # GOOD - async all the way
  async def fetch_data():
      async with httpx.AsyncClient() as client:  # ✅
          response = await client.get(url)
      async with aiofiles.open('file.txt') as f:  # ✅
          data = await f.read()
      await asyncio.sleep(5)  # ✅
  ```

### 6.2 Resource Management
- [ ] Async context managers are used
- [ ] Proper cleanup of resources
- [ ] No resource leaks
- [ ] Check each `AsyncClient`, `connection`, `file`:
  - Is `async with` used?
  - Is cleanup guaranteed on exception?

### 6.3 Concurrency Check
- [ ] Parallel operations use `asyncio.gather()`
- [ ] No race conditions
- [ ] Proper use of locks (if any)
- [ ] Example check:
  ```python
  # BAD - sequential execution
  result1 = await fetch1()
  result2 = await fetch2()

  # GOOD - parallel execution
  result1, result2 = await asyncio.gather(fetch1(), fetch2())
  ```

## 7. Error Handling Review

### 7.1 Exception Handling
- [ ] Follows **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Specific exceptions are used (not bare `Exception`)
- [ ] No empty `except` blocks
- [ ] No `except: pass` (silent failures)
- [ ] All errors are logged with context

### 7.2 User-Facing Errors
- [ ] User doesn't see internal error details
- [ ] Error messages are understandable to the user
- [ ] Error messages in Russian (for Telegram bot)
- [ ] No stack traces in user-facing messages

### 7.3 Logging Quality
- [ ] All important operations are logged
- [ ] `correlation_id` is used for tracing
- [ ] Logs don't contain sensitive data
- [ ] Log levels are correct (DEBUG, INFO, WARNING, ERROR)

## 8. Security Self-Review

### 8.1 Secrets Management
- [ ] No hardcoded passwords, API keys, tokens
- [ ] All secrets in environment variables
- [ ] `.env` file is in `.gitignore`
- [ ] Examples for search:
  ```bash
  # Search for potential secrets
  git grep -i "api_key.*=" | grep -v "env"
  git grep -i "password.*=" | grep -v "env"
  git grep -i "token.*=" | grep -v "env"
  ```

### 8.2 Input Validation
- [ ] All user input is validated
- [ ] Pydantic models are used
- [ ] No possibility of injection attacks
- [ ] SQL queries use parameterization

### 8.3 Data Exposure
- [ ] Logs don't contain PII or sensitive data
- [ ] API responses don't return more data than necessary
- [ ] Database queries don't return sensitive fields unnecessarily

## 9. Testing Self-Review

### 9.1 Test Coverage
- [ ] All new functions are covered by tests
- [ ] Run coverage: `pytest --cov=. --cov-report=html`
- [ ] Coverage >= 80% for new code
- [ ] Critical logic has 100% coverage

### 9.2 Test Quality
- [ ] Tests follow AAA pattern (Arrange-Act-Assert)
- [ ] Tests are independent of each other
- [ ] Tests have clear names
- [ ] Fixtures are used for setup/teardown
- [ ] Check each test:
  - Is it clear what it tests?
  - Does it test one thing?
  - Does the test pass?

### 9.3 Edge Cases Testing
- [ ] Edge cases are tested
- [ ] Error handling is tested
- [ ] Input validation is tested
- [ ] For async code, timeouts are tested

### 9.4 Test Execution
- [ ] Run all tests: `pytest`
- [ ] All tests pass
- [ ] No warnings in tests
- [ ] Tests execute quickly

## 10. Performance Self-Review

### 10.1 Efficiency Check
- [ ] No N+1 queries
- [ ] No excessive API calls
- [ ] Caching is used where appropriate
- [ ] Batch operations for bulk processing

### 10.2 Resource Usage
- [ ] Large data is processed in streaming fashion
- [ ] Generators are used for large collections
- [ ] Memory leaks are absent
- [ ] Connection pooling for database

### 10.3 Async Optimization
- [ ] Parallel operations execute concurrently
- [ ] No excessive `await` statements
- [ ] `asyncio.gather()` is used for parallelism

## 11. Git & Version Control

### 11.1 Commit Quality
- [ ] Commits have meaningful messages
- [ ] Follow Conventional Commits
- [ ] Commit history is logical
- [ ] No fixups (or squashed)

### 11.2 Branch Hygiene
- [ ] Branch name follows convention
- [ ] No merge conflicts
- [ ] Branch is up-to-date with develop

### 11.3 Changed Files Review
- [ ] Review diff for each file
- [ ] Ensure all changes are related to the task
- [ ] No accidental changes (debug code, formatting)
- [ ] No commented-out code

## 12. Documentation & Memory Bank

### 12.1 Code Documentation
- [ ] All public API is documented
- [ ] README is updated (if needed)
- [ ] API documentation is updated (if needed)
- [ ] Usage examples are added

### 12.2 Memory Bank Updates
- [ ] Updated **[../tech_stack.md](../tech_stack.md)** (if dependencies added)
- [ ] Created/updated guide in **[../guides/](../guides/)** (if new subsystem)
- [ ] Created/updated pattern in **[../patterns/](../patterns/)** (if new pattern)
- [ ] Updated **[../current_tasks.md](../current_tasks.md)** (task in Done)

### 12.3 Specification Compliance
- [ ] Implementation matches specification
- [ ] All acceptance criteria are met
- [ ] Deviations from spec are documented

## 13. Automated Checks

### 13.1 Code Quality Tools
```bash
# Run all tools sequentially
poetry run black .                    # Formatting
poetry run ruff check .               # Linting
poetry run mypy .                     # Type checking
```

**Checklist:**
- [ ] Black passed without changes (or changes are committed)
- [ ] Ruff found no issues
- [ ] Mypy found no type errors

### 13.2 Testing Tools
```bash
# Run all tests with coverage
pytest --cov=. --cov-report=html --cov-report=term

# For async code
pytest -v tests/ --asyncio-mode=auto
```

**Checklist:**
- [ ] All tests pass
- [ ] Coverage >= 80%
- [ ] No warnings
- [ ] No failed tests

### 13.3 Security Scanning (Optional)
```bash
# Check dependencies for vulnerabilities
poetry show --outdated
pip-audit

# Search for potential security issues
bandit -r .
```

**Checklist:**
- [ ] No critical vulnerabilities in dependencies
- [ ] No security warnings from bandit

## 14. Project-Specific Checks

### 14.1 Telegram Bot Features
- [ ] All messages in Russian
- [ ] Help texts are clear to users
- [ ] Graceful error handling
- [ ] correlation_id is used everywhere
- [ ] User doesn't see internal errors
- [ ] Tested with incorrect input

### 14.2 External API Integration
- [ ] Responses wrapped in Pydantic models
- [ ] Retry mechanism implemented
- [ ] Timeout handling implemented
- [ ] API calls logged with correlation_id
- [ ] API keys from environment variables

### 14.3 Database Code
- [ ] Parameterized queries are used
- [ ] Transaction management is correct
- [ ] Connection pooling is configured
- [ ] DB operations are logged
- [ ] Indexes created for frequently queried fields

### 14.4 AI/LLM Integration
- [ ] API keys in environment variables
- [ ] Rate limiting implemented
- [ ] Retry mechanism implemented
- [ ] Token usage logged
- [ ] Fallback mechanism implemented
- [ ] User prompts sanitized

## 15. Pull Request Preparation

### 15.1 PR Description
- [ ] Write a clear description of changes
- [ ] Include:
  - **Context:** What and why?
  - **Solution:** How is it implemented?
  - **Testing:** How to verify?
  - **Screenshots:** (if applicable)

### 15.2 PR Checklist
- [ ] All files reviewed
- [ ] All automated checks passed
- [ ] All acceptance criteria met
- [ ] Documentation updated
- [ ] Tests written and passing

### 15.3 Self-Review Commit
- [ ] Create a separate commit with fixes after self-review
- [ ] Commit message: `chore: self-review fixes`

## 16. Final Readiness Check

### 16.1 Pre-Merge Checklist
- [ ] All tests pass
- [ ] All linters pass
- [ ] Code coverage >= 80%
- [ ] Documentation updated
- [ ] Memory Bank updated
- [ ] No TODO comments (or they're in issues)
- [ ] No debug code
- [ ] No commented-out code

### 16.2 Quality Gates
- [ ] Code is ready for production
- [ ] No known bugs
- [ ] No security issues
- [ ] Performance acceptable
- [ ] Backwards compatible (or breaking changes documented)

### 16.3 Confidence Check
- [ ] Confident in code quality
- [ ] Ready to defend technical decisions
- [ ] Understand potential risks
- [ ] Ready for code review

## 17. Continuous Improvement

### 17.1 Learning from Self-Review
- [ ] Record found problems
- [ ] Understand why they occurred
- [ ] How to prevent in the future?
- [ ] Update your practices

### 17.2 Patterns Recognition
- [ ] Are there recurring problems?
- [ ] Should **[../guides/coding_standards.md](../guides/coding_standards.md)** be updated?
- [ ] Should a new pattern be created in **[../patterns/](../patterns/)**?
- [ ] Can the check be automated?

## Self-Review Score Card

After completing self-review, rate readiness for each category:

```markdown
## Self-Review Score

- [ ] ✅ Functional Completeness (100%)
- [ ] ✅ Code Quality (100%)
- [ ] ✅ Architecture Compliance (100%)
- [ ] ✅ Type Safety (100%)
- [ ] ✅ Async Code Quality (100%)
- [ ] ✅ Error Handling (100%)
- [ ] ✅ Security (100%)
- [ ] ✅ Testing (Coverage: __%)
- [ ] ✅ Performance (100%)
- [ ] ✅ Documentation (100%)

### Found Issues:
1. [Issue 1 - Status: Fixed/Documented/Tracked in issue]
2. [Issue 2 - Status: Fixed/Documented/Tracked in issue]

### Overall Readiness: [Ready/Needs Work]
```

## Self-Review Comment Template

Add to PR as first comment:

```markdown
## Self-Review Completed ✅

### Checks Performed:
- ✅ All acceptance criteria met
- ✅ Code quality tools passed (Black, Ruff, mypy)
- ✅ All tests passing (Coverage: __%)
- ✅ Security review completed
- ✅ Documentation updated
- ✅ Memory Bank updated

### Changes Made During Self-Review:
- [Change 1]
- [Change 2]

### Known Limitations:
- [Limitation 1 - tracked in issue #XX]

### Ready for Code Review
Code is ready for peer review. All self-review criteria have been met.
```

## Conclusion

Self-Review is not just a formality, but a critically important stage that:
- Improves your code quality
- Saves team time
- Develops your skills
- Prevents production problems

**Remember:** Time spent on quality self-review pays off many times over in savings on code review iterations and fixing production bugs.

**Best Practice:** Conduct self-review the day after completing work - a fresh perspective helps find more problems.
