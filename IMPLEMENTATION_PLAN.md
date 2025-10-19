# AI SWE Implementation Plan

## Overview
This document provides a comprehensive, hierarchical implementation plan for setting up the AI Software Engineering (AI SWE) methodology based on the Memory Bank concept. The plan is organized into major components, subdirectories, and individual files with their required content structures.

---

## Level 1: Major Components

### 1.1 Memory Bank Setup
### 1.2 Workflows Directory
### 1.3 Claude Code Configuration
### 1.4 Custom Commands Setup

---

## COMPONENT 1: Memory Bank Setup

**Purpose**: Create a structured knowledge base that serves as the "brain" of the project for AI agents.

**Location**: `/.memory_bank/`

**Dependencies**: None (this is the foundation)

**Success Criteria**:
- Directory structure is created
- All core files are populated with appropriate content
- Navigation structure is logical and hierarchical
- Links between documents are functional

---

### 1.1.1 Core Memory Bank Files

#### Task 1.1.1.1: Create README.md (Navigation Hub)

**File**: `/.memory_bank/README.md`

**Purpose**: Main entry point and navigation router for all project knowledge

**Dependencies**: None

**Content Structure**:

```markdown
# Memory Bank: Project's Single Source of Truth

This memory bank is your main source of information. Before starting any task, **mandatory** familiarize yourself with this file and follow the relevant links.

## Mandatory Reading Sequence Before ANY Task

1.  **[Tech Stack](./tech_stack.md)**: Learn which technologies, libraries and versions we use.
2.  **[Coding Standards](./guides/coding_standards.md)**: Familiarize yourself with formatting rules, naming conventions and best practices.
3.  **[Current Tasks](./current_tasks.md)**: Check the list of active tasks to understand current team focus.

## Knowledge System Map

### 1. About the Project (WHY Context)
- **[Product Brief](./product_brief.md)**: Business goals, target audience, key features. Refer here to understand *WHAT* we're building and *FOR WHOM*.

### 2. Technical Foundation (HOW Context)
- **[Tech Stack](./tech_stack.md)**: Complete list of frameworks, libraries and their versions. **FORBIDDEN** to add new dependencies without updating this file.
- **[Architectural Patterns](./patterns/)**: Fundamental decisions. Study them before making changes to module structure.
- **[Subsystem Guides](./guides/)**: Detailed description of key modules (e.g., authentication, payment system).

### 3. Processes and Tasks (WHAT TO DO Context)
- **[Workflows](./workflows/)**: Step-by-step instructions for standard tasks. Choose the appropriate workflow for your current task.
  - **[New Feature Development](./workflows/new_feature.md)**
  - **[Bug Fix](./workflows/bug_fix.md)**
- **[Specifications](./specs/)**: Detailed technical requirements for new features.

---
**Rule:** If you make changes that affect architecture or add new dependencies, you must update the corresponding document in Memory Bank.
```

**Success Criteria**:
- File exists at `/.memory_bank/README.md`
- Contains clear navigation structure
- All internal links are created (files may not exist yet)
- Mandatory reading sequence is defined

---

#### Task 1.1.1.2: Create tech_stack.md (Technical Passport)

**File**: `/.memory_bank/tech_stack.md`

**Purpose**: Define allowed technologies, libraries, versions, and forbidden practices

**Dependencies**: None

**Content Structure**:

```markdown
# Technology Stack and Conventions

## Core Stack
- **Frontend**: React 18 (use **ONLY** functional components with hooks).
- **State Management**: Redux Toolkit + RTK Query for all async requests.
- **Styling**: CSS Modules. **FORBIDDEN** to use inline styles or global CSS selectors.

## Forbidden Practices
- ❌ Using `any` in TypeScript. All types must be explicitly defined.
- ❌ Using class components in React.
- ❌ Direct DOM manipulations. Always use React-way.

## API Conventions
- All API requests must go through unified client `src/api/apiClient.ts`.
- Error handling must follow the schema described in **[./patterns/error_handling.md](./patterns/error_handling.md)**.
```

**Customization Notes**:
- Replace with your actual tech stack (Python, Node.js, etc.)
- Add specific version numbers
- Include database technologies
- List testing frameworks
- Define CI/CD tools

**Success Criteria**:
- File exists at `/.memory_bank/tech_stack.md`
- All technologies used in project are listed
- Forbidden practices are clearly defined
- Links to related patterns are included

---

#### Task 1.1.1.3: Create product_brief.md (Business Context)

**File**: `/.memory_bank/product_brief.md`

**Purpose**: Help AI understand business context, goals, and target audience

**Dependencies**: None

**Content Structure**:

```markdown
# Product Description

## Project Name
[Your Project Name]

## Project Goal (WHY)
[Describe the core business problem this project solves]

## Target Audience (FOR WHOM)
[Describe your target users/customers]

## Key Features
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

## Business Success Metrics
- [Metric 1]
- [Metric 2]

## Competitive Advantages
[What makes this project unique]
```

**Success Criteria**:
- File exists at `/.memory_bank/product_brief.md`
- Business goals are clearly articulated
- Target audience is defined
- Key features are listed

---

#### Task 1.1.1.4: Create current_tasks.md (Kanban Board)

**File**: `/.memory_bank/current_tasks.md`

**Purpose**: Living Kanban board for task synchronization

**Dependencies**: None

**Content Structure**:

```markdown
# Current Tasks

## To Do
- [ ] [FE-42] Implement Google authentication.
- [ ] [BE-17] Optimize database queries in sales report.

## In Progress
- [x] [FE-39] Create responsive layout for main page.

## Done
- [x] [BE-15] Implement caching for catalog API responses.
```

**Customization Notes**:
- Use your project's task ID format
- Update this file dynamically as work progresses
- Agent should update this automatically based on workflows

**Success Criteria**:
- File exists at `/.memory_bank/current_tasks.md`
- Three sections exist: To Do, In Progress, Done
- Task format includes ID and description

---

### 1.1.2 Patterns Directory

#### Task 1.1.2.1: Create /patterns directory

**Location**: `/.memory_bank/patterns/`

**Purpose**: Store fundamental architectural decisions and patterns

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- At least 2 pattern documents are created

---

#### Task 1.1.2.2: Create api_standards.md

**File**: `/.memory_bank/patterns/api_standards.md`

**Purpose**: Define API design patterns and conventions

**Dependencies**: patterns/ directory exists

**Content Structure**:

```markdown
# API Standards

## Naming Conventions
- Endpoints use lowercase with hyphens: `/api/user-profiles`
- Resource-based URLs, not action-based

## Request/Response Format
- All requests/responses use JSON
- Date formats: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)

## Error Handling
- Standard error response structure:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {}
  }
}
```

## Authentication
- [Describe your auth mechanism: JWT, OAuth, etc.]

## Versioning
- API versioning in URL: `/api/v1/...`
```

**Success Criteria**:
- File exists at `/.memory_bank/patterns/api_standards.md`
- All API conventions are documented
- Examples are provided

---

#### Task 1.1.2.3: Create error_handling.md

**File**: `/.memory_bank/patterns/error_handling.md`

**Purpose**: Define error handling patterns across the application

**Dependencies**: patterns/ directory exists

**Content Structure**:

```markdown
# Error Handling Patterns

## Philosophy
- Fail fast and explicitly
- Always log errors with context
- User-facing errors should be actionable

## Error Categories
1. **Validation Errors**: User input issues (4xx)
2. **System Errors**: Internal failures (5xx)
3. **Business Logic Errors**: Rule violations

## Implementation Pattern

### Python Example
```python
class ApplicationError(Exception):
    """Base exception class"""
    def __init__(self, message, code=None, details=None):
        self.message = message
        self.code = code
        self.details = details or {}
```

### JavaScript Example
```javascript
class ApplicationError extends Error {
  constructor(message, code, details = {}) {
    super(message);
    this.code = code;
    this.details = details;
  }
}
```

## Logging Standards
- Use structured logging
- Include correlation IDs
- Never log sensitive data
```

**Success Criteria**:
- File exists at `/.memory_bank/patterns/error_handling.md`
- Error handling philosophy is defined
- Code examples are provided
- Logging standards are specified

---

### 1.1.3 Guides Directory

#### Task 1.1.3.1: Create /guides directory

**Location**: `/.memory_bank/guides/`

**Purpose**: Store practical guides for specific subsystems and practices

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- At least 2 guide documents are created

---

#### Task 1.1.3.2: Create coding_standards.md

**File**: `/.memory_bank/guides/coding_standards.md`

**Purpose**: Define code formatting, naming, and best practices

**Dependencies**: guides/ directory exists

**Content Structure**:

```markdown
# Coding Standards

## General Principles
- Code readability over cleverness
- Self-documenting code with minimal comments
- Follow DRY (Don't Repeat Yourself)

## Naming Conventions

### Variables and Functions
- Use descriptive names: `getUserProfile()` not `getUP()`
- Boolean variables: `isActive`, `hasPermission`
- Constants: `UPPER_SNAKE_CASE`

### Files and Directories
- Components: `PascalCase.tsx`
- Utilities: `camelCase.ts`
- Tests: `componentName.test.ts`

## Code Organization
- Maximum file length: 300 lines
- Maximum function length: 50 lines
- Single Responsibility Principle

## Comments
- Use comments for "why", not "what"
- Update comments when code changes
- Document complex algorithms

## Formatting
- Use project's linter configuration
- Run formatter before committing
- Consistent indentation (2 or 4 spaces, not tabs)
```

**Success Criteria**:
- File exists at `/.memory_bank/guides/coding_standards.md`
- Naming conventions are defined
- Code organization rules are specified
- Examples are provided

---

#### Task 1.1.3.3: Create testing_strategy.md

**File**: `/.memory_bank/guides/testing_strategy.md`

**Purpose**: Define testing approach and requirements

**Dependencies**: guides/ directory exists

**Content Structure**:

```markdown
# Testing Strategy

## Testing Pyramid
1. **Unit Tests** (70%): Test individual functions and classes
2. **Integration Tests** (20%): Test module interactions
3. **E2E Tests** (10%): Test complete user flows

## Unit Testing Requirements
- All business logic must have unit tests
- Minimum 80% code coverage
- Test file naming: `module.test.js`

## Test Structure (AAA Pattern)
```javascript
describe('UserService', () => {
  it('should create a new user', () => {
    // Arrange
    const userData = { name: 'John', email: 'john@example.com' };

    // Act
    const user = userService.create(userData);

    // Assert
    expect(user.id).toBeDefined();
    expect(user.name).toBe('John');
  });
});
```

## Mocking Strategy
- Mock external dependencies (APIs, databases)
- Use dependency injection for testability

## Test Data
- Use factories for test data
- Never use production data in tests

## Running Tests
```bash
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # Generate coverage report
```
```

**Success Criteria**:
- File exists at `/.memory_bank/guides/testing_strategy.md`
- Testing pyramid is defined
- Code coverage requirements are specified
- Examples are provided

---

### 1.1.4 Specs Directory

#### Task 1.1.4.1: Create /specs directory

**Location**: `/.memory_bank/specs/`

**Purpose**: Store detailed technical specifications for new features

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- Template for feature specs is created

---

#### Task 1.1.4.2: Create feature_spec_template.md

**File**: `/.memory_bank/specs/feature_spec_template.md`

**Purpose**: Provide template for writing detailed feature specifications

**Dependencies**: specs/ directory exists

**Content Structure**:

```markdown
# [FEATURE-ID]: [Feature Name]

**Epic:** [Link to Epic if applicable]

**Status:** [Planning / In Development / In Review / Done]

## Summary
[1-2 sentence summary of what this feature does and why it's needed]

## Task Description
[Detailed description of the feature, including:
- Current state/problem
- Desired outcome
- How it fits into the larger system]

## Key Components for Implementation

### 1. [Component Name]
- **Location:** `path/to/component`
- **Purpose:** [What this component does]
- **Important:** [Any constraints, existing code to reuse, or patterns to follow]

### 2. [Component Name]
- **Location:** `path/to/component`
- **Purpose:** [What this component does]

## Data Structure

### API Request Schema
```json
{
  "field1": "type",
  "field2": "type"
}
```

### API Response Schema
```json
{
  "field1": "type",
  "field2": "type"
}
```

## API Endpoints

### 1. [Endpoint Name]
- **Method:** `POST/GET/PUT/DELETE`
- **Endpoint:** `/api/path`
- **Request Body:** [Schema reference]
- **Action:** [What this endpoint does step-by-step]
- **Response:** `200 OK` [Response body structure]

### 2. [Endpoint Name]
[Same structure as above]

## Files to Create/Modify
- [ ] `path/to/file1.ts` - [Purpose]
- [ ] `path/to/file2.ts` - [Purpose]
- [ ] `path/to/test.test.ts` - [Purpose]

## Acceptance Criteria
- [ ] [Specific testable criterion 1]
- [ ] [Specific testable criterion 2]
- [ ] [Specific testable criterion 3]
- [ ] All unit tests pass
- [ ] Code follows coding standards
- [ ] Documentation is updated

## Dependencies on Other Components
- [Component/Module Name]: [How it's used]
- [Shared Utility]: Import from `path/to/utility`

## Constraints and Known Issues
- [Any technical limitations]
- [Known edge cases]
```

**Usage Notes**:
- Copy this template for each new feature
- Fill in all sections during planning phase (with Gemini)
- Use this as input for execution phase (with Claude Code)

**Success Criteria**:
- Template exists at `/.memory_bank/specs/feature_spec_template.md`
- All sections are clearly defined
- Examples show proper level of detail

---

#### Task 1.1.4.3: Create example_feature_spec.md

**File**: `/.memory_bank/specs/example_feature_spec.md`

**Purpose**: Provide real example based on article content

**Dependencies**: specs/ directory exists

**Content Structure** (from article):

```markdown
# FT-052: Development of API for IoT Device Fleet Management (Command & Control)

**Epic:** [EPIC-05: IoT Platform Core](EPIC-05-IoT-Platform-Core.md)

**Summary:** Implement central API gateway (Command & Control API) that serves as a single point for sending commands to IoT device fleet. API must accept commands, validate them, log and publish to Kafka for asynchronous delivery.

## Task Description
This API replaces old RPC service that worked unstably. New API doesn't deliver commands itself, but quickly registers them. Specialized workers will listen to Kafka topic and be responsible for delivery.

## Key Components for Implementation
1.  **FastAPI Application**: Foundation for API. Place in `services/command_control/main.py`.
2.  **Pydantic Schemas**: Models for request validation.
    - **Important:** Basic schemas like `BatchCommandRequest` are already implemented in `core/src/schemas.py`. **You must import and extend them**, not create new ones.
3.  **Kafka Producer**: For sending commands to `device-commands` topic.
    - **Important:** Kafka interaction must be done through ready client implemented in `core/src/kafka/kafka_client.py`. **Import and use `kafka_producer` from this module.**

## Kafka Event Structure
Each command sent to Kafka must conform to this JSON schema:
```json
{
  "command_id": "uuid",
  "device_id": "string",
  "command_type": "UPDATE_FIRMWARE" | "REBOOT",
  "metadata": { "source": "admin_dashboard", "issued_at": "timestamp" }
}
```

## API Endpoints for Implementation

### 1. Send command to single device

- **Endpoint:** `POST /commands/send`
- **Request Body:** `SendCommandRequest(device_id: str, command_type: str, payload: dict)`
- **Action:** Validate request, create record in `CommandHistoryDB` with status `queued`, publish event to Kafka.
- **Response:** `202 Accepted` `{ "success": true, "command_id": "...", "status": "queued" }`

### 2. Send command to device group

- **Endpoint:** `POST /commands/send/batch`
- **Request Body:** `BatchCommandRequest(device_ids: List[str], command_type: str, payload: dict)`
- **Action:** Generate `batch_id`. For each `device_id` from list perform same actions as for single endpoint.
- **Response:** `202 Accepted` `{ "success": true, "batch_id": "...", "status": "queued" }`

## Acceptance Criteria

- [ ]  All validation implemented using Pydantic **using schemas from `core/src/schemas.py`**.
- [ ]  Kafka interaction implemented **exclusively through client from `core/src/kafka/kafka_client.py`**.
- [ ]  All endpoints implemented and return correct statuses and response bodies.
- [ ]  Unit tests written verifying successful command sending to Kafka for each endpoint.
```

**Success Criteria**:
- Example spec exists at `/.memory_bank/specs/example_feature_spec.md`
- Shows proper level of detail
- Demonstrates reuse of existing components
- Includes clear acceptance criteria

---

## COMPONENT 2: Workflows Directory

**Purpose**: Create step-by-step instructions for standard development tasks

**Location**: `/.memory_bank/workflows/`

**Dependencies**:
- Memory Bank core files should exist
- guides/ and patterns/ directories should be created

**Success Criteria**:
- Directory exists
- At least 2 workflow files are created
- Workflows reference relevant guides and patterns

---

### 2.1 Create /workflows directory

#### Task 2.1.1: Create workflows directory

**Location**: `/.memory_bank/workflows/`

**Dependencies**: Memory Bank root directory exists

**Success Criteria**:
- Directory exists at `/.memory_bank/workflows/`

---

### 2.2 Core Workflow Files

#### Task 2.2.1: Create bug_fix.md workflow

**File**: `/.memory_bank/workflows/bug_fix.md`

**Purpose**: Standardize bug fixing process

**Dependencies**:
- coding_standards.md exists
- current_tasks.md exists

**Content Structure** (from article):

```markdown
# Bug Fix Process

## 1. Preparation and Analysis
- [ ] Create branch from `develop` using template `bugfix/TICKET-NUMBER-short-description`.
- [ ] Generate hypotheses about bug causes
- [ ] Localize problem in codebase. Find all relevant files.
- [ ] Analyze related documents in `guides/` and `patterns/` to understand context of affected system.

## 2. Development
- [ ] Make fixes to code, following **[coding standards](../guides/coding_standards.md)**.
- [ ] Run entire test suite (`npm test`) to ensure nothing broke.

## 3. Completion
- [ ] Update documentation if fix affected public component behavior.
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)**.
- [ ] Create Pull Request with brief solution description.
```

**Customization Notes**:
- Adjust branch naming convention to your team's standard
- Update test command to match your project
- Add additional steps if needed (e.g., notify stakeholders)

**Success Criteria**:
- File exists at `/.memory_bank/workflows/bug_fix.md`
- All steps are actionable and clear
- Links to related documents work
- Checklist format allows progress tracking

---

#### Task 2.2.2: Create new_feature.md workflow

**File**: `/.memory_bank/workflows/new_feature.md`

**Purpose**: Standardize new feature development process

**Dependencies**:
- coding_standards.md exists
- testing_strategy.md exists
- current_tasks.md exists
- specs/ directory exists

**Content Structure**:

```markdown
# New Feature Development Process

## 1. Preparation
- [ ] Create branch from `develop` using template `feature/TICKET-NUMBER-short-description`.
- [ ] Read specification in **[../specs/](../specs/)** to understand full scope of work.
- [ ] Study **[coding standards](../guides/coding_standards.md)** and **[architectural patterns](../patterns/)**.
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "In Progress".

## 2. Analysis and Design
- [ ] Identify existing components for reuse.
- [ ] Check **[tech_stack.md](../tech_stack.md)** for allowed technologies.
- [ ] Create list of files to create/modify.

## 3. Development
- [ ] Create necessary data models/schemas.
- [ ] Implement business logic according to specification.
- [ ] Follow patterns from **[../patterns/](../patterns/)**.
- [ ] Reuse existing utilities and components.

## 4. Testing
- [ ] Write unit tests according to **[testing strategy](../guides/testing_strategy.md)**.
- [ ] Run all tests: `npm test`
- [ ] Check code coverage (minimum 80%).
- [ ] Perform manual testing of key scenarios.

## 5. Documentation
- [ ] Update **[../tech_stack.md](../tech_stack.md)** if new dependencies added.
- [ ] Create/update guide in **[../guides/](../guides/)** if this is new subsystem.
- [ ] Add comments to complex code sections.

## 6. Completion
- [ ] Run linter and formatter.
- [ ] Update task status in **[../current_tasks.md](../current_tasks.md)** to "Done".
- [ ] Create Pull Request with detailed change description.
- [ ] List all changed files and their purpose.

## 7. Self-Review
- [ ] Verify all acceptance criteria from specification are met.
- [ ] Ensure architectural principles are not violated.
- [ ] Check for no code duplication.
```

**Success Criteria**:
- File exists at `/.memory_bank/workflows/new_feature.md`
- Covers complete feature lifecycle
- References all relevant guides and patterns
- Includes self-review step

---

#### Task 2.2.3: Create code_review.md workflow

**File**: `/.memory_bank/workflows/code_review.md`

**Purpose**: Standardize code review process for AI agent

**Dependencies**:
- coding_standards.md exists
- testing_strategy.md exists

**Content Structure**:

```markdown
# Code Review Process

## 1. General Check
- [ ] Pull Request contains clear change description.
- [ ] All changed files are related to the task being solved.
- [ ] No commented or dead code.

## 2. Standards Compliance
- [ ] Code follows **[coding standards](../guides/coding_standards.md)**.
- [ ] Variable, function and file naming follows conventions.
- [ ] Formatting matches linter settings.

## 3. Architecture and Patterns
- [ ] Changes don't violate architectural principles from **[../patterns/](../patterns/)**.
- [ ] New components follow established patterns.
- [ ] No duplication of functionality existing in other parts of project.

## 4. Code Quality
- [ ] Functions have single responsibility (SRP).
- [ ] No overly complex functions (>50 lines).
- [ ] Error handling used according to **[../patterns/error_handling.md](../patterns/error_handling.md)**.
- [ ] No "magic" numbers - named constants are used.

## 5. Tests
- [ ] All new functions covered by unit tests.
- [ ] Tests follow AAA pattern (Arrange-Act-Assert).
- [ ] All tests pass successfully.
- [ ] Code coverage didn't decrease.

## 6. Security
- [ ] No hardcoded passwords, tokens, API keys.
- [ ] User input is validated.
- [ ] No SQL injection or XSS vulnerabilities.

## 7. Performance
- [ ] No obvious performance issues (N+1 queries, unnecessary loops).
- [ ] Large data handled efficiently.

## 8. Documentation
- [ ] Documentation updated if public API changed.
- [ ] Complex algorithms have explanatory comments.
- [ ] **[../tech_stack.md](../tech_stack.md)** updated when dependencies added.

## 9. Final Check
- [ ] No merge conflicts.
- [ ] CI/CD pipeline passes successfully.
- [ ] All acceptance criteria from specification are met.
```

**Success Criteria**:
- File exists at `/.memory_bank/workflows/code_review.md`
- Comprehensive checklist for review
- References relevant standards and patterns
- Can be used by AI for self-review

---

## COMPONENT 3: Claude Code Configuration

**Purpose**: Set up Claude Code to automatically load Memory Bank context

**Location**: Project root or Claude config directory

**Dependencies**: Memory Bank must be fully set up

**Success Criteria**:
- Claude Code reads Memory Bank on every session
- Configuration is persistent
- Agent knows to update Memory Bank documents

---

### 3.1 Create CLAUDE.md (Session Initializer)

#### Task 3.1.1: Create CLAUDE.md in project root

**File**: `/CLAUDE.md`

**Purpose**: Instruct Claude Code to load Memory Bank context at session start

**Dependencies**: Memory Bank README.md exists

**Content Structure**:

```markdown
# Claude Code Configuration

## At the Start of ANY Work Session

**MANDATORY** perform the following actions:

1. Read the **`.memory_bank/README.md`** file completely.
2. Follow the mandatory reading sequence instructions from this file.
3. Follow links to relevant documents depending on task type:
   - For new feature → study specification in `.memory_bank/specs/`
   - For bug → study workflow `.memory_bank/workflows/bug_fix.md`
   - For technology questions → check `.memory_bank/tech_stack.md`

## Self-Documentation Principle

**IMPORTANT**: You not only read from Memory Bank, but also **update it**.

When performing tasks you MUST:
- Update status in `.memory_bank/current_tasks.md` (To Do → In Progress → Done)
- Create/update documentation in `.memory_bank/guides/` when implementing new subsystems
- Update `.memory_bank/tech_stack.md` when adding new dependencies
- Create new patterns in `.memory_bank/patterns/` when making architectural decisions

## Forbidden Actions

❌ **NEVER** add new dependencies without updating `.memory_bank/tech_stack.md`
❌ **NEVER** violate patterns from `.memory_bank/patterns/`
❌ **NEVER** reinvent what already exists in the project

## When Context is Lost

If you feel context was lost or compressed:
1. Use `/refresh_context` command
2. Re-read `.memory_bank/README.md`
3. Study recent commits to understand current state

---

**Remember**: Memory Bank is the single source of truth. Trust it more than your assumptions.
```

**Success Criteria**:
- File exists at `/CLAUDE.md`
- Contains clear instructions for session initialization
- Explains self-documentation principle
- Lists forbidden actions

---

### 3.2 Alternative: Add to existing project documentation

#### Task 3.2.1: Update existing README or setup docs

**Note**: If your project already has comprehensive documentation, you can add a section instead of creating CLAUDE.md

**Location**: `/README.md` or `/docs/AI_AGENT_GUIDE.md`

**Content to Add**:

```markdown
## For AI Agents

If you are an AI agent (like Claude Code), follow these instructions at the start of every session:

1. **Load Memory Bank**: Read `.memory_bank/README.md` first
2. **Follow Navigation**: Use links to find relevant documentation
3. **Update as you work**: Keep `.memory_bank/current_tasks.md` and other documents up to date
4. **Never violate**: Forbidden practices in `.memory_bank/tech_stack.md`
5. **When lost**: Use `/refresh_context` command

See **[.memory_bank/README.md](.memory_bank/README.md)** for complete navigation.
```

**Success Criteria**:
- AI agent instructions are visible in project documentation
- Points to Memory Bank as source of truth

---

## COMPONENT 4: Custom Commands Setup

**Purpose**: Create custom Claude Code commands for common workflows

**Location**: `~/.config/claude/commands/`

**Dependencies**:
- Memory Bank workflows must exist
- Claude Code must be installed

**Success Criteria**:
- Custom commands are created
- Commands can be invoked with `/command_name`
- Commands integrate with Memory Bank workflows

---

### 4.1 Setup Commands Directory

#### Task 4.1.1: Create commands directory

**Command**:
```bash
mkdir -p ~/.config/claude/commands/
```

**Success Criteria**:
- Directory exists at `~/.config/claude/commands/`

---

### 4.2 Core Custom Commands

#### Task 4.2.1: Create refresh_context.md command

**File**: `~/.config/claude/commands/refresh_context.md`

**Purpose**: Restore AI agent's context when it becomes compressed

**Dependencies**: Memory Bank exists

**Content Structure** (from article):

```markdown
Context may have been lost or compressed. Need to refresh memory. Perform the following steps:

1.  Re-read `.memory_bank/README.md` completely to understand overall structure.
2.  Study current tasks in `.memory_bank/current_tasks.md` to understand what we're working on.
3.  Review recent code changes to be aware of current state.

After this, output message "Context updated" and briefly describe current project status and active task.
```

**Usage**: `/refresh_context`

**Success Criteria**:
- File exists at `~/.config/claude/commands/refresh_context.md`
- Command successfully reloads context
- Agent provides status summary after execution

---

#### Task 4.2.2: Create m_bug.md command

**File**: `~/.config/claude/commands/m_bug.md`

**Purpose**: Initiate bug fix workflow

**Dependencies**:
- Memory Bank bug_fix workflow exists
- current_tasks.md exists

**Content Structure** (from article):

```markdown
You received /m_bug command. This means we're starting work on bug fix.

Your task: $ARGUMENTS.

Perform the following procedure:
1.  Carefully study `.memory_bank/workflows/bug_fix.md`.
2.  Follow the process described there step by step.
3.  Ask clarifying questions at each stage if something is unclear.
4.  Upon completion of all work, don't forget to update `.memory_bank/current_tasks.md` and other relevant documentation as specified in workflow.

Start with the first step.
```

**Usage**: `/m_bug Fix login button not responding on mobile`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_bug.md`
- Command accepts arguments via $ARGUMENTS
- Agent follows bug_fix workflow
- Agent updates current_tasks.md automatically

---

#### Task 4.2.3: Create m_feature.md command

**File**: `~/.config/claude/commands/m_feature.md`

**Purpose**: Initiate new feature development workflow

**Dependencies**:
- Memory Bank new_feature workflow exists
- specs/ directory exists

**Content Structure**:

```markdown
You received /m_feature command. This means we're starting work on new feature.

Your task: $ARGUMENTS.

Perform the following procedure:
1.  Find corresponding specification in `.memory_bank/specs/`. If not found, request specification path from user.
2.  Carefully study `.memory_bank/workflows/new_feature.md`.
3.  Follow the process described there step by step.
4.  Mandatory check `.memory_bank/tech_stack.md` before adding any dependencies.
5.  Upon completion of all work update:
    - `.memory_bank/current_tasks.md`
    - `.memory_bank/tech_stack.md` (if dependencies added)
    - Create/update guide in `.memory_bank/guides/` (if new subsystem)

Start with the first step.
```

**Usage**: `/m_feature Implement user authentication`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_feature.md`
- Command accepts arguments
- Agent follows new_feature workflow
- Agent updates relevant Memory Bank files

---

#### Task 4.2.4: Create m_review.md command

**File**: `~/.config/claude/commands/m_review.md`

**Purpose**: Initiate code review process

**Dependencies**: code_review workflow exists

**Content Structure**:

```markdown
You received /m_review command. This means code review is needed.

Code for review: $ARGUMENTS.

Perform the following procedure:
1.  Carefully study `.memory_bank/workflows/code_review.md`.
2.  Check code against all checklist items.
3.  For each found violation or issue:
    - Specify exact location (file, line)
    - Explain why it's a problem
    - Suggest specific solution
4.  Check compliance with:
    - **[Coding Standards](.memory_bank/guides/coding_standards.md)**
    - **[Architectural Patterns](.memory_bank/patterns/)**
    - **[Tech Stack](.memory_bank/tech_stack.md)**
5.  Provide final report:
    - ✅ What's done well
    - ⚠️ What needs improvement
    - ❌ What must be fixed

Start review.
```

**Usage**: `/m_review` or `/m_review path/to/changed/files`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_review.md`
- Agent performs systematic code review
- Agent references Memory Bank standards
- Agent provides actionable feedback

---

## COMPONENT 5: Three-Phase Workflow Setup

**Purpose**: Establish the Planning-Execution-Review process

**Dependencies**: All previous components

**Success Criteria**:
- Planning templates exist
- Execution workflows are integrated
- Review checklists are created

---

### 5.1 Planning Phase Setup (Gemini)

#### Task 5.1.1: Create planning prompt template

**File**: `/.memory_bank/templates/planning_prompt.md`

**Purpose**: Template for generating specifications with Gemini

**Content Structure**:

```markdown
# Planning Prompt Template (for use with Gemini)

## Context
I'm working on project [PROJECT_NAME]. Here's full codebase context (packaged via repomix):

[PASTE REPOMIX OUTPUT OR ATTACH FILE]

## Task
[DETAILED TASK DESCRIPTION]

## Result Requirements

**You should not write code immediately. Your task is to create detailed technical specification.**

Generate detailed specification in Markdown format that includes:

1. **Summary**: Brief description (1-2 sentences) what and why we're doing.

2. **Task Description**:
   - Current state/problem
   - Desired result
   - How it fits into overall system

3. **Key Components for Implementation**:
   - List of all components/modules that need to be created or modified
   - For each component:
     - Location (file path)
     - Purpose
     - Important constraints or existing code to reuse

4. **Data Structure**:
   - API Request/Response schemas (if applicable)
   - Data models
   - DB schemas (if applicable)

5. **API Endpoints** (if applicable):
   - Method, Endpoint path
   - Request Body structure
   - Action (step-by-step)
   - Response structure

6. **Files to Create/Modify**:
   - Checklist of files with purpose description for each

7. **Acceptance Criteria**:
   - List of specific, testable requirements
   - Must include: tests, standards compliance, documentation update

8. **Dependencies**:
   - Which existing components need to be used
   - Where to import from
   - Important constraints

## Important Instructions

- Analyze existing codebase and MANDATORY reuse existing components
- Specify exact file paths
- Emphasize what NOT to do (forbidden practices)
- Be maximally specific and detailed

## Output Format

Return result in format ready for saving to `.memory_bank/specs/[FEATURE-ID]-[feature-name].md`
```

**Usage**:
1. Use repomix to package project
2. Paste this template into Gemini
3. Iterate 3-5 times to refine
4. Save result in `.memory_bank/specs/`

**Success Criteria**:
- Template exists
- Clear instructions for Gemini
- Produces specs matching required format

---

#### Task 5.1.2: Create repomix configuration

**File**: `/repomix.config.json`

**Purpose**: Configure repomix for consistent project packaging

**Content Structure**:

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "removeComments": false,
    "showLineNumbers": true
  },
  "include": ["**/*"],
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "node_modules/**",
      ".git/**",
      "dist/**",
      "build/**",
      "*.log",
      ".env*",
      "repomix-output.*"
    ]
  }
}
```

**Usage**: `npx repomix`

**Success Criteria**:
- Configuration file exists
- Generates XML output suitable for Gemini
- Excludes sensitive and unnecessary files

---

### 5.2 Execution Phase Setup (Claude Code)

#### Task 5.2.1: Create execution checklist template

**File**: `/.memory_bank/templates/execution_checklist.md`

**Purpose**: Template for tracking execution progress

**Content Structure**:

```markdown
# Execution Checklist: [FEATURE-NAME]

**Spec**: [Link to spec file]

**Status**: In Progress

## Pre-Execution
- [ ] Spec has been read completely
- [ ] All referenced documents in Memory Bank have been reviewed
- [ ] Existing components for reuse have been identified
- [ ] Branch created: `feature/[ID]-[name]`
- [ ] Task updated in `.memory_bank/current_tasks.md` to "In Progress"

## Development
- [ ] All files listed in spec have been created/modified
- [ ] All API endpoints implemented (if applicable)
- [ ] Data models/schemas created
- [ ] Business logic implemented
- [ ] Existing components reused where specified
- [ ] No new dependencies added OR `.memory_bank/tech_stack.md` updated

## Testing
- [ ] Unit tests written for all new functions
- [ ] All tests pass: `[TEST_COMMAND]`
- [ ] Code coverage meets minimum (80%)
- [ ] Manual testing completed for key scenarios

## Documentation
- [ ] Code comments added for complex logic
- [ ] `.memory_bank/guides/` updated (if new subsystem)
- [ ] API documentation updated (if applicable)

## Quality
- [ ] Code follows `.memory_bank/guides/coding_standards.md`
- [ ] Patterns from `.memory_bank/patterns/` are followed
- [ ] No code duplication
- [ ] Error handling follows `.memory_bank/patterns/error_handling.md`

## Completion
- [ ] All acceptance criteria from spec are met
- [ ] Linter/formatter run
- [ ] Task updated in `.memory_bank/current_tasks.md` to "Done"
- [ ] Pull request created with detailed description
- [ ] Ready for review

## Blockers / Issues
[List any blockers or issues encountered]
```

**Success Criteria**:
- Template exists
- Comprehensive checklist
- Can be customized per feature
- Tracks blockers

---

### 5.3 Review Phase Setup

#### Task 5.3.1: Create review prompt template for Gemini

**File**: `/.memory_bank/templates/review_prompt.md`

**Purpose**: Template for generating review checklists with Gemini

**Content Structure**:

```markdown
# Review Checklist Generation Prompt (for Gemini)

## Context

Earlier in our session we created detailed technical specification for feature: [FEATURE_NAME]

Here's the final specification:
[PASTE FINAL SPEC]

## Task

Based on this specification, create detailed checklist for verifying completed work.

## Checklist Requirements

Checklist should include checks for:

1. **Functional Completeness**:
   - Each component from specification is implemented
   - All endpoints work according to description
   - All data structures match schemas

2. **Acceptance Criteria**:
   - Each criterion from "Acceptance Criteria" section of specification

3. **Component Reuse**:
   - All specified existing components are actually used
   - No functionality duplication

4. **Technical Requirements**:
   - Tests written and passing
   - Documentation updated
   - Code follows standards

5. **Specific Implementation Details**:
   - Checks specific to this feature
   - Edge cases handled
   - Integration with existing modules is correct

## Output Format

Return checklist in Markdown format with checkboxes, ready for passing to AI agent.

Each item should be:
- Specific and verifiable
- Reference specific files/components
- Include expected behavior
```

**Usage**:
1. After execution phase, go back to Gemini (context is preserved)
2. Use this prompt
3. Pass generated checklist to Claude Code
4. Claude Code performs self-review

**Success Criteria**:
- Template exists
- Generates actionable checklists
- Checklists are specific to the feature
- Can be used by Claude Code for self-review

---

#### Task 5.3.2: Create self-review command

**File**: `~/.config/claude/commands/m_self_review.md`

**Purpose**: Command for AI agent to perform self-review

**Content Structure**:

```markdown
You received /m_self_review command. This means you need to check your own work.

Checklist for verification: $ARGUMENTS

Perform the following procedure:

1. **Carefully study provided checklist**.

2. **For each checklist item**:
   - Check corresponding code/file
   - Mark ✅ if requirement is met
   - Mark ❌ if requirement is NOT met
   - Add comment with explanation

3. **For each unmet requirement**:
   - Explain why it's not done
   - Propose fix plan
   - If it's a blocker - mark as "CRITICAL"

4. **Automatically fix** simple issues:
   - Code formatting
   - Missing imports
   - Simple syntax errors

5. **For complex issues**:
   - Describe problem in detail
   - Suggest solution options
   - Ask user for confirmation before changes

6. **Final Report**:
   - How many items completed
   - How many require fixes
   - List of critical issues (if any)
   - Readiness assessment for merge (Ready / Needs Work)

Start verification.
```

**Usage**: `/m_self_review` (paste checklist from Gemini)

**Success Criteria**:
- Command exists
- Agent systematically checks all items
- Agent auto-fixes simple issues
- Agent reports complex problems
- Provides readiness assessment

---

## Summary: Complete Directory Structure

After completing all tasks, your project should have this structure:

```
project_root/
├── .memory_bank/
│   ├── README.md                          # Main navigation hub
│   ├── product_brief.md                   # Business context
│   ├── tech_stack.md                      # Technical passport
│   ├── current_tasks.md                   # Kanban board
│   │
│   ├── patterns/                          # Architectural patterns
│   │   ├── api_standards.md
│   │   └── error_handling.md
│   │
│   ├── guides/                            # Practical guides
│   │   ├── coding_standards.md
│   │   └── testing_strategy.md
│   │
│   ├── specs/                             # Feature specifications
│   │   ├── feature_spec_template.md
│   │   └── example_feature_spec.md
│   │
│   ├── workflows/                         # Step-by-step workflows
│   │   ├── bug_fix.md
│   │   ├── new_feature.md
│   │   └── code_review.md
│   │
│   └── templates/                         # Workflow templates
│       ├── planning_prompt.md
│       ├── execution_checklist.md
│       └── review_prompt.md
│
├── CLAUDE.md                              # Claude Code initializer
├── repomix.config.json                    # Repomix configuration
│
└── [your project files]

~/.config/claude/commands/                 # Custom commands (global)
├── refresh_context.md
├── m_bug.md
├── m_feature.md
├── m_review.md
└── m_self_review.md
```

---

## Implementation Order

### Phase 1: Foundation (Critical Path)
1. Create `.memory_bank/` directory
2. Create `README.md` (navigation hub)
3. Create `tech_stack.md` (technical passport)
4. Create `current_tasks.md` (Kanban board)
5. Create `product_brief.md` (business context)

### Phase 2: Core Structure
6. Create `patterns/` directory and core patterns
   - `api_standards.md`
   - `error_handling.md`
7. Create `guides/` directory and core guides
   - `coding_standards.md`
   - `testing_strategy.md`
8. Create `specs/` directory and templates
   - `feature_spec_template.md`
   - `example_feature_spec.md`

### Phase 3: Workflows
9. Create `workflows/` directory and core workflows
   - `bug_fix.md`
   - `new_feature.md`
   - `code_review.md`
10. Create `templates/` directory for three-phase process
    - `planning_prompt.md`
    - `execution_checklist.md`
    - `review_prompt.md`

### Phase 4: Integration
11. Create `CLAUDE.md` in project root
12. Create `repomix.config.json`
13. Create custom commands in `~/.config/claude/commands/`:
    - `refresh_context.md`
    - `m_bug.md`
    - `m_feature.md`
    - `m_review.md`
    - `m_self_review.md`

### Phase 5: Customization
14. Customize all files to match your specific:
    - Tech stack
    - Coding standards
    - Project structure
    - Team practices
15. Add project-specific patterns and guides
16. Create initial specs for current features

---

## Success Criteria for Complete Implementation

### Memory Bank Verification
- [ ] All core files exist and are populated
- [ ] Navigation links in README.md work correctly
- [ ] Tech stack accurately reflects project
- [ ] At least one example spec exists
- [ ] All workflows reference correct paths

### Claude Code Integration
- [ ] CLAUDE.md exists and instructs to read Memory Bank
- [ ] Custom commands are created and functional
- [ ] Commands can be invoked with `/command_name`
- [ ] Commands correctly reference Memory Bank paths

### Three-Phase Workflow
- [ ] Planning template exists and can be used with Gemini
- [ ] Execution checklists can be generated from specs
- [ ] Review checklists can be generated by Gemini
- [ ] Self-review command works correctly

### Testing the System
- [ ] Start new Claude Code session → agent reads Memory Bank
- [ ] Use `/refresh_context` → context is restored
- [ ] Use `/m_feature` → agent follows new_feature workflow
- [ ] Use `/m_bug` → agent follows bug_fix workflow
- [ ] Agent updates `current_tasks.md` automatically
- [ ] Agent references patterns and guides in its work

---

## Maintenance Guidelines

### Keep Memory Bank Updated
- Update `current_tasks.md` after every work session
- Add new patterns when architectural decisions are made
- Create new guides when new subsystems are added
- Update `tech_stack.md` when dependencies change

### Evolve Workflows
- Refine workflows based on what works
- Add new workflows for new types of tasks
- Update acceptance criteria based on learnings

### Periodic Review
- Monthly: Review all Memory Bank documents for accuracy
- Quarterly: Assess if new patterns/guides are needed
- After major features: Update example specs

---

## Troubleshooting

### Agent Not Reading Memory Bank
- Check if CLAUDE.md exists in project root
- Verify paths in CLAUDE.md are correct
- Try `/refresh_context` command

### Agent Not Following Workflows
- Ensure workflow files exist at specified paths
- Check that custom commands reference correct workflow paths
- Verify checklist format is correct (markdown checkboxes)

### Agent Making Forbidden Changes
- Review `tech_stack.md` - are forbidden practices clearly listed?
- Add more specific constraints to relevant patterns
- Use `/m_review` to check compliance

### Context Still Getting Lost
- Use more frequent `/refresh_context` calls
- Break tasks into smaller subtasks
- Use subagents for specialized tasks (future enhancement)

---

## Next Steps After Implementation

1. **Test the System**: Run through complete workflow for one feature
2. **Gather Learnings**: Document what works and what doesn't
3. **Iterate**: Refine prompts, workflows, and patterns
4. **Scale**: Add more patterns, guides, and workflows as needed
5. **Share with Team**: If working with others, onboard them to the system

---

## References

- **Original Article**: `/Users/alexanderfedin/Projects/hapyy/due_diligence_bot/AI_SWE_article.md`
- **Cline Memory Bank Docs**: https://docs.cline.bot/prompting/cline-memory-bank
- **Repomix**: https://github.com/yamadashy/repomix
- **Claude Code**: https://claude.com/claude-code

---

*This implementation plan is based on the AI SWE methodology from the article. Adapt it to your specific project needs while maintaining the core principles of structured knowledge management and systematic workflows.*
