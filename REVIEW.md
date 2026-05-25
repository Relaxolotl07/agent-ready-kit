# Keeping the system robust as capabilities change

The goal is **not** "the optimum" — that's a moving target, and chasing every
model release is a treadmill that erodes the stability that makes the system
valuable. The goal is a system that is **robust and deliberately re-examined, with
a high bar to change.** Stability is a feature. Re-tune *knobs* freely; change the
*shape* rarely, and only on evidence.

## Shape vs. knobs (the core distinction)

**SHAPE — durable. Change only via an ADR + strong evidence. Default: don't.**
- The two living docs (rules + map); gates that encode the rules; spec-first +
  ADRs + the verification ritual; handoff readiness; the parallel-work seams.

**KNOBS — re-tune freely on capability changes (no ADR unless the change is surprising).**
- File-size budgets; how much lives in `CLAUDE.md` vs. memory vs. ADRs; model
  tiers (smart/cheap); autonomy / sandbox / permission posture; number & role of
  subagents; context-window assumptions (doc length, how much to load per task);
  gate strictness; spec granularity.

> A review that treats a knob as a shape change will thrash the architecture for
> no reason. Most capability changes move knobs, not shape.

## Trigger policy (event-based, not a calendar)

Run a review when one of these lands — not on a clock:
- A **new Claude model** (capability / price / context / tool-use shift).
- A **major Claude Code primitive** (context length, native sandbox, skills/
  memory, subagents, hooks, new tool types).
- **Repeated pain** from the self-audit below, even with no release.

Optional: one lightweight *sanity* pass per year even if quiet, to catch slow drift.

## The capability-event bundle (one trigger, not many cadences)

A model / Claude Code release should fire **one bundle**, not a dozen separate
review rituals. On the event, run — cheapest first:

1. **Re-tier models** (if you have a tiering harness): re-run your blind A/B +
   cost-per-call log and move calls between smart/cheap tiers on the new
   price/quality. *Knob.*
2. **Re-baseline evals:** a new model (or judge) shifts pass/fail — refresh
   thresholds + golden sets and reconsider the judge model, or the evals rot into
   noise. *Knob.*
3. **Scan the knobs** (~5–10 min each): prompts (can better instruction-following
   let you *delete* scaffolding?); doc density / file budgets (bigger context →
   load more, split less?); autonomy / sandbox / permission posture (**+ a security
   re-check** — more autonomy = more injection/exfil surface); workflow
   granularity (# of subagents, parallel seams, when to start fresh).
4. **Architecture review:** run the full procedure below (self-audit + the
   deep-research prompt + the change bar) — the *shape* question. Usually: it holds.
5. **Record:** knob changes in the commit/log; shape changes as ADRs.

> **Not everything shares this trigger.** Decisions driven by **scale/usage**
> rather than agent capability — e.g. datastore or client-contract choices — get a
> *scale-threshold* trigger instead (revisit when you cross X rows / Y users / Z
> latency), with the same shape-vs-knob discipline. Reviewing the **product's own
> AI features** (or an ops playbook) is a separate track on its own capability
> trigger — same pattern, different subject.

## The review procedure

1. **What changed?** (~15 min) Read the release notes; write the concrete
   capability deltas (e.g. "context 200k→1M", "native sandbox GA", "cheaper smart
   tier"). This list is the research input.
2. **Self-audit (empirical half).** Run the checklist below. Note where the system
   is *actually* failing — not where it theoretically could.
3. **Deep research (shape half).** Run [reviews/architecture-review-prompt.md](reviews/architecture-review-prompt.md),
   feeding it the current shape, the capability delta, and the self-audit findings.
   It returns shape-vs-knob verdicts measured against the change bar.
4. **Apply the change bar.**
   - *Knob* → re-tune directly; note it in the commit/changelog.
   - *Shape* → only if the evidence is strong AND the win outweighs the churn; if
     adopted, write an **ADR**. Default to NO.
5. **Record.** ADRs for shape changes; a dated line in a review log for the rest —
   so the next review builds on this one and nothing is relitigated.

## The change bar (decision filter)

Adopt a change only if **all** hold: it solves a *real, observed* problem (a
self-audit failure or a concrete capability gap); the benefit clearly exceeds the
cost of churning a stable convention; and — for SHAPE — it **cannot** be achieved
by turning a knob. When unsure, **leave the shape alone** and log the question for
next time.

## Self-audit checklist (run anytime — the empirical signal research can't give)

- [ ] **Onboarding:** can a *fresh* agent, given only the docs, correctly do a
      representative task without hand-holding? (Actually try it.)
- [ ] **Gate efficacy:** did the gates catch the last real regression? Any
      violation they *should* catch but don't? Any gate that only ever cries wolf?
- [ ] **Thrash:** what fraction of recent changes were reverted/redone, and where?
- [ ] **Convention drift:** how often did agents violate `CLAUDE.md` — and did a
      gate stop it, or did it merge?
- [ ] **Doc truth:** does `ARCHITECTURE.md` still match reality (doc-freshness
      gate green)?
- [ ] **Cost / latency:** are the model tiers still right for current price/quality?
- [ ] **Friction:** where did agents repeatedly ask, stall, or lack a permission
      they should have had?

A clean audit → leave the shape alone. A failing line → a *specific* fix (usually
a knob, occasionally a gate, rarely the shape).
