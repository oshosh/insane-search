#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
MANIFEST="$REPO_ROOT/.claude-plugin/plugin.json"

python3 - "$MANIFEST" <<'PY'
import json
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
if not manifest_path.exists():
    raise AssertionError(f"Manifest missing at {manifest_path}")

manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

assert_equal(manifest.get("name"), "insane-search", "plugin name")
assert_equal(manifest.get("license"), "MIT", "plugin license")
assert_equal(manifest.get("author", {}).get("name"), "fivetaku", "author name")

keywords = manifest.get("keywords", [])
if not isinstance(keywords, list) or len(keywords) == 0:
    raise AssertionError("keywords list must not be empty")

print("Claude Code plugin manifest looks good")
PY
