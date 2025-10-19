# Memory Bank: Single Source of Truth for the Project

This memory bank is your main source of information. Before starting any task, **mandatory** review this file and follow the relevant links.

## Mandatory Reading Sequence Before ANY Task

1. **[Tech Stack](./tech_stack.md)**: Learn which technologies, libraries and versions we use.
2. **[Coding Standards](./guides/coding_standards.md)**: Review formatting rules, naming conventions and best practices.
3. **[Current Tasks](./current_tasks.md)**: Check the list of active tasks to understand the team's current focus.

## Knowledge System Map

### 1. About the Project (Context "WHY")
- **[Product Brief](./product_brief.md)**: Business goals, target audience, key features. Refer here to understand *WHAT* we are building and *FOR WHOM*.

### 2. Technical Foundation (Context "HOW")
- **[Tech Stack](./tech_stack.md)**: Complete list of frameworks, libraries and their versions. **PROHIBITED** to add new dependencies without updating this file.
- **[Architectural Patterns](./patterns/)**: Fundamental decisions. Study them before making changes to module structure.
  - **[API Standards](./patterns/api_standards.md)**: API design standards
  - **[Error Handling](./patterns/error_handling.md)**: Error handling patterns
- **[Subsystem Guides](./guides/)**: Detailed description of key modules and practices.
  - **[Coding Standards](./guides/coding_standards.md)**: Coding standards
  - **[Testing Strategy](./guides/testing_strategy.md)**: Testing strategy

### 3. Processes and Tasks (Context "WHAT TO DO")
- **[Workflows](./workflows/)**: Step-by-step instructions for standard tasks. Choose the appropriate workflow for your current task.
  - **[New Feature Development](./workflows/new_feature.md)** (created when needed)
  - **[Bug Fix](./workflows/bug_fix.md)** (created when needed)
- **[Specifications (Technical Requirements)](./specs/)**: Detailed technical specifications for new features.

---

## Project Philosophy

**Due Diligence Bot** is an automated system for conducting comprehensive verification of companies and projects. Our approach:

1. **AI-First**: We use LLM capabilities for data analysis and structuring
2. **Asynchronous**: All I/O operations are asynchronous for maximum performance
3. **Type Safety**: Strict typing to prevent errors in early stages
4. **Modularity**: Clear separation of responsibilities between components

## Working Rules

**Rule 1:** If you make changes that affect architecture or add a new dependency, you must update the corresponding document in Memory Bank.

**Rule 2:** Before starting work on a task, always check `current_tasks.md` and update the task status to "In Progress".

**Rule 3:** Always follow patterns from `patterns/` and standards from `guides/`. If in doubt — ask.

**Rule 4:** All external integrations must be documented and follow API standards from `patterns/api_standards.md`.

---

**Remember**: Memory Bank is a living document. Update it as the project evolves.
