---
description: Execute new feature development workflow with TDD and pair programming
argument-hint: [feature description]
allowed-tools: Read(*), Edit(*), Write(*), Bash(*), Grep(*), Glob(*), TodoWrite(*), Task(*)
---

You received the command /m_agentic_feature. This command orchestrates a sophisticated TDD + pair programming workflow for feature development following Memory Bank standards.

**Your task**: $ARGUMENTS

## CRITICAL: You Are The Orchestrator

You do NOT execute the task yourself. You orchestrate specialized agents to do the work through a structured TDD + pair programming process.

## Workflow Overview

```
PHASE 1: Memory Bank Preparation
PHASE 2A: Select Agent-A (Acceptance Criteria Definer)
PHASE 2B: Select Agent-B (Task Executor)
PHASE 3: TDD + Pair Programming-like Execution Loop (max 20 iterations)
PHASE 4: Memory Bank Updates
```

---

## PHASE 1: Memory Bank Preparation

1. Find the corresponding specification in `.memory_bank/specs/`. If it doesn't exist, request the path from the user.
2. Carefully study `.memory_bank/workflows/new_feature.md`
3. Study `.memory_bank/tech_stack.md` for approved libraries and prohibited practices
4. Prepare full context for agent selection

---

## PHASE 2A: Select Agent-A (Acceptance Criteria Definer)

Run TDD-style agent selection loop with hiring-manager and hr-agent:

```
Loop until hiring-manager approves:

  Step 1: Use Task tool with hiring-manager
    Input: Task description + context from Phase 1
    Request: "Create comprehensive agent specification for an agent that will:
             - Define acceptance criteria for this task
             - Determine task kind (coding/design/documentation/etc)
             - For coding: Define test suite
             - For other: Define requirements checklist
             - Review implementations against criteria
             - Have veto power (but be reasonable)"
    Output: Agent specification document

  Step 2: Use Task tool with hr-agent
    Input: Agent specification from Step 1
    Request: "Match existing agent OR create new agent following this spec"
    Output: Agent name (e.g., "acceptance-criteria-definer")

  Step 3: Use Task tool with hiring-manager
    Input: Agent name + path to .claude/agents/<agent-name>.md
    Request: "Review this agent's prompt file. Validate:
             - Frontmatter is correct
             - Has sufficient permissions
             - Matches requirements from specification
             - No scope creep
             Approve OR provide specific fix requests"
    Output: APPROVED or list of fix requests

  Step 4 (if not approved): Use Task tool with hr-agent
    Input: Fix requests from Step 3
    Request: "Apply these fixes to the agent"
    Output: Confirmation of fixes applied

  Loop back to Step 3 until APPROVED
```

**Store Agent-A name** for Phase 3.

---

## PHASE 2B: Select Agent-B (Task Executor)

Repeat the same TDD-style selection loop for Agent-B:

```
Loop until hiring-manager approves:

  Step 1: Use Task tool with hiring-manager
    Input: Task description + context from Phase 1
    Request: "Create comprehensive agent specification for an agent that will:
             - Execute the task implementation
             - Follow TDD process (write test → implement → verify)
             - Work with acceptance criteria from Agent-A
             - Iterate based on Agent-A's reviews"
    Output: Agent specification document

  Step 2: Use Task tool with hr-agent
    Input: Agent specification from Step 1
    Request: "Match existing agent OR create new agent following this spec"
    Output: Agent name (e.g., "feature-implementer")

  Step 3: Use Task tool with hiring-manager
    Input: Agent name + path to .claude/agents/<agent-name>.md
    Request: "Review this agent's prompt file. Validate:
             - Frontmatter is correct
             - Has sufficient permissions (likely Read, Write, Edit, Bash, Grep, Glob)
             - Matches requirements from specification
             - No scope creep
             Approve OR provide specific fix requests"
    Output: APPROVED or list of fix requests

  Step 4 (if not approved): Use Task tool with hr-agent
    Input: Fix requests from Step 3
    Request: "Apply these fixes to the agent"
    Output: Confirmation of fixes applied

  Loop back to Step 3 until APPROVED
```

**Store Agent-B name** for Phase 3.

---

## PHASE 3: TDD Execution Loop (Max 20 Iterations)

```
For iteration 1 to 20:

  Step 1: Use Task tool with Agent-A
    Input:
      - Task description
      - Current iteration number
      - Acceptance criteria file path: .memory_bank/specs/<task-slug>_acceptance_criteria.md
      - Previous implementation results (if iteration > 1)

    Request: "
      {IF iteration == 1}
        Define comprehensive acceptance criteria for this task.
        Determine task kind (coding/design/documentation/etc).
        For coding: Define test suite requirements.
        For other: Define requirements checklist.
        Save criteria to: .memory_bank/specs/<task-slug>_acceptance_criteria.md
      {ELSE}
        Review Agent-B's implementation from iteration {iteration-1}.
        Check against acceptance criteria in the file.
        Provide detailed feedback:
          - What passed
          - What failed
          - Specific improvements needed
        Decision: APPROVED (all criteria met) OR REJECTED (needs work)
        Be reasonable in your veto power - don't reject for trivial issues.
      {ENDIF}
    "

    Output:
      - Iteration 1: Acceptance criteria file created
      - Iteration >1: Review decision (APPROVED/REJECTED) + feedback

    IF APPROVED: Exit loop with success

  Step 2: Use Task tool with Agent-B
    Input:
      - Task description
      - Acceptance criteria file: .memory_bank/specs/<task-slug>_acceptance_criteria.md
      - Feedback from Agent-A (if iteration > 1)
      - Spec file from .memory_bank/specs/
      - Tech stack from .memory_bank/tech_stack.md
      - Workflow from .memory_bank/workflows/new_feature.md

    Request: "
      Implement the task following TDD process:
      1. Read acceptance criteria from file
      2. {IF coding task} Write failing tests first, then implement to pass
      3. {IF other task} Create deliverables matching criteria
      4. Follow Memory Bank standards and tech stack
      5. {IF iteration > 1} Address Agent-A's feedback

      Use best judgment + industry standards.
      May use web search if needed.
      May ask for clarification if truly needed.
    "

    Output: Implementation completed, ready for Agent-A review

  Loop back to Step 1 for next iteration

  IF iteration == 20 and not approved:
    Step 3: Save Progress Report
      Write to: .memory_bank/progress/<task-slug>_iteration_20_report.md
      Include:
        - Task description
        - Acceptance criteria
        - Latest implementation status
        - Agent-A's latest feedback
        - Recommendation for next steps

    Step 4: Ask User for Intervention
      Message: "
        TDD loop reached maximum 20 iterations without full approval.
        Progress report saved to: .memory_bank/progress/<task-slug>_iteration_20_report.md

        Latest status:
        {summary of Agent-A's feedback}

        Options:
        1. Continue with current implementation (partial completion)
        2. Adjust acceptance criteria and retry
        3. Manual intervention needed

        What would you like to do?
      "

    Exit loop
```

---

## PHASE 4: Memory Bank Updates

Upon successful completion (Agent-A approved):

1. **Update `.memory_bank/current_tasks.md`**
   - Mark task as completed
   - Add completion date
   - Link to implementation

2. **Update `.memory_bank/tech_stack.md`** (if dependencies were added)
   - Add new libraries/tools
   - Document versions and usage

3. **Create/update guide in `.memory_bank/guides/`** (if this is a new subsystem)
   - Document architecture decisions
   - Add usage examples
   - Reference acceptance criteria

---

## Agent Usage Rules

**Prefer Actual Agents:**
- First try to use the agent by name directly with Task tool
- Claude should recognize agents from `.claude/agents/`

**Fallback to Simulation:**
- If agent not found in Claude's memory (may happen for newly created agents)
- Read agent prompt file: `.claude/agents/<agent-name>.md`
- Use Task tool with subagent_type="general-purpose" and include full agent prompt

**Agent Autonomy:**
- Agents use best judgment based on industry standards
- Agents may use web search tool for research
- Agents MAY ask for clarification if truly needed
- Agents must follow KISS, DRY, YAGNI, TRIZ principles

---

## Hiring-Manager Agent Specification Format

When requesting agent specs from hiring-manager, expect this format:

```
AGENT SPECIFICATION: [agent-name]

PURPOSE: [One clear sentence]

RESPONSIBILITIES:
1. [First responsibility]
2. [Second responsibility]
...

REQUIRED TOOLS:
- Read: [why needed]
- Write: [why needed]
...

SUCCESS CRITERIA:
- [Measurable outcome 1]
- [Measurable outcome 2]

EDGE CASES:
- [Case 1]: [How to handle]
- [Case 2]: [How to handle]

QUALITY STANDARDS:
- Must follow KISS, DRY, YAGNI, TRIZ principles
- Must religiously adhere to assigned task
- No scope creep
```

---

## Progress Tracking

Use TodoWrite extensively to track:
- Phase completion
- Agent selection loops
- TDD iteration count
- Current status

Example:
```
Phase 1: Memory Bank Preparation (completed)
Phase 2A: Agent-A Selection (in_progress)
  - Hiring-manager spec created (completed)
  - HR-agent matched agent (completed)
  - Hiring-manager review iteration 1 (in_progress)
```

---

## Start Execution

Begin with Phase 1: Memory Bank Preparation.

Use hierarchical parallel execution where possible, but respect dependencies:
- Phase 2A and 2B can run in parallel (launch both agent selection loops simultaneously)
- Phase 3 depends on Phase 2 completion
- Phase 4 depends on Phase 3 success

**Remember**: You orchestrate. Agents execute. Your job is coordination, not implementation. If you try to execute task by yourself, then you'll be seriously punished.
