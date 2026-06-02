# MCP servers

These are the [Model Context Protocol](https://modelcontextprotocol.io) servers I run. They are **not** auto-installed by `install.sh` because each one needs real credentials.

> ⚠️ **Never commit a filled-in config.** Claude Code reads MCP config from `~/.claude.json` (and project-scoped blocks inside it). Secrets belong there, not in this repo. `servers.template.json` ships only `${ENV_VAR}` placeholders.

## Setup

1. Copy `.env.example` → `.env` and fill in your values.
2. Open `servers.template.json`, substitute the placeholders, and merge the servers you want into the `mcpServers` object of your `~/.claude.json`.
   - Or use the CLI per server, e.g.:
     ```bash
     claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres "$POSTGRES_CONNECTION_STRING"
     ```
3. Restart Claude Code and confirm with `claude mcp list`.

## The global set (in `servers.template.json`)

| Server | Type | Needs | Notes |
|---|---|---|---|
| `postgres` | stdio | `POSTGRES_CONNECTION_STRING` | Read/query a Postgres DB. Point it at a **read replica**. |
| `linear` | stdio (mcp-remote) | OAuth (browser) | Linear issues/projects. No key in config — logs in on first use. |
| `posthog` | http | `POSTHOG_API_KEY` | Product analytics + SQL. |
| `grafana` | stdio (uvx) | `GRAFANA_URL`, `GRAFANA_SERVICE_ACCOUNT_TOKEN` | Dashboards, Prometheus/Loki, on-call. Needs [`uv`](https://docs.astral.sh/uv/). |
| `MCP_DOCKER` | stdio | Docker running | Docker MCP gateway — exposes containerized MCP tools. |

## Project-scoped servers (not included here)

I also run a few **work-internal**, per-repo MCP servers (Datadog, Metabase, Grafana Tempo, an internal knowledge server, a docs server). Those point at private infrastructure and live in the project-scoped `mcpServers` block of `~/.claude.json` for the specific repo — they're intentionally left out of this public repo. Configure your own equivalents the same way: a `type: "http"` entry with an `Authorization` header sourced from an env var.
