---
name: handoff
description: Write durable handoff notes and resume prompts when Codex needs to transfer work between agents, models, vendors, or sessions, especially before time limits, weekly limits, context exhaustion, provider switches, interruptions, or any request about handoff, checkpointing, save state, context carry-over, or 引き継ぎ.
---

# Handoff

Create a plain Markdown handoff that another agent can resume from without seeing the prior chat. Optimize for continuity, not narrative.

## Choose the mode

Use this decision rule first:

```text
Need to stop soon?
  |
  +-- Yes, less than ~5 minutes or hard limit is near
  |     -> use the quick template
  |
  +-- No, there is still room to summarize carefully
        -> use the full template
```

If the session is at risk of ending soon, stop non-essential work and write the handoff first.

## Write to disk by default

Prefer an on-disk handoff file over a chat-only summary.

Use this default location when the user does not specify one:

```text
Inside a git repo:   <repo-root>/.agent-handoffs/YYYY-MM-DD-HHMM-<topic>.md
Outside a git repo:  ./handoff-YYYY-MM-DD-HHMM-<topic>.md
```

Rules:

- Keep the file in plain Markdown.
- Do not assume the next agent can see prior chat history.
- Do not assume the next agent uses the same vendor or tool.
- Do not commit the handoff file unless the user asks.
- Mention the file path in the final user-facing message.

## Gather the minimum viable state

Collect the smallest set of facts that lets the next agent act immediately:

- Exact user goal and any explicit non-goals
- Current status: done, in progress, not started
- Files changed, files inspected, and files that matter next
- Commands already run and the important result of each
- Decisions made and why they were made
- Known blockers, risks, or missing information
- The single best next action
- A ready-to-send resume prompt for the next agent

When relevant, also capture:

- Repo root, branch, and dirty-worktree state
- Test status and failing cases
- Environment constraints, required tools, or approvals still needed
- URLs, issue numbers, PRs, or docs the next agent must open

## Write for a different agent, not for yourself

Use these rules when drafting the handoff:

- Put the most important facts in the first screenful.
- Prefer bullets over paragraphs.
- Use exact file paths, command lines, branch names, and identifiers.
- Summarize long logs; quote only the crucial lines.
- State what has already been tried so the next agent does not repeat work.
- Separate facts from guesses.
- If something is uncertain, say what to verify first.
- Preserve the user's language unless there is a reason to switch.

Avoid:

- Long chronological diaries
- Tool-specific shorthand that depends on chat history
- Huge pasted outputs when one-line summaries are enough
- Secrets, tokens, or copied credentials

## Structure the note

Use one of the bundled templates:

- `assets/quick-handoff-template.md`
- `assets/full-handoff-template.md`

Always fill these sections in some form:

1. Goal
2. Current state
3. Files and artifacts
4. Commands and observed results
5. Open risks or blockers
6. Recommended next step
7. Resume prompt

## Finish the transfer

After writing the file:

- Tell the user exactly where the handoff lives.
- Give a one-sentence summary of what the next agent should do first.
- If the cutoff is imminent, paste the resume prompt into the chat as well.

## Quick quality check

Before finishing, verify:

- Could a fresh agent act with only this file and the repo?
- Are the next 1-3 actions explicit?
- Are the paths and commands concrete?
- Is the top section enough if the reader only skims for 30 seconds?
