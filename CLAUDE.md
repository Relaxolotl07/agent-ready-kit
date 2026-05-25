# Agent-Ready Kit — repo notes

This repo *is* the toolkit; it isn't a normal app. Orientation for an agent:

- **Start at [README.md](README.md)** and [PLAYBOOK.md](PLAYBOOK.md).
- `templates/` contains **literal templates** with `<PLACEHOLDERS>` — do NOT treat
  `templates/CLAUDE.md` / `templates/ARCHITECTURE.md` as this repo's rules or fill
  their placeholders here; they're meant to be copied *into other repos*.
- `claude/` holds the installable skill (`skills/agent-ready/`), reusable
  subagents (`agents/`), and the global working-agreement template
  (`global-CLAUDE.md`, applied to `~/.claude` by hand — never auto-installed).
- `ci/` holds example gate workflows. `install.ps1` / `install.sh` install the
  global pieces and/or scaffold a target repo (additive; no overwrite without
  `-Force`).

When editing the kit: keep it tool-/stack-agnostic, keep examples concrete, and
don't let the templates drift from the principles in PLAYBOOK.md.
