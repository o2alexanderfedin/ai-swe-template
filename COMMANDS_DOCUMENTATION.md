# Custom Claude Code Commands - Documentation

This document provides comprehensive documentation for all custom Claude Code commands created for the AI SWE methodology.

## Overview

Custom commands are markdown files stored in `~/.config/claude/commands/` that extend Claude Code's functionality. They enable workflow automation, context management, and integration with the Memory Bank system.

## How Custom Commands Work

1. Commands are invoked using the `/command_name` syntax in Claude Code
2. The `$ARGUMENTS` variable passes user input to the command
3. Commands execute as prompts that guide the AI agent's behavior
4. Commands can reference Memory Bank documents and workflows

## Available Commands

### 1. /refresh_context

**Purpose**: Restore AI agent's context when it becomes compressed or lost

**File**: `~/.config/claude/commands/refresh_context.md`

**Usage**:
```
/refresh_context
```

**What it does**:
1. Re-reads `.memory_bank/README.md` to understand project structure
2. Reviews current tasks in `.memory_bank/current_tasks.md`
3. Checks recent code changes for current state
4. Outputs a context summary with project status

**When to use**:
- After long conversation threads
- When the agent seems to forget project context
- Before starting a new major task
- After switching between different parts of the codebase

**Example output**:
```
Context updated

Current project status:
- Project: Due Diligence Bot
- Active task: Setting up Memory Bank structure
- Recent changes: Creating custom commands for AI SWE
```

---

### 2. /m_bug

**Purpose**: Initiate bug fix workflow following AI SWE methodology

**File**: `~/.config/claude/commands/m_bug.md`

**Usage**:
```
/m_bug Fix login button not responding on mobile devices
```

**Parameters**:
- `$ARGUMENTS`: Description of the bug to fix

**What it does**:
1. Reads the bug fix workflow from `.memory_bank/workflows/bug_fix.md`
2. Follows the standardized process step-by-step:
   - Creates appropriate branch
   - Analyzes and localizes the problem
   - Implements the fix following coding standards
   - Runs tests
   - Updates documentation
3. Updates `.memory_bank/current_tasks.md` automatically
4. Asks clarifying questions when needed

**Workflow steps** (from bug_fix.md):
- **Preparation**: Create branch, generate hypotheses, localize problem
- **Development**: Implement fix following coding standards, run tests
- **Completion**: Update documentation, update task status, create PR

**Example**:
```
/m_bug User authentication fails when using special characters in password
```

The agent will:
- Create branch `bugfix/AUTH-123-special-chars-password`
- Analyze authentication module
- Find validation logic issues
- Implement fix
- Run test suite
- Update current_tasks.md to "Done"
- Create PR with description

---

### 3. /m_feature

**Purpose**: Initiate new feature development workflow

**File**: `~/.config/claude/commands/m_feature.md`

**Usage**:
```
/m_feature Implement user profile management
```

**Parameters**:
- `$ARGUMENTS`: Description of the feature to implement

**What it does**:
1. Looks for specification in `.memory_bank/specs/`
2. Reads the new feature workflow from `.memory_bank/workflows/new_feature.md`
3. Follows comprehensive development process:
   - Preparation and spec reading
   - Analysis and design
   - Development
   - Testing
   - Documentation
   - Self-review
4. Checks `.memory_bank/tech_stack.md` before adding dependencies
5. Updates multiple Memory Bank files as needed

**Workflow steps** (from new_feature.md):
1. **Preparation**: Create branch, read spec, study standards
2. **Analysis**: Identify reusable components, check tech stack
3. **Development**: Implement according to spec, follow patterns
4. **Testing**: Write unit tests, check coverage
5. **Documentation**: Update tech stack, create guides if needed
6. **Completion**: Run linter, update tasks, create PR
7. **Self-review**: Verify acceptance criteria

**Example**:
```
/m_feature Add export to PDF functionality
```

The agent will:
- Look for `./memory_bank/specs/export-pdf.md`
- If not found, ask for spec location
- Create branch `feature/EXP-42-pdf-export`
- Check tech_stack.md for allowed PDF libraries
- Implement feature following spec
- Write tests
- Update current_tasks.md
- Create/update guide if new subsystem

---

### 4. /m_review

**Purpose**: Conduct comprehensive code review

**File**: `~/.config/claude/commands/m_review.md`

**Usage**:
```
/m_review
```
or
```
/m_review src/auth/login.py src/auth/validators.py
```

**Parameters**:
- `$ARGUMENTS` (optional): Specific files/paths to review

**What it does**:
1. Reads code review workflow from `.memory_bank/workflows/code_review.md`
2. Performs systematic review checking:
   - General structure and clarity
   - Compliance with coding standards
   - Architecture and patterns adherence
   - Code quality (SRP, complexity, error handling)
   - Test coverage
   - Security issues
   - Performance concerns
   - Documentation completeness
3. Provides detailed feedback with file locations and line numbers
4. Suggests specific improvements

**Review checklist** (from code_review.md):
- General: PR description, relevant files, no dead code
- Standards: Coding standards, naming conventions, formatting
- Architecture: Patterns compliance, no duplication
- Quality: Single responsibility, error handling, no magic numbers
- Tests: Coverage, AAA pattern, all passing
- Security: No hardcoded secrets, input validation, no vulnerabilities
- Performance: No N+1 queries, efficient data handling
- Documentation: Updated docs, complex logic explained

**Example output**:
```
✅ What was done well:
- Code follows established patterns
- Good test coverage (92%)
- Clear variable names

⚠️ What needs improvement:
- src/utils/parser.py:45 - function too long (78 lines)
- Suggestion: split into parse_header() and parse_body()

❌ What must be fixed:
- src/auth/token.py:23 - hardcoded secret key
- Solution: use environment variable
```

---

### 5. /m_self_review

**Purpose**: Enable AI agent to perform self-review against a checklist

**File**: `~/.config/claude/commands/m_self_review.md`

**Usage**:
```
/m_self_review
[Then paste the checklist from Gemini]
```

**Parameters**:
- `$ARGUMENTS`: The checklist to review against (usually from Gemini-generated review checklist)

**What it does**:
1. Takes a detailed checklist (generated during Planning phase)
2. Systematically verifies each requirement
3. Marks items as ✅ complete or ❌ incomplete
4. Auto-fixes simple issues (formatting, imports, syntax)
5. Identifies complex problems and proposes solutions
6. Provides readiness assessment (Ready / Needs Work)

**Self-review process**:
1. Study the provided checklist
2. For each item:
   - Check corresponding code/file
   - Mark status (✅/❌)
   - Add explanation
3. For incomplete items:
   - Explain why not done
   - Propose fix plan
   - Mark critical blockers
4. Auto-fix simple issues
5. Describe complex issues and ask for confirmation
6. Generate final report

**Example workflow**:
```
# 1. After implementing feature with Claude Code
# 2. Go back to Gemini (where spec was created)
# 3. Ask Gemini: "Generate review checklist for this spec"
# 4. Copy checklist
# 5. In Claude Code:

/m_self_review

# Then paste checklist:
- [ ] API endpoint /api/users implemented
- [ ] Request validation using UserSchema from core/schemas.py
- [ ] Kafka integration using core/kafka/kafka_client.py
- [ ] Unit tests for all endpoints
- [ ] Error handling follows patterns/error_handling.md
```

**Example output**:
```
Final report:
- Completed: 8/10 items
- Requires fixes: 2 items
- Critical issues: 0

Readiness assessment: Needs Work

Details:
✅ API endpoint implemented
✅ Validation via UserSchema
❌ Kafka integration - using incorrect method
   Fix plan: replace custom_publish() with kafka_producer.send()
✅ Unit tests written
❌ CRITICAL: Error handling does not follow patterns
   Need to wrap in ApplicationError class
```

---

## Integration with Memory Bank

All commands are designed to work seamlessly with Memory Bank:

### Commands that READ from Memory Bank:
- `/refresh_context` → `.memory_bank/README.md`, `current_tasks.md`
- `/m_bug` → `.memory_bank/workflows/bug_fix.md`
- `/m_feature` → `.memory_bank/workflows/new_feature.md`, `specs/`, `tech_stack.md`
- `/m_review` → `.memory_bank/workflows/code_review.md`, `guides/`, `patterns/`

### Commands that WRITE to Memory Bank:
- `/m_bug` → updates `.memory_bank/current_tasks.md`
- `/m_feature` → updates `current_tasks.md`, `tech_stack.md`, potentially creates new guides

---

## Three-Phase Workflow Integration

These commands integrate with the Planning-Execution-Review methodology:

### Phase 1: Planning (with Gemini)
- Use repomix to package project
- Create detailed spec with Gemini
- Save to `.memory_bank/specs/`

### Phase 2: Execution (with Claude Code)
- Use `/m_feature [description]` or `/m_bug [description]`
- Agent reads spec and follows workflow
- Implementation happens systematically

### Phase 3: Review (Gemini + Claude Code)
- Ask Gemini to generate review checklist from spec
- Use `/m_self_review` with checklist
- Agent finds and fixes issues
- Iterate until ready

---

## Installation and Setup

### Prerequisites
- Claude Code installed
- Memory Bank set up in project

### Installation Steps

1. **Create commands directory**:
```bash
mkdir -p ~/.config/claude/commands/
```

2. **Verify commands are created**:
```bash
ls -la ~/.config/claude/commands/
```

You should see:
- refresh_context.md
- m_bug.md
- m_feature.md
- m_review.md
- m_self_review.md

3. **Test a command**:
Open Claude Code and type:
```
/refresh_context
```

---

## Best Practices

### When to use /refresh_context
- Start of every work session
- After long conversations (>100 messages)
- When switching between unrelated tasks
- Before critical operations (review, deployment)

### When to use /m_bug vs /m_feature
- Use `/m_bug` for:
  - Fixing existing functionality
  - Addressing reported issues
  - Correcting errors or unexpected behavior

- Use `/m_feature` for:
  - Adding new functionality
  - Implementing new user stories
  - Extending existing features

### Effective /m_self_review usage
1. Always generate checklist with Gemini first (keeps context)
2. Make checklist specific and detailed
3. Include non-functional requirements (security, performance)
4. Reference specific files and acceptance criteria
5. Run after initial implementation, before human review

### Command chaining workflow
```
# 1. Start fresh
/refresh_context

# 2. Implement feature
/m_feature Add user notification system

# 3. Self-review (with Gemini-generated checklist)
/m_self_review
[paste checklist]

# 4. Final review
/m_review

# 5. If context lost during long session
/refresh_context
```

---

## Troubleshooting

### Command not found
**Problem**: Typing `/m_bug` shows "command not found"

**Solution**:
1. Check file exists: `ls ~/.config/claude/commands/m_bug.md`
2. Verify file has correct extension (.md)
3. Restart Claude Code
4. Check file permissions: `chmod 644 ~/.config/claude/commands/*.md`

### Agent not following workflow
**Problem**: Agent executes command but doesn't follow the workflow

**Solution**:
1. Verify workflow file exists in Memory Bank
2. Check paths in command file are correct
3. Use absolute paths if needed
4. Run `/refresh_context` first

### $ARGUMENTS not working
**Problem**: Arguments not being passed to command

**Solution**:
1. Ensure space after command: `/m_bug Fix login` not `/m_bugFix login`
2. Verify `$ARGUMENTS` variable is in command file
3. Check for typos in variable name

### Context still lost
**Problem**: Even after `/refresh_context`, agent seems confused

**Solution**:
1. Check Memory Bank files exist and are up to date
2. Verify `.memory_bank/README.md` has correct links
3. Update `current_tasks.md` manually if needed
4. Consider breaking task into smaller subtasks
5. Use subagents for specialized tasks

---

## Extending the System

### Creating new custom commands

1. **Create command file**:
```bash
nano ~/.config/claude/commands/your_command.md
```

2. **Write command prompt**:
```markdown
You received the command /your_command.

Your task: $ARGUMENTS.

Execute the following procedure:
1. [Step 1]
2. [Step 2]
3. [Step 3]
```

3. **Test the command**:
```
/your_command test arguments
```

### Example: Create deployment command

**File**: `~/.config/claude/commands/m_deploy.md`

```markdown
You received the command /m_deploy. Preparing for deployment.

Environment: $ARGUMENTS (production/staging/development)

Execute the following procedure:
1. Verify all tests pass: `npm test`
2. Verify build succeeds: `npm run build`
3. Study `.memory_bank/workflows/deployment.md` (if exists)
4. Check environment variables for the specified environment
5. Output deployment readiness checklist
6. Ask for confirmation before executing deployment

Do not execute deployment without explicit user confirmation.
```

**Usage**:
```
/m_deploy production
```

---

## Command Reference Quick Sheet

| Command | Purpose | Arguments | Updates Memory Bank |
|---------|---------|-----------|-------------------|
| `/refresh_context` | Restore context | None | No |
| `/m_bug` | Fix bug | Bug description | Yes (current_tasks.md) |
| `/m_feature` | Implement feature | Feature description | Yes (current_tasks.md, tech_stack.md, guides/) |
| `/m_review` | Review code | Optional: file paths | No |
| `/m_self_review` | Self-review | Checklist | No |

---

## Additional Resources

- **Implementation Plan**: `./IMPLEMENTATION_PLAN.md`
- **AI SWE Article**: `./AI_SWE_article.md`
- **Memory Bank Docs**: https://docs.cline.bot/prompting/cline-memory-bank
- **Claude Code Docs**: https://claude.com/claude-code
- **Repomix**: https://github.com/yamadashy/repomix

---

## Version History

- **v1.0** (2025-10-19): Initial creation of all 5 custom commands
  - refresh_context.md
  - m_bug.md
  - m_feature.md
  - m_review.md
  - m_self_review.md

---

## Support and Feedback

For questions, issues, or suggestions:
- Review the Implementation Plan for detailed setup instructions
- Check Memory Bank structure is properly configured
- Verify all workflow files exist in `.memory_bank/workflows/`
- Ensure tech_stack.md and coding_standards.md are populated

---

**Remember**: These commands are tools to enforce systematic AI SWE methodology. They work best when:
1. Memory Bank is properly set up
2. Specs are detailed and complete
3. Workflows are customized to your project
4. Team follows the three-phase process (Planning-Execution-Review)
