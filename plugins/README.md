# Plugins

These are the Claude Code plugins I run, and the marketplaces they come from. `install.sh` adds every marketplace and installs the whole set; this file is the human-readable manifest if you'd rather pick and choose.

A *marketplace* is just a GitHub repo with a plugin manifest. You add it once, then install plugins from it by `name@marketplace`.

## Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official   # ships by default; safe to re-add
claude plugin marketplace add openai/codex-plugin-cc
claude plugin marketplace add seamapi/seam-plugin
claude plugin marketplace add btucker/blindspots
```

## Plugins

```bash
# Anthropic official marketplace
claude plugin install context7@claude-plugins-official              # live library docs lookup
claude plugin install code-review@claude-plugins-official           # /code-review, /security-review
claude plugin install commit-commands@claude-plugins-official       # /commit, /commit-push-pr, /clean_gone
claude plugin install superpowers@claude-plugins-official           # brainstorming, TDD, debugging, plan workflows
claude plugin install skill-creator@claude-plugins-official         # author/evaluate skills
claude plugin install typescript-lsp@claude-plugins-official        # TS language-server tools
claude plugin install explanatory-output-style@claude-plugins-official  # the teaching output style

# Other marketplaces
claude plugin install codex@openai-codex                            # delegate to OpenAI Codex as a subagent
claude plugin install seam@seamapi                                  # Seam API integration skills + docs MCP
claude plugin install blindspots@blindspots                         # persona-driven dogfooding / user trials
```

> `mcp-server-dev@claude-plugins-official` is also handy when building MCP servers — I install it per-project rather than globally, so it's left out of the default set.

## How my skills depend on these

The `land` skill in this repo orchestrates other commands:

- `/land` → `/simplify` (or `/code-review`, from **code-review**) → `/commit-push-pr` (from **commit-commands**) → `/babysit-pr` (this repo) → `/loop` (built in)

So if you install `land`, you'll want **commit-commands** and **code-review** too, or the chain breaks. `babysit-pr` only needs `gh` and the built-in `/loop`.
