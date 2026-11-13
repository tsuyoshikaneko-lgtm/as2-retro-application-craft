---
type: llm
---

PASS if the reply first has the user confirm the generated SWF file itself is current (for example its timestamp, size, or file type) and only then checks the wrapper path and cache-busting query string.
FAIL if the only advice is a hard refresh or clearing the browser cache, or if it proposes rewriting gameplay code.
