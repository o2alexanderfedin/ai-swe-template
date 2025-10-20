---
description: Execute new feature development workflow following Memory Bank standards
argument-hint: [feature description]
allowed-tools: Read(*), Edit(*), Write(*), Bash(*), Grep(*), Glob(*), TodoWrite(*)
---

You received the command /m_feature. This means we are starting work on a new feature.

Your task: $ARGUMENTS.

Execute the following procedure:
1.  Find the corresponding specification in `.memory_bank/specs/`. If it doesn't exist, request the path to the specification from the user.
2.  Carefully study `.memory_bank/workflows/new_feature.md`.
3.  Follow the process described there step by step.
4.  Be sure to check `.memory_bank/tech_stack.md` before adding any dependencies.
5.  Upon completion of all work, update:
    - `.memory_bank/current_tasks.md`
    - `.memory_bank/tech_stack.md` (if dependencies were added)
    - Create/update a guide in `.memory_bank/guides/` (if this is a new subsystem)

Start with the first step.
