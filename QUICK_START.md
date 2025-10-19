# AI SWE Quick Start Guide

**Project**: Due Diligence Bot
**Last Updated**: 2025-10-19

---

## New to the Project?

### 3-Step Onboarding

1. **Read Memory Bank Entry Point**
   ```bash
   cat .memory_bank/README.md
   ```
   This tells you what to read before ANY task.

2. **Read Claude Code Configuration**
   ```bash
   cat CLAUDE.md
   ```
   Learn project-specific patterns and requirements.

3. **Verify Custom Commands**
   ```bash
   ls ~/.config/claude/commands/
   ```
   Should show: `m_bug.md`, `m_feature.md`, `m_review.md`, `m_self_review.md`, `refresh_context.md`

---

## Daily Workflow Cheat Sheet

### Starting Your Day

```
# In Claude Code:
/refresh_context
```

This refreshes AI context with current project state.

---

### Implementing a New Feature

**Step 1: Planning (Gemini)**
```bash
# Package entire project
repomix

# Upload repomix-output.txt to Gemini
# Ask: "Create detailed spec for [FEATURE]"
# Save to: .memory_bank/specs/feature-name.md
```

**Step 2: Execution (Claude Code)**
```
/refresh_context
/m_feature [Feature description]
```

Claude Code will:
- Read your spec
- Follow systematic workflow
- Implement with tests
- Update Memory Bank
- Create PR

**Step 3: Review (Gemini + Claude Code)**
```
# In Gemini: "Generate review checklist for this spec"

# In Claude Code:
/m_self_review
[Paste checklist from Gemini]
```

---

### Fixing a Bug

```
/refresh_context
/m_bug [Bug description]
```

Claude Code will:
- Create bugfix branch
- Localize problem
- Implement fix
- Run tests
- Create PR

---

### Reviewing Code

```
/m_review [optional: specific files]
```

Gets comprehensive review against:
- Coding standards
- Security
- Performance
- Tests
- Documentation

---

## Custom Commands Reference

| Command | Usage | When to Use |
|---------|-------|-------------|
| `/refresh_context` | `/refresh_context` | Start of session, after 50+ messages, when context lost |
| `/m_bug` | `/m_bug Fix login issue` | Fixing existing functionality |
| `/m_feature` | `/m_feature Add PDF export` | Implementing new functionality |
| `/m_review` | `/m_review src/auth/` | Before merging, quality check |
| `/m_self_review` | `/m_self_review` + checklist | After implementation, validation |

---

## Memory Bank Structure

```
.memory_bank/
├── README.md              # START HERE - Navigation hub
├── product_brief.md       # What we're building and why
├── tech_stack.md          # Technologies and standards
├── current_tasks.md       # Active work
│
├── guides/
│   ├── coding_standards.md    # How to write code
│   └── testing_strategy.md    # How to test
│
├── patterns/
│   ├── api_standards.md       # API design patterns
│   └── error_handling.md      # Error handling patterns
│
├── workflows/
│   ├── new_feature.md         # Feature development process
│   ├── bug_fix.md             # Bug fixing process
│   ├── code_review.md         # Code review checklist
│   ├── self_review.md         # Self-review process
│   └── refactoring.md         # Refactoring guidelines
│
└── specs/                 # Feature specifications
```

---

## Key Documents Quick Access

| Document | Purpose | When to Read |
|----------|---------|--------------|
| [README.md](README.md) | Project overview | First time, onboarding |
| [.memory_bank/README.md](.memory_bank/README.md) | Memory Bank hub | **Before every task** |
| [CLAUDE.md](CLAUDE.md) | Claude Code config | First time, when confused |
| [COMMANDS_DOCUMENTATION.md](COMMANDS_DOCUMENTATION.md) | Commands guide | Learning commands |
| [AI_SWE_SETUP_VALIDATION.md](AI_SWE_SETUP_VALIDATION.md) | Setup validation | Troubleshooting setup |

---

## Common Scenarios

### Scenario: Adding a new dependency

1. Check if it's allowed in `.memory_bank/tech_stack.md`
2. If not listed, discuss with team first
3. After approval, **UPDATE** `.memory_bank/tech_stack.md`
4. Install with `poetry add package-name`
5. Document why it's needed

**Never** add dependencies without updating Memory Bank.

---

### Scenario: Not sure how to implement something

1. Check if similar code exists:
   ```bash
   grep -r "similar_function" .
   ```
2. Check patterns:
   ```bash
   cat .memory_bank/patterns/api_standards.md
   ```
3. Check guides:
   ```bash
   cat .memory_bank/guides/coding_standards.md
   ```
4. If still unclear, ask team

---

### Scenario: Context lost during long session

```
/refresh_context
```

If still lost:
1. Break task into smaller subtasks
2. Create detailed spec in Gemini first
3. Work on one subtask at a time

---

### Scenario: Tests failing after implementation

```
# In Claude Code:
/m_self_review

Checklist:
- [ ] All tests passing
- [ ] No linting errors
- [ ] Type checking passes
- [ ] Coverage >= 80%
```

Claude Code will:
- Check each requirement
- Auto-fix simple issues
- Report complex problems
- Suggest solutions

---

## Before Committing Checklist

```bash
# Format
poetry run black .

# Lint
poetry run ruff check .

# Type check
poetry run mypy .

# Test
poetry run pytest

# Coverage
poetry run pytest --cov=. --cov-report=html
```

All must pass before creating PR.

---

## Troubleshooting Quick Fixes

### Command not found
```bash
# Verify commands exist
ls ~/.config/claude/commands/

# If missing, they need to be created
# See COMMANDS_DOCUMENTATION.md for details
```

### Workflow not followed
```
# Always refresh first
/refresh_context

# Then run command
/m_feature [description]
```

### Spec not found
```bash
# Verify spec exists
ls .memory_bank/specs/

# Create spec in Gemini first (Planning phase)
# Save to .memory_bank/specs/
```

---

## Best Practices

### DO

- ✅ Always start with `/refresh_context`
- ✅ Use Gemini for planning (large context)
- ✅ Use Claude Code for execution (best code gen)
- ✅ Update Memory Bank when adding dependencies
- ✅ Follow workflows, not ad-hoc implementation
- ✅ Run tests before committing
- ✅ Use `/m_self_review` before requesting review

### DON'T

- ❌ Skip planning phase for complex features
- ❌ Add dependencies without updating `tech_stack.md`
- ❌ Ignore workflows and implement ad-hoc
- ❌ Commit without running tests
- ❌ Use `Any` type hints (be specific)
- ❌ Make synchronous I/O calls in async code
- ❌ Store secrets in code (use environment variables)

---

## Three-Phase Workflow Visual

```
┌────────────────────────────────────────────────────────────┐
│                     PHASE 1: PLANNING                      │
│                        (Gemini)                            │
├────────────────────────────────────────────────────────────┤
│ 1. Package project: repomix                                │
│ 2. Upload to Gemini (2M context window)                    │
│ 3. Request detailed specification                          │
│ 4. Save to .memory_bank/specs/feature-name.md             │
│                                                            │
│ Output: Comprehensive spec with acceptance criteria        │
└────────────────────────────────────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────────┐
│                    PHASE 2: EXECUTION                      │
│                     (Claude Code)                          │
├────────────────────────────────────────────────────────────┤
│ 1. /refresh_context                                        │
│ 2. /m_feature [description]                                │
│ 3. Claude Code reads spec from Memory Bank                 │
│ 4. Follows .memory_bank/workflows/new_feature.md           │
│ 5. Implements systematically with tests                    │
│ 6. Updates Memory Bank files                               │
│ 7. Creates branch and commits                              │
│                                                            │
│ Output: Working implementation with tests                  │
└────────────────────────────────────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────────┐
│                     PHASE 3: REVIEW                        │
│                  (Gemini + Claude Code)                    │
├────────────────────────────────────────────────────────────┤
│ 1. In Gemini: "Generate review checklist"                  │
│ 2. Copy checklist                                          │
│ 3. In Claude Code: /m_self_review                          │
│ 4. Paste checklist                                         │
│ 5. Claude Code validates each requirement                  │
│ 6. Auto-fixes simple issues                                │
│ 7. Reports complex issues                                  │
│ 8. Iterate until ready                                     │
│                                                            │
│ Output: Validated, ready-to-merge implementation           │
└────────────────────────────────────────────────────────────┘
```

---

## Need More Details?

- **Full Setup Validation**: [AI_SWE_SETUP_VALIDATION.md](AI_SWE_SETUP_VALIDATION.md)
- **Commands Documentation**: [COMMANDS_DOCUMENTATION.md](COMMANDS_DOCUMENTATION.md)
- **Implementation Plan**: [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)
- **Project README**: [README.md](README.md)
- **Claude Configuration**: [CLAUDE.md](CLAUDE.md)

---

## Getting Help

1. **Context Lost?** → `/refresh_context`
2. **Don't know where to start?** → `cat .memory_bank/README.md`
3. **Forgot a command?** → `cat COMMANDS_DOCUMENTATION.md`
4. **Setup issues?** → `cat AI_SWE_SETUP_VALIDATION.md`
5. **Still stuck?** → Ask team

---

**Remember**: The Memory Bank is your single source of truth. Trust it more than your assumptions.

**Golden Rule**: Always start with `/refresh_context` and read `.memory_bank/README.md` before any task.
