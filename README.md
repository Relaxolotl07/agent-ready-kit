# Agent-Ready Kit

A portable kit for making any codebase **structured and forward-thinking for
agentic coding** — so a fresh AI agent (or a teammate) can change it fast and
*provably* without breaking things.

Distilled from a real refactor: the gains weren't any one feature, they were the
**scaffolding that makes a codebase legible and safe for an agent to change.**
That scaffolding generalizes. This kit packages it three ways:

| Part | What it is | Use it when |
|------|-----------|-------------|
| **[PLAYBOOK.md](PLAYBOOK.md)** | The tool-agnostic methodology + checklist | You want the *why* and a manual path |
| **[templates/](templates/)** + **[ci/](ci/)** | Drop-in `CLAUDE.md`, `ARCHITECTURE.md`, spec/ADR templates, CI gate workflows | You want to scaffold a repo by hand |
| **[claude/skills/agent-ready/](claude/skills/agent-ready/SKILL.md)** | A `/agent-ready` Claude Code skill that audits a repo and generates the above, tailored | You want the "make this repo agent-ready" button |

Plus reusable subagents ([reviewer](claude/agents/reviewer.md),
[refactor-safety](claude/agents/refactor-safety.md)) and a cross-project working
agreement ([claude/global-CLAUDE.md](claude/global-CLAUDE.md)).

## The idea in one paragraph

An agent is only as good as the codebase's *legibility* and *guardrails*. Give it
(1) two living docs — the **rules** and the **map** — so it's oriented instantly;
(2) **machine-checked gates** that encode the rules so it can't quietly drift;
(3) a **spec-first + verification ritual** so changes are deliberate and provably
behavior-preserving; and (4) **handoff readiness** so any new instance is
productive in minutes. The PLAYBOOK expands each.

## Quickstart

**Manual (any agent/IDE):** copy `templates/CLAUDE.md` and
`templates/ARCHITECTURE.md` into a target repo, fill the `<PLACEHOLDERS>`, add the
matching `ci/*-gates.yml`, and follow [PLAYBOOK.md](PLAYBOOK.md).

**With Claude Code (recommended):** install the global pieces once
(`./install.ps1 -Global` on Windows, `./install.sh --global` elsewhere), then in
any repo run `/agent-ready` — it inspects the stack and drafts the tailored docs
+ a proposed gate set for your review.

## What touches what (safety)

- The kit is **self-contained**; nothing here writes into your other repos.
- `install.* --global` adds **only** new files under `~/.claude/skills/` and
  `~/.claude/agents/`. They're **inert until invoked** — no auto-firing.
- It does **not** install a global `~/.claude/CLAUDE.md` (that would load into
  every session). That's shipped as `claude/global-CLAUDE.md` for you to apply
  deliberately.
- `install.* <target-repo>` only *adds* template files to that repo (never
  overwrites without `-Force`).
