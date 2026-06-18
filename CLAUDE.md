@AGENTS.md

# Claude Code Notes

This repository is also a Claude Code project.

Claude Code reads this `CLAUDE.md`; shared repository rules live in `AGENTS.md` and are imported above so Codex and Claude stay aligned.

Project skills are exposed through symlinks:

```text
.claude/skills/as2-retro-application-craft -> ../../creative/as2-retro-application-craft
.claude/skills/as2-swf-debug-pipeline -> ../../operations/as2-swf-debug-pipeline
```

Keep the canonical skill content in `creative/` and `operations/`. Do not copy the skill bodies into `.claude/skills/`, because duplicated skills drift quickly.

Claude-specific local settings or private notes should stay untracked.
