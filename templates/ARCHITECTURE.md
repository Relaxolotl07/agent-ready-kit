# <PROJECT> — System Truth (current state)

The **factual map** an agent reads first. Rules live in [CLAUDE.md](CLAUDE.md);
*facts* live here. Keep this current — a stale map causes confident wrong changes.
Regenerate the generated sections (see the doc-freshness gate) rather than
hand-editing them.

## 1. Shape

<One paragraph + a diagram/flow: the surfaces and how data moves between them.>
```
<client(s)> → <api/entry> → <layer> → <layer> → <store>
```

## 2. Data model (`<models file>` → `<store>`)

| Table / type | Owns | Key fields |
|--------------|------|-----------|
| `<name>` | <what> | <fields> |

## 3. Public surface (verified inventory)

<Endpoints / commands / exported API. Prefer a generated section kept fresh by the
doc-freshness gate.>

| Method | Path / name | Module | Notes |
|--------|-------------|--------|-------|
| <…> | <…> | <…> | <…> |

## 4. Modules / services (the logic layer)

| Module | Responsibility | Key public functions |
|--------|----------------|----------------------|
| `<module>` | <what it owns> | <fns> |

## 5. Live vs. dead

- **LIVE:** <the real paths>.
- **DEAD / deprecated:** <imported-nowhere code slated for deletion> — don't
  extend or copy it.

## 6. Known divergences from older docs

<Where stale specs disagree with reality; this doc + CLAUDE.md win.>

---

### Keeping this current

When you change the public surface or data model, update the relevant section here
in the same change, and regenerate any generated sections so the doc-freshness
gate passes.
