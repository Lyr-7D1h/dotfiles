---
name: code-review
description: (no description)
disable-model-invocation: true
---

Run `jj diff -r 'trunk()..@' --git --no-pager` to get the changes on this branch 
compared to trunk. The --git flag formats output as a unified diff which 
is easier to read.

Review the changes and focus on:
- Potential bugs or logic errors
- Security concerns  
- Code quality and best practices
- Anything that should be addressed before merging
- Don't run any testing commands
- Don't focus on compile errors
