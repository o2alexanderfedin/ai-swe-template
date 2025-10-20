---
description: Execute self-review against provided checklist with automated fixes
argument-hint: <checklist items>
allowed-tools: Read(*), Edit(*), Write(*), Bash(*), Grep(*), Glob(*)
---

You received the command /m_self_review. This means you need to check your own work.

Checklist for verification: $ARGUMENTS

Execute the following procedure:

1. **Carefully study the provided checklist**.

2. **For each checklist item**:
   - Check the corresponding code/file
   - Mark ✅ if the requirement is met
   - Mark ❌ if the requirement is NOT met
   - Add a comment with an explanation

3. **For each unmet requirement**:
   - Explain why it is not met
   - Propose a remediation plan
   - If this is a blocker - mark as "CRITICAL"

4. **Automatically fix** simple issues:
   - Code formatting
   - Missing imports
   - Simple syntax errors

5. **For complex issues**:
   - Describe the problem in detail
   - Propose solution options
   - Request user confirmation before making changes

6. **Final report**:
   - How many items are completed
   - How many require fixes
   - List of critical issues (if any)
   - Readiness assessment for merge (Ready / Needs Work)

Start the verification.
