# phils-skills

My personal [Claude Code](https://claude.com/claude-code) setup — the skills I wrote, the plugins I run, and templates for my MCP servers and settings. One command to replicate the portable parts on a fresh machine.

## Quick install

```bash
git clone https://github.com/chmaltsp/phils-skills.git
cd phils-skills
./install.sh
```

Or in one line:

```bash
curl -fsSL https://raw.githubusercontent.com/chmaltsp/phils-skills/main/install.sh | bash
```

`install.sh` does two things:

1. **Skills** → symlinks `skills/*` into `~/.claude/skills/` (use `--copy` to copy instead).
2. **Plugins** → adds the marketplaces and installs the plugin set.

It deliberately does **not** touch MCP config or your `settings.json` — those need your own secrets / are yours to own. See below.

Flags: `--skills-only`, `--plugins-only`, `--copy`, `--help`.

## What's in here

| Path | What | Auto-installed? |
|---|---|---|
| [`skills/`](skills/) | Skills I wrote: `land`, `babysit-pr` | ✅ by `install.sh` |
| [`plugins/`](plugins/README.md) | Marketplace + plugin manifest | ✅ by `install.sh` |
| [`mcp/`](mcp/README.md) | Sanitized MCP server templates (`${ENV_VAR}` placeholders) | ❌ needs your secrets |
| [`settings/`](settings/README.md) | Sanitized `settings.json` template | ❌ copy what you want |

## The skills

- **`land`** — "ship it / land the plane." Cleans up the diff, commits, pushes, opens a PR, then hands off to `babysit-pr`. Orchestrates `/simplify`, `/commit-push-pr`, `/babysit-pr`, `/loop`.
- **`babysit-pr`** — watches an open PR on a `/loop`: reads CI status and review comments, auto-fixes failures, replies to reviewers, and stops when it's green. Only needs `gh` + `/loop`.

> `land` depends on the **commit-commands** and **code-review** plugins (installed by `install.sh`). `babysit-pr` is near-standalone.

## After installing

Restart Claude Code, then:

```
/land          # finish up the current work and open a PR
/babysit-pr    # watch an open PR to green
```

## Security notes

This repo is public, so:

- **No secrets are committed.** MCP configs ship as `${ENV_VAR}` placeholders only; real values go in your `~/.claude.json` / a gitignored `.env`.
- **No work-internal content.** Company-specific skills and project-scoped MCP servers (Datadog, Metabase, internal Grafana/Tempo, etc.) are intentionally excluded.
- The settings template omits the prompt-bypass flags I run personally — see [`settings/README.md`](settings/README.md).

## License

[MIT](LICENSE)
