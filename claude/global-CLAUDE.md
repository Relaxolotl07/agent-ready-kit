# Global working agreement (cross-project)

> Apply by **copying into `~/.claude/CLAUDE.md`** when you choose. It loads into
> **every** Claude Code session, so keep it to durable, tool-/stack-agnostic
> preferences. A project's own `CLAUDE.md` augments and overrides this.
>
> (Intentionally NOT auto-installed by this kit — a global CLAUDE.md changes
> behavior everywhere, so adopt it deliberately.)

## How I work

- **Leave it smaller, clearer, more consistent.** Reuse before writing; delete
  before adding. A change that adds a file to do what a helper already does is a
  regression even if it "works."
- **Read the repo's `CLAUDE.md` + `ARCHITECTURE.md` first** and treat them as
  authoritative over older docs. If a repo lacks them, offer to run `/agent-ready`.
- **Spec-first for non-trivial features** (`docs/specs/<feature>.md`), and read the
  relevant ADR before changing the area it governs.
- **Match the surrounding code** — naming, comment density, structure. New code
  should be indistinguishable from the file it's in.
- **Never silently swallow errors.** Handle or log; if failure is acceptable, say
  why in a comment.
- **Respect file-size budgets**; split mega-files by responsibility behind
  unchanged public surfaces rather than growing them.

## Verifying & finishing

- **Run the repo's gate suite before claiming done** — and say so honestly: if
  tests fail, show the output; if a step was skipped, say so; don't hedge a real
  pass.
- For refactors, **prove behavior preservation** (public-surface snapshot diff +
  smoke), don't assert it.
- Don't claim something works until it's been run.

## Git

- **Commit/push only when asked**; if on the default branch, branch first unless
  told otherwise.
- Keep commits focused; write a real message (what + why).
- <Set your commit-attribution preference here — e.g. omit AI co-author trailers
  if that's your convention.>

## Handoff & sessions

- Start large multi-step work in a **fresh session** seeded by the docs, rather
  than pushing one conversation to exhaustion.
- Sequence coupled work; only parallelize clean, independent seams.
- When handing off, leave a kickoff prompt pointing at the docs, the task, the
  order, the constraints, and the verification ritual.
