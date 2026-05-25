---
name: agent-ready
description: Make a codebase agent-ready. Audits the repo and scaffolds (or refreshes) the two living docs — CLAUDE.md (rules) and ARCHITECTURE.md (map) — proposes a gate set matched to the stack (+ optional CI), and adds docs/specs and docs/adr scaffolding. Use in a new, messy, or undocumented repo, or to refresh stale standards before handing work to other agents.
---

# Make this codebase agent-ready

Goal: leave the repo legible and guarded enough that a *fresh* agent can change it
fast and provably. You produce four things (the Agent-Ready Playbook ingredients):
the **rules** doc, the **map** doc, **gates that encode the rules**, and
**spec/ADR scaffolding**. Tailor everything to *this* repo — read the code, don't
fabricate.

## Operating principles
- **Additive and reviewable.** Never overwrite an existing `CLAUDE.md` /
  `ARCHITECTURE.md` without showing a diff and getting an OK. If they exist, refresh
  in place rather than replacing.
- **Derive from reality.** Every claim in the map must come from the actual code.
  Use read-only exploration (grep/read; delegate broad sweeps to a researcher
  subagent if available) before writing.
- **Grandfather, don't block.** Existing violations get explicit ignores + a
  "known debt" list; only *new* violations should fail gates.
- **Propose, then do.** Present the plan (below, step 1) and get a nod before
  writing files or adding CI.

## Procedure

1. **Audit + plan (read-only first).** Determine and report back:
   - Language(s), framework(s), package manager, entry point(s), test runner.
   - The de-facto layering (what imports what) and any god-files / mega-modules
     (flag files over a sensible budget).
   - Existing linters/formatters/CI/tests/docs — reuse what's there.
   - The public surface (routes / exported API / CLI) and the data model.
   - Live vs. dead code (imported nowhere).
   Then present a short plan: which docs you'll create/refresh, which gates you
   propose, and what existing violations you'll grandfather. **Pause for OK.**

2. **Write `ARCHITECTURE.md` (the map).** Entry points, public surface, modules +
   responsibilities, data model, live-vs-dead — all from the audit. Keep it
   factual and current. Mark sections that should later be *generated* (see the
   doc-freshness gate).

3. **Write `CLAUDE.md` (the rules).** Prime directive; golden rules (search-first,
   file-size budget with target+ceiling, small functions, no swallowed errors, no
   cross-layer/private imports, one-concept-one-home, no committed artifacts,
   docs-in-sync, match-surrounding-style); the repo-specific layering; the gate
   list (step 4); a definition-of-done checklist; a **Known debt** section listing
   what you grandfathered; and a documentation map stating that CLAUDE.md +
   ARCHITECTURE.md win over stale docs. (Static starting points: the kit's
   `templates/CLAUDE.md` and `templates/ARCHITECTURE.md`.)

4. **Propose + wire gates matched to the stack.** Map each rule to a check:
   - format + lint (one each); complexity ceiling if supported.
   - **architecture-contract** gate enforcing the layering (e.g. import-linter
     for Python, eslint boundaries / dependency-cruiser for JS) — don't skip this.
   - dead-code; secrets scan; tests (record external calls so the suite is
     offline/$0); migration/schema check if there's a DB.
   - a **doc-freshness gate**: a small script that dumps the public surface
     (routes/exported symbols/API schema) to a committed file, with CI failing on
     drift. Generate that script.
   Ensure all gates run in **one local command** identical to CI. Add/extend the
   CI workflow (the kit's `ci/*-gates.yml` are starting points) only with an OK.

5. **Scaffold process docs.** Add `docs/specs/` and `docs/adr/` with READMEs +
   templates (from the kit's `templates/docs/`), and state spec-first in CLAUDE.md.

6. **Grandfather existing violations.** Add the minimal ignores so the new gates
   pass on the current tree, and record each in CLAUDE.md "Known debt."

7. **Verify + summarize.** Run the gate suite; confirm it's green on the current
   tree. Summarize what you created, what's grandfathered, and the top 3 debt
   items to chip away first. Optionally produce a kickoff-prompt for handing work
   to a fresh instance.

## Done when
- CLAUDE.md + ARCHITECTURE.md exist, accurate, and authoritative.
- Gates run green in one command locally (and in CI if wired), with existing
  violations grandfathered + listed.
- docs/specs + docs/adr scaffolding present.
- You've reported the debt shortlist + (optionally) a handoff prompt.
