# <PROJECT> — Agent Standards Guide

**Read this before writing any code.** This file holds the *rules for how to
change the code*. For the *current factual map* — entry points, modules,
endpoints, data model, live-vs-dead — read **[ARCHITECTURE.md](ARCHITECTURE.md)**
(keep it updated as you change things). **If anything here or there disagrees
with an older doc, these two files win.**

The prime directive for every change: **leave the codebase smaller, clearer, and
more consistent than you found it.** Reuse before you write. Delete before you
add.

---

## 1. What this is

<One short paragraph: what the project does and its surfaces/stack. Then a table:>

| Surface | Stack | Owns | Entry point |
|---------|-------|------|-------------|
| `<dir>/` | <stack> | <responsibility> | `<entry>` |

Run instructions live in [README.md](README.md). <Other authoritative docs.>

---

## 2. Golden rules (apply everywhere)

1. **Search before you build.** Grep for an existing helper/component/style before
   writing a new one. Most "new" needs already have a home.
2. **Respect file-size budgets.** Target **≤ <N>** lines per file; **<M> is a hard
   ceiling**. If your edit pushes a file past the ceiling, split by responsibility
   *first*, then make your change.
3. **Functions stay small** — one job; extract before the nesting deepens.
4. **Never silently swallow errors.** No empty `catch` / `except: pass`. Catch the
   narrowest error you can and handle or log it; if failure is truly acceptable,
   say *why* in a comment.
5. **No cross-layer reach-arounds.** <state the layering, e.g. routers→services→
   models>. Never import another module's private (`_name`) symbol — if two
   modules need it, it belongs in a shared, public place.
6. **One concept, one home.** Shared logic lives in <shared dir>. Copy-paste is a
   bug.
7. **Don't commit generated or heavy artifacts** (build output, deps, DBs).
8. **Keep docs in sync with code.** Changed an endpoint/contract? Update
   [ARCHITECTURE.md](ARCHITECTURE.md) (and any API contract doc). Changed a
   convention/budget? Update *this* file.
9. **Match the surrounding code** — naming, comment density, section dividers.
10. **Spec-first for non-trivial features** — write `docs/specs/<feature>.md` and
    get it approved before coding. Read the relevant [ADR](docs/adr/) before
    changing the area it governs.

---

## 3. Per-area rules

<For each layer/surface, state the conventions an agent must follow. Examples:>
- **Layering is strict:** <X> may import <Y> but not <Z>. Logic lives in <layer>.
- **All <external/LLM/IO> calls go through `<gateway module>`** — never elsewhere.
- **<Data/auth/tenancy> rule:** <e.g. every query is scoped by user_id>.
- **Config** is read once in `<config module>` from env; document new settings in
  the README.
- **Schema changes:** update the model *and* add a migration; CI checks they match.

---

## 4. Gates & verification (how to check your work)

These run in CI and **must pass**. Run them locally before finishing — ideally one
command (`<make check>` / `<script>`).

| Gate | Command | Enforces |
|------|---------|----------|
| Format | `<fmt --check>` | consistent style |
| Lint | `<lint>` | correctness + complexity ceiling |
| Architecture contracts | `<dep/import linter>` | the layering in §3 |
| Dead code | `<deadcode tool>` | no cruft |
| Tests | `<test runner>` | unit + integration; external calls replay offline ($0) |
| Doc-freshness | `<dump-surface> && diff vs committed` | the map can't go stale |
| Migrations | `<schema check>` | models match migrations |
| Secrets | `<secrets scanner>` | no committed credentials |

**Verification ritual** for changes:
- *Refactor:* `<snapshot public surface>` before/after — diff must be empty for a
  pure move; plus a smoke pass on a throwaway fixture/DB.
- *Feature:* the spec's acceptance criteria + tests; full gates green + smoke.

---

## 5. Definition of done (check before you finish)

- [ ] Reused existing helpers; no copy-paste; no new file over budget.
- [ ] No swallowed errors; no new cross-layer / private-name imports.
- [ ] Docs updated (ARCHITECTURE.md / API contract / this file as applicable).
- [ ] No generated artifacts staged.
- [ ] All gates pass (§4) + verification ritual run.

---

## 6. Known debt — do not add to it

A living list of the messy spots. **Don't extend them; chip away when you're
already in the file.** Grandfathered violations carry explicit ignores so new
violations still fail.

- <file/area over budget> — split it the same way (…).
- <N swallowed errors remaining> — convert to log-and-continue when you touch them.
- <other tracked debt>

**Resolved (don't re-introduce):** <things already fixed>.

---

## Documentation map

| Doc | Status | Use it for |
|-----|--------|-----------|
| **CLAUDE.md** (this) | Authoritative | Rules: how to change code |
| **ARCHITECTURE.md** | Authoritative | Facts: current map |
| README.md | Living | Running it; env vars |
| docs/adr/ | Living | Settled decisions (read before changing the area) |
| docs/specs/ | Living | Per-feature specs (write before coding) |
| <older docs> | Historical | Original intent only — not current |
