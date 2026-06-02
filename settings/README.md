# Settings

`settings.template.json` is a sanitized version of my `~/.claude/settings.json` — preferences and the enabled-plugin / marketplace set.

It is a **template**, not auto-applied: `install.sh` never touches your `settings.json`, because clobbering someone's existing config is rude. Copy the bits you want into `~/.claude/settings.json` by hand.

## What's in it

- **`enabledPlugins` / `extraKnownMarketplaces`** — mirror of the plugin set (matches `install.sh` and `plugins/README.md`).
- **`alwaysThinkingEnabled: true`** — always show extended thinking.
- **`effortLevel: "xhigh"`** — maximum reasoning effort.
- **`autoCompactEnabled: false`** — I manage context manually.
- **`permissions`** — a broad `allow` list with `rm -rf` guardrails in `deny`.

## Deliberately omitted

My personal config also sets `skipDangerousModePermissionPrompt` and `skipAutoPermissionPrompt`, which bypass permission prompts. Those are a personal risk tradeoff and a poor default to hand to others, so they're left out of this template on purpose. Add them yourself only if you understand what they disable.
