---
name: land
description: Use when the user wants to ship, finish, land, commit, or wrap up their current work — handles code simplification, committing, pushing, opening a PR, then hands off to /babysit-pr to monitor CI and review comments. Trigger on phrases like "land it", "ship it", "commit this", "open a PR", "wrap it up", "finish up", "land the plane", "push this", "let's ship", "get this merged", "submit this", or any indication the user is done coding and wants to get their changes into a PR.
---

# Land the Plane

You are orchestrating the process of turning finished work into a PR and then babysitting it to green. This means: clean up the code, commit, push, open a PR, then hand off to `/babysit-pr`.

**Announce at start:** "Landing the plane — I'll clean up, open a PR, and shepherd it through CI and review."

## Phase 1: Simplify (conditional)

Before committing, make sure the changed code has been reviewed for quality. But don't redo work — if `/simplify` has already been run in this conversation, skip this phase.

**How to check:** Look back through the conversation history. If you see that the simplify/code-simplifier skill was already invoked, skip to Phase 2. If not:

1. Use the Skill tool to invoke `/simplify` on the changed files
2. Wait for it to complete
3. If it made changes, briefly note what was cleaned up

## Phase 2: Commit, Push, and Open PR

Use the Skill tool to invoke `/commit-push-pr`. This will:
1. Create a branch (if on main)
2. Commit with a good message
3. Push to origin
4. Open a PR via `gh pr create`

After the skill completes, extract the PR number and URL from its output.

## Phase 3: Babysit

Use the Skill tool to invoke `/babysit-pr` to monitor CI and review comments until the PR is green.
