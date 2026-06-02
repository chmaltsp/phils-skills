# Settings

`settings.template.json` is a sanitized version of my `~/.claude/settings.json` — preferences and the enabled-plugin / marketplace set.

It is a **template**, not auto-applied: `install.sh` never touches your `settings.json`, because clobbering someone's existing config is rude. Copy the bits you want into `~/.claude/settings.json` by hand.

## What's in it

- **`enabledPlugins` / `extraKnownMarketplaces`** — mirror of the plugin set (matches `install.sh` and `plugins/README.md`).
- **`alwaysThinkingEnabled: true`** — always show extended thinking.
- **`effortLevel: "xhigh"`** — maximum reasoning effort.
- **`autoCompactEnabled: false`** — I manage context manually.
- **`permissions`** — a broad `allow` list with `rm -rf` guardrails in `deny`.
- **`skipDangerousModePermissionPrompt: true`** + **`skipAutoPermissionPrompt: true`** — the two flags that make `auto` mode actually feel frictionless: Claude Code stops interrupting to ask for permission on every action and on entering bypass mode.

## ⚠️ Heads up on the permission flags

`skipDangerousModePermissionPrompt` and `skipAutoPermissionPrompt` are a deliberate risk tradeoff: they let Claude run tools (including shell commands) without prompting you each time. That's what makes the workflow feel fast, but it means you're trusting the `allow`/`deny` lists to be your only guardrail. The `deny` rules here block the obvious `rm -rf` footguns — review them and add your own before relying on this. If you'd rather keep the prompts, just drop these two keys.
