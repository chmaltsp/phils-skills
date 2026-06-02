#!/usr/bin/env bash
#
# phils-skills installer
#
#   curl -fsSL https://raw.githubusercontent.com/chmaltsp/phils-skills/main/install.sh | bash
#   # or, after cloning:
#   ./install.sh
#
# What it does:
#   1. Links the personal skills (land, babysit-pr) into ~/.claude/skills/
#   2. Adds the plugin marketplaces and installs the plugin set
#
# What it does NOT do (needs your secrets — see mcp/README.md and settings/):
#   - Configure MCP servers
#   - Overwrite your ~/.claude/settings.json
#
# Flags:
#   --copy           Copy skills instead of symlinking (default: symlink)
#   --skills-only    Only install skills, skip plugins
#   --plugins-only   Only install plugins, skip skills
#   -h, --help       Show this help

set -euo pipefail

COPY=false
DO_SKILLS=true
DO_PLUGINS=true

for arg in "$@"; do
  case "$arg" in
    --copy)        COPY=true ;;
    --skills-only) DO_PLUGINS=false ;;
    --plugins-only) DO_SKILLS=false ;;
    -h|--help)
      sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

# Resolve the directory this script lives in (works when cloned).
# When piped via curl, fall back to a fresh clone in a temp dir.
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
  REPO_DIR="$(mktemp -d)/phils-skills"
  echo "==> Cloning phils-skills into $REPO_DIR"
  git clone --depth 1 https://github.com/chmaltsp/phils-skills.git "$REPO_DIR"
fi

SKILLS_DEST="$HOME/.claude/skills"

# --- Skills --------------------------------------------------------------
if $DO_SKILLS; then
  echo "==> Installing skills into $SKILLS_DEST"
  mkdir -p "$SKILLS_DEST"
  for skill_dir in "$REPO_DIR"/skills/*/; do
    name="$(basename "$skill_dir")"
    dest="$SKILLS_DEST/$name"
    if [[ -e "$dest" || -L "$dest" ]]; then
      echo "    - $name already exists at $dest — skipping (remove it first to reinstall)"
      continue
    fi
    if $COPY; then
      cp -R "$skill_dir" "$dest"
      echo "    - copied $name"
    else
      ln -s "${skill_dir%/}" "$dest"
      echo "    - linked $name -> ${skill_dir%/}"
    fi
  done
fi

# --- Plugins -------------------------------------------------------------
if $DO_PLUGINS; then
  if ! command -v claude >/dev/null 2>&1; then
    echo "==> 'claude' CLI not found on PATH — skipping plugin install."
    echo "    Install Claude Code, then re-run: ./install.sh --plugins-only"
  else
    echo "==> Adding marketplaces"
    # The official marketplace ships with Claude Code; the rest are added explicitly.
    claude plugin marketplace add anthropics/claude-plugins-official || true
    claude plugin marketplace add openai/codex-plugin-cc            || true
    claude plugin marketplace add seamapi/seam-plugin               || true
    claude plugin marketplace add btucker/blindspots                || true

    echo "==> Installing plugins"
    PLUGINS=(
      "context7@claude-plugins-official"
      "code-review@claude-plugins-official"
      "explanatory-output-style@claude-plugins-official"
      "commit-commands@claude-plugins-official"
      "superpowers@claude-plugins-official"
      "typescript-lsp@claude-plugins-official"
      "skill-creator@claude-plugins-official"
      "codex@openai-codex"
      "seam@seamapi"
      "blindspots@blindspots"
    )
    for plugin in "${PLUGINS[@]}"; do
      echo "    - $plugin"
      claude plugin install "$plugin" || echo "      (failed — install manually: claude plugin install $plugin)"
    done
  fi
fi

echo ""
echo "==> Done."
echo "    Skills:   restart Claude Code, then type /land or /babysit-pr"
echo "    MCP:      see mcp/README.md to wire up MCP servers (needs your own secrets)"
echo "    Settings: see settings/settings.template.json for preference defaults"
