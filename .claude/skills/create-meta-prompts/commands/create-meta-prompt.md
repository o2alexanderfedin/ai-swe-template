---
description: Create optimized prompts for Claude-to-Claude pipelines (research -> plan -> implement)
argument-hint: [task description]
allowed-tools: Skill(create-meta-prompts)
---

<objective>
Invoke the create-meta-prompts skill for expert guidance on creating prompts optimized for multi-stage workflows.

This provides structured workflow for building prompts that produce research.md and plan.md outputs designed for subsequent Claude consumption.
</objective>

<process>
1. Invoke the Skill tool with skill name: create-meta-prompts
2. Pass through the task description: $ARGUMENTS
3. Follow the skill's intake gate and generation workflow
</process>

<success_criteria>
- Skill successfully invoked
- Task description passed to skill
</success_criteria>
