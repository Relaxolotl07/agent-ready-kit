# Architecture-review deep-research prompt (capability-triggered)

Run this when a capability event lands (see [../REVIEW.md](../REVIEW.md)). Fill the
four INPUT blocks from your repo + the release notes + the self-audit, paste into
Claude Deep Research (or a strong model), and apply the results against the change
bar. It is deliberately **biased toward stability** — it should mostly tell you to
leave the shape alone.

```
ROLE
You are a senior staff engineer auditing an AI-agent-oriented codebase
architecture to decide whether — given a specific change in the coding agent's
capabilities — anything should change. Bias HARD toward stability: a stable
convention agents rely on is worth more than a marginally better one. Recommend
change only where the evidence is strong and the win clearly exceeds the cost of
churning a relied-on convention. Subtraction (deleting a now-unneeded workaround)
is a valid and often the best outcome.

INPUTS
- CURRENT ARCHITECTURE SHAPE:
  <Paste the system's shape: the two living docs (rules + map); the gate list
  (lint, architecture-contract, dead-code, tests, doc-freshness, migrations,
  secrets); spec-first + ADRs + the verification ritual; handoff + parallel-work
  conventions; model tiers; autonomy/sandbox/permission posture; subagents; file-
  size budgets; what lives in CLAUDE.md vs memory vs ADRs.>
- CAPABILITY DELTA SINCE LAST REVIEW:
  <The concrete changes only — e.g. "context 200k→1M", "native sandbox GA",
  "cheaper/stronger smart tier", "new tool types", "skills/memory changes",
  "longer reliable autonomous runs". Cite sources.>
- SELF-AUDIT FINDINGS:
  <Where the system is ACTUALLY failing today: onboarding, gate misses, thrash,
  convention drift, cost/latency, friction. If none, say so.>
- CONSTRAINTS / SETTLED:
  <Solo vs team; cost sensitivity; stack; decisions that are settled — cite
  existing ADRs so they aren't relitigated.>

TASK
For EACH capability delta and EACH self-audit finding, decide whether the
architecture should adapt. For every recommendation output:
  (a) The change, concretely.
  (b) SHAPE or KNOB.  (Shape = durable structure: docs / gates / spec-first /
      verification / handoff / seams. Knob = a parameter: budgets, model tiers,
      autonomy, context assumptions, # subagents, what lives where, gate strictness.)
  (c) Trigger — which capability delta or audit finding motivates it.
  (d) Evidence + confidence: strong / plausible / speculative. (Strong = the
      capability genuinely enables or obsoletes something; speculative = taste.)
  (e) Cost of churn — what stable thing it disrupts + the migration cost.
  (f) Verdict vs the CHANGE BAR: adopt now / defer / reject — and why. The bar:
      solves a real observed problem; benefit clearly exceeds churn cost; and for
      SHAPE, cannot be achieved by turning a knob. Default to "leave it."

ALSO ANSWER
- What in the current shape is now OBSOLETE or counterproductive given the new
  capability (e.g. a workaround for a limit that no longer exists)?
- What did we over-engineer that the new capability lets us SIMPLIFY or DELETE?
- What NEW failure modes do the new capabilities introduce that we have no gate or
  convention for yet (e.g. more autonomy → new injection/exfil surface)?
- The single highest-leverage change, and the single most TEMPTING change that is
  NOT worth the churn.

OUTPUT
- A one-paragraph verdict: does the SHAPE still hold? (Usually: yes.)
- Recommendations grouped SHAPE vs KNOB, each with (a)-(f).
- A "considered and explicitly rejected" list, so the next review doesn't
  relitigate it.
- Any adopted SHAPE change written as a ready-to-commit ADR (context / decision /
  consequence).

ANTI-PATTERNS (avoid)
- Recommending change for its own sake or chasing novelty — stability is default.
- Generic best-practices not tied to a specific capability delta or audit finding.
- Treating a knob re-tune as a shape change, or vice versa.
- Ignoring churn cost: a 5% gain that destabilizes a relied-on convention is a net
  loss, not a win.
```
