# Feature specs

For any non-trivial feature, write a short spec **here first and get it approved
before writing code.** Forcing the spec surfaces assumptions early and cuts agent
thrash.

Name the file after the feature: `docs/specs/<feature>.md`. Keep it to a page.
See [`_template.md`](_template.md). Once approved, implement against the gates in
CLAUDE.md §4 and update ARCHITECTURE.md (+ any API contract) if the surface changed.
