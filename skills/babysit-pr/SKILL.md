---
name: babysit-pr
description: Use when the user wants to monitor an open PR through CI and code review, automatically fixing failures and addressing review comments until it's green. Trigger on phrases like "babysit this PR", "watch CI", "monitor this PR", "keep an eye on this", "fix CI", "handle review comments", "get this PR to green", or when invoked by the /land skill after opening a PR. Also useful when the user pastes a PR URL and wants it shepherded to completion.
---

# Babysit PR

You are monitoring an open PR, automatically fixing CI failures and addressing review comments until the PR is green and ready to merge.

**Announce at start:** "Babysitting PR #<number> — I'll watch CI and review comments, fix issues as they come up, and let you know when it's ready."

## Step 1: Identify the PR

Figure out which PR to babysit:
- If invoked by `/land`, the PR number/URL should already be in context
- If the user provided a PR URL or number, use that
- Otherwise, check for an open PR on the current branch:
  ```bash
  gh pr view --json number,url,headRefName
  ```

## Step 2: Start the monitoring loop

Use the Skill tool to invoke `/loop` with a 2-minute interval. On each iteration, run through the checks below.

### Checking CI status

```bash
gh pr checks <pr-number> --json name,state,conclusion
```

- `state: "COMPLETED"` + `conclusion: "SUCCESS"` = passing
- `state: "COMPLETED"` + `conclusion: "FAILURE"` = needs fixing
- `state: "IN_PROGRESS"` or `state: "PENDING"` = still running, wait for next loop iteration

Don't treat "pending" as a failure — CI just hasn't finished yet.

### Checking review comments

Check all three places reviewers may leave feedback:

```bash
# Review-level comments (from formal reviews)
gh api repos/{owner}/{repo}/pulls/<pr-number>/reviews

# Inline and standalone PR comments (not tied to a review)
gh api repos/{owner}/{repo}/pulls/<pr-number>/comments

# General issue-style comments on the PR
gh api repos/{owner}/{repo}/issues/<pr-number>/comments
```

Look for unresolved review comments, requested changes, and any standalone comments that need addressing. Ignore your own comments and resolved threads.

### On each iteration, decide what to do

1. **All checks green + no unresolved comments** → stop the loop, notify user: "PR #<number> is green and review comments are addressed — ready to merge: <PR-URL>"
2. **CI failure** → fix it (see below), commit, push, let the loop continue
3. **Review comments** → address them (see below), commit, push, let the loop continue
4. **Everything still pending** → do nothing, let the loop continue
5. **Max iterations (10) or stuck** → stop the loop, tell the user what's still failing

## Fixing CI failures

1. Read the failing check's logs: `gh run view <run-id> --log-failed`
2. Understand the root cause
3. Fix the code
4. Commit with a message like "fix: address CI failure in <check-name>"
5. Push

## Addressing review comments

1. Read each comment carefully
2. Fix everything that makes sense — style issues, bugs, missing tests, naming, etc.
3. Only stop and ask the user if a comment is genuinely ambiguous, requests a fundamental design change, or conflicts with another comment. The bar for asking should be high — most review feedback has a clear intended fix.
4. Commit with a message like "fix: address review feedback"
5. Push
6. Reply to each comment on GitHub explaining what you did:
   ```bash
   gh api repos/{owner}/{repo}/pulls/<pr-number>/comments/<comment-id>/replies -f body="Fixed — <brief explanation>"
   ```

## Exit conditions

- **Success:** All CI checks pass AND no unresolved review comments → notify user it's ready to merge
- **Max iterations (10):** Stop and tell the user what's still failing. Don't keep going in circles.
- **Stuck:** If the same CI check fails 3 times in a row with the same error, stop and ask the user for help rather than guessing.

## Important behaviors

- **Don't over-commit.** Each fix cycle should be one focused commit, not a sprawling change.
- **Don't fight the linter.** If a linting check fails, fix the lint issues directly rather than trying to suppress them.
- **Preserve the user's intent.** When fixing review comments, stay close to the original approach unless the reviewer explicitly asks for a redesign.
- **Be transparent.** After each fix-and-push cycle, briefly tell the user what you fixed.
- **Know when to stop.** If you're going in circles or a fix requires deep domain knowledge you don't have, ask the user.
