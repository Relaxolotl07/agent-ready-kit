# The Agent-Ready Playbook

How to make a codebase structured and forward-thinking for agentic coding.
Tool-agnostic. The goal is a repo where an agent can make a change **fast** and
**provably without breaking things**, and where any *fresh* agent is productive in
minutes.

The core insight: **an agent is only as good as the codebase's legibility and
guardrails.** You get leverage by investing once in four things.

---

## Ingredient 1 — Two living docs: the rules and the map

Every agent session should start by reading two short, authoritative files.

### `CLAUDE.md` — the rules (how to change the code)
The standards an agent must follow. Keep it to *rules*, not facts. Include:
- **Prime directive.** One sentence that resolves judgment calls. (e.g. "Leave
  the codebase smaller, clearer, and more consistent than you found it. Reuse
  before you write; delete before you add.")
- **Golden rules:** search-before-you-build; respect file-size budgets
  (target/ceiling); functions stay small; never silently swallow errors; no
  cross-layer reach-arounds; one-concept-one-home; don't commit generated/heavy
  artifacts; keep docs in sync with code; match surrounding style.
- **Layering / architecture rules** specific to the repo (what may import what).
- **The gate list** (Ingredient 2) and how to run it locally.
- **Definition of done** — a checklist the agent self-verifies before finishing.
- **Known debt — "do not add to it"** — a living list of the messy spots, so
  agents stop *extending* them and chip away when they're already in the file.
- **A documentation map** — which doc is authoritative for what.

> Authority must be explicit: state that `CLAUDE.md` + the map **win** over any
> older/stale doc. Ambiguity about which doc is current is how agents get misled.

### `ARCHITECTURE.md` — the map (the current factual state)
The truth context: every entry point, endpoint, table, service, and **what's live
vs. dead**. Rules go in `CLAUDE.md`; *facts* go here. Regenerate or update it as
the system changes — a stale map is worse than none.

**Why two docs:** rules change slowly and are prescriptive; the map changes with
every feature and is descriptive. Conflating them rots both.

---

## Ingredient 2 — Gates that *encode* the rules (so drift is impossible)

Documentation that isn't enforced is a suggestion. Turn each rule you care about
into a **machine check that runs in CI and locally**, so a violating change fails
loudly instead of merging quietly. The highest-leverage gates:

- **Format + lint** — one formatter, one linter, zero-config drift. (Auto-format
  on save/commit so it's never a manual step.)
- **Architecture contracts** — *enforce the layering*. (e.g. import-linter for
  Python, eslint boundaries / dependency-cruiser for JS.) This is the gate most
  repos skip and most need: it makes "routers→services→models" real.
- **Dead-code detection** — so deletions actually happen and cruft can't hide.
- **Tests** — unit + a few integration/smoke tests. Make LLM/external calls
  replay from recordings so the suite is offline and $0.
- **Doc-freshness gate** — generate a snapshot of the public surface
  (routes/exported symbols/API schema) into a committed file; CI fails if the
  committed copy drifts from code. *This is what keeps the map honest.*
- **Contract/drift gates** for typed clients (e.g. generate types from an OpenAPI
  spec; fail if the checked-in types don't match).
- **Migration check** — schema matches migrations (e.g. `alembic check`).
- **Secrets scan** — no committed credentials.

Rules of thumb:
- **A rule worth stating in `CLAUDE.md` is worth a gate.** If you can't gate it,
  make it a reviewer-subagent checklist item (Ingredient 4).
- **Grandfather existing violations** with explicit ignores + a tracked debt list,
  rather than blocking all work. New violations fail; old ones are chipped away.
- Gates must be **runnable in one command locally**, identical to CI.

---

## Ingredient 3 — Spec-first + ADRs + a verification ritual

### Spec-first for non-trivial features
Write a one-page `docs/specs/<feature>.md` (scenario, acceptance criteria, API/
data-model surface, cost/eval notes, out-of-scope/risks) and get it approved
**before** code. Forcing the spec surfaces assumptions early and cuts agent
thrash. (Template in `templates/docs/specs/`.)

### ADRs for settled decisions
Record architecture decisions in `docs/adr/NNNN-title.md` (context, decision,
consequences). An agent reads the relevant ADR before changing that area, so it
doesn't relitigate a settled choice. (Template in `templates/docs/adr/`.)

### A verification ritual that *proves* safety
For any change, define how you'll show it didn't break things — and run it:
- **Refactors:** capture a snapshot of the public surface (routes/symbols) before
  and after; the diff must be empty for a pure move. Pair with a fast smoke test
  on a throwaway DB/fixture.
- **Features:** the spec's acceptance criteria become the checks; add/extend tests.
- Always: the full gate suite green + an integration smoke pass before "done."

This ritual is what lets an agent (or you) trust a large change.

---

## Ingredient 4 — Handoff readiness

A long agent session degrades (context fills, attention drifts). Design for
**fresh starts and clean handoffs**:
- The two living docs + the gate suite mean a **new instance is productive in
  minutes** — that's the payoff of Ingredients 1–2.
- Keep a **kickoff-prompt pattern**: a short message that points a fresh instance
  at the docs, the task, the order, the constraints, and the verification ritual.
  (Start big multi-step work in a *fresh* session, seeded by the docs, rather than
  pushing one conversation to exhaustion.)
- **Reusable subagents** for recurring jobs: a read-only *researcher* (explore
  without polluting context), a *reviewer* (checks a diff against `CLAUDE.md`), a
  *refactor-safety* helper (runs the snapshot/smoke ritual). (See `claude/agents/`.)
- **Sequence coupled work; parallelize only clean seams.** Features that share
  files/migrations stay single-threaded; independent tracks (e.g. backend vs.
  frontend) can run in parallel on branches — but someone owns integration.

---

## Ingredient 5 — Parallel-ready (when more than one agent runs at once)

Ingredients 1–4 already lower coordination cost (any instance onboards fast and
self-verifies). To actually run agents/branches in *parallel* without
merge-fighting, also:

- **One branch per track, each in its own worktree/clone** — never a shared
  working tree. Note a fresh worktree lacks git-ignored deps (virtualenvs,
  `.env`, local config); document how each track obtains them.
- **Map the seams.** A `CODEOWNERS` (or `SEAMS.md`) marking which directories are
  **disjoint** (safe to fork — e.g. backend ↔ frontend ↔ infra) vs. **shared /
  sequential** (schema, migrations, cross-cutting hot files).
- **Single-lane the serialization points.** Linear things — a DB migration chain,
  a shared lockfile, a global registry/index — take **one in-flight change at a
  time**, or one track owns them per batch.
- **Generated files are regenerated at integration, never hand-merged.** Mark them
  (`linguist-generated` in `.gitattributes`) and document the regenerate command.
- **One integration owner** merges branches one at a time and re-runs the **full
  gates + smoke on the merged result** — green-in-isolation can break combined.
- **Specs are the contract** that keeps tracks from diverging.

Rule of thumb: **parallelize disjoint trees, serialize shared state.**

---

## The checklist (copy into an issue)

```
[ ] CLAUDE.md exists: prime directive, golden rules, layering, gate list,
    definition-of-done, known-debt, doc map, and "these win over stale docs."
[ ] ARCHITECTURE.md exists: entry points, endpoints, data model, services,
    live-vs-dead. Matches reality today.
[ ] One formatter + one linter, auto-run, zero drift.
[ ] Architecture-contract gate enforces the layering.
[ ] Dead-code + secrets-scan gates.
[ ] Tests run offline/$0 (external calls recorded); one integration/smoke path.
[ ] Doc-freshness gate: committed public-surface snapshot, CI fails on drift.
[ ] Migration/schema check (if there's a DB).
[ ] Gates run in ONE local command, identical to CI.
[ ] docs/specs/ + docs/adr/ exist with templates; spec-first is the rule.
[ ] A verification ritual is written down (snapshot-diff + smoke).
[ ] Existing violations grandfathered + listed in known-debt (not blocking).
[ ] A kickoff-prompt template for handing work to a fresh instance.
[ ] Parallel seams mapped (CODEOWNERS/SEAMS); migrations + generated files have a
    single-lane + regenerate-at-integration rule.
```

---

## Anti-patterns (these quietly make a repo agent-hostile)

- **Docs that describe aspirations, not reality** — agents trust the map; a stale
  map causes confident wrong changes.
- **Rules with no gate** — unenforced standards drift in days.
- **Mega-files and god-modules** — an agent can't safely change a 1,500-line file;
  set budgets and split by responsibility behind unchanged public surfaces.
- **Silent error-swallowing** (`except: pass`, empty catch) — hides the failures
  an agent needs to see.
- **One giant ever-growing session** — start fresh; lean on the docs.
- **Letting an agent self-regulate safety** — encode safety in gates + a ritual,
  not in "the model will be careful."
- **Blocking all work on legacy violations** — grandfather + chip away instead.
- **Forking parallel work onto shared state** (same migration chain / hot files /
  generated artifacts) — you'll merge-fight. Parallelize disjoint trees,
  serialize shared state (Ingredient 5).
