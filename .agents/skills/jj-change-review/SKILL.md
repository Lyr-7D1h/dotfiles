---
name: jj-change-review
description: Use jj to get the diff of current open change and use AI to review it
disable-model-invocation: true
---

Run `jj diff --git --no-pager` to get the changes of this commit, and `jj log --no-graph -T description -r @ --no-pager` to get its description.

Please review this branch diff carefully. Point out any issues, potential bugs, or improvement opportunities you find.
Review the changes and focus on:
- Potential bugs or logic errors
- Security concerns  
- Code quality and best practices
- Anything that should be addressed before merging
- Don't run any testing commands
- Don't focus on compile errors

Organize your review by file, and for each file list findings grouped by severity (critical, warning, suggestion).

If the diff is very large, review files individually rather than all at once.
