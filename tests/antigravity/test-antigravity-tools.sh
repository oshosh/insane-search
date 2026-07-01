#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MAPPING="$REPO_ROOT/skills/insane-search/references/gemini-tools.md"
GEMINI_MD="$REPO_ROOT/GEMINI.md"

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "test-antigravity-tools: checking Antigravity tool mapping"

# --- Mapping exists ---------------------------------------------------------
[ -f "$MAPPING" ] || fail "tool mapping missing at $MAPPING"

# --- Skill-load mechanism: view_file on SKILL.md (IsSkillFile), no Skill tool -
grep -qiE "view_file" "$MAPPING" \
  || fail "mapping does not document view_file as the file/skill-read tool"
grep -qiE "SKILL\.md" "$MAPPING" \
  || fail "mapping does not document reading SKILL.md as the skill-load path"

# --- Core action→tool mappings are documented -------------------------------
for tool in write_to_file replace_file_content run_command grep_search ask_question; do
  grep -q "$tool" "$MAPPING" \
    || fail "mapping does not document the '$tool' tool"
done

# --- GEMINI.md references gemini-tools.md ----------------------------------
[ -f "$GEMINI_MD" ] || fail "GEMINI.md missing at root"
grep -q "gemini-tools.md" "$GEMINI_MD" \
  || fail "GEMINI.md does not reference gemini-tools.md"

echo "PASS: Antigravity tool mapping valid"
