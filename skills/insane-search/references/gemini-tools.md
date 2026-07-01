# Antigravity CLI Tool Mapping for insane-search

The skill instructions in `SKILL.md` reference Claude Code-specific tool names. When executing the skill in the Google Antigravity environment, translate them to your platform-equivalent tools:

| Skill Reference | Antigravity Tool Equivalent | Purpose |
|:---|:---|:---|
| `Bash` | `run_command` | Execute the Python-based bypass engine (`python3 -m engine "<URL>"`) |
| `WebFetch` | `read_url_content` / `read_browser_page` | Direct web fetching (use only when not blocked/WAF-protected) |
| `WebSearch` | `search_web` | Keyword-based Google searches |
| `AskUserQuestion` | `ask_question` | Prompt the user for interactive questions (e.g. GitHub star check) |
| `Read` | `view_file` | View local reference files or logs |
| `Write` | `write_to_file` | Create files |
| `Edit` | `replace_file_content` / `multi_replace_file_content` | Modify existing files |
| `Grep` | `grep_search` | Find text patterns in files |
