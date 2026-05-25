#!/usr/bin/env bash
# Install the Agent-Ready Kit. Two independent, additive modes — safe by default.
#   ./install.sh --global              # copy inert /agent-ready skill + subagents into ~/.claude
#   ./install.sh --target <repo>       # add CLAUDE.md, ARCHITECTURE.md, docs/ scaffolding to a repo
#   add --force to overwrite existing files (off by default)
set -euo pipefail
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL=0; TARGET=""; FORCE=0
while [ $# -gt 0 ]; do case "$1" in
  --global) GLOBAL=1;; --target) TARGET="$2"; shift;; --force) FORCE=1;;
  *) echo "unknown arg: $1"; exit 1;; esac; shift; done

copy_if_absent() { # src dst
  if [ -e "$2" ] && [ "$FORCE" -eq 0 ]; then echo "  skip (exists): $2"; return; fi
  mkdir -p "$(dirname "$2")"; cp "$1" "$2"; echo "  wrote: $2"
}

if [ "$GLOBAL" -eq 0 ] && [ -z "$TARGET" ]; then
  echo "Nothing to do. Use --global and/or --target <repo>."; exit 0
fi

if [ "$GLOBAL" -eq 1 ]; then
  CLAUDE="$HOME/.claude"
  echo "Installing global (inert) pieces into $CLAUDE ..."
  copy_if_absent "$KIT/claude/skills/agent-ready/SKILL.md" "$CLAUDE/skills/agent-ready/SKILL.md"
  for f in "$KIT"/claude/agents/*.md; do copy_if_absent "$f" "$CLAUDE/agents/$(basename "$f")"; done
  echo "Done. /agent-ready + subagents available across repos (inert until invoked)."
  echo "NOTE: global ~/.claude/CLAUDE.md NOT touched. To adopt cross-project rules,"
  echo "      review and copy claude/global-CLAUDE.md there yourself."
fi

if [ -n "$TARGET" ]; then
  [ -d "$TARGET" ] || { echo "Target not found: $TARGET"; exit 1; }
  echo "Scaffolding templates into $TARGET ..."
  copy_if_absent "$KIT/templates/CLAUDE.md"       "$TARGET/CLAUDE.md"
  copy_if_absent "$KIT/templates/ARCHITECTURE.md" "$TARGET/ARCHITECTURE.md"
  (cd "$KIT/templates" && find docs -type f) | while read -r rel; do
    copy_if_absent "$KIT/templates/$rel" "$TARGET/$rel"
  done
  echo "Done. Fill the <PLACEHOLDERS>, add a ci/*-gates.yml, follow PLAYBOOK.md."
  echo "TIP: with Claude Code, run /agent-ready in the repo to fill these from the actual code."
fi
