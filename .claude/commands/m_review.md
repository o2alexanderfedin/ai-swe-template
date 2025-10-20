---
description: Conduct code review following Memory Bank standards and checklists
argument-hint: [file paths to review]
allowed-tools: Read(*), Grep(*), Glob(*)
---

You received the command /m_review. This means you need to conduct a code review.

Code for review: $ARGUMENTS.

Execute the following procedure:
1.  Carefully study `.memory_bank/workflows/code_review.md`.
2.  Check the code against all checklist items.
3.  For each violation or issue found:
    - Indicate the specific location (file, line)
    - Explain why this is a problem
    - Suggest a concrete solution
4.  Verify compliance with:
    - **[Coding standards](.memory_bank/guides/coding_standards.md)**
    - **[Architectural patterns](.memory_bank/patterns/)**
    - **[Technology stack](.memory_bank/tech_stack.md)**
5.  Provide a final report:
    - ✅ What was done well
    - ⚠️ What needs improvement
    - ❌ What must be fixed

Start the review.
