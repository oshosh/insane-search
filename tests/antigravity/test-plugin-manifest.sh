#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXTENSION_JSON="$REPO_ROOT/gemini-extension.json"
MARKETPLACE_JSON="$REPO_ROOT/.agents/plugins/marketplace.json"

python3 - "$EXTENSION_JSON" "$MARKETPLACE_JSON" <<'PY'
import json
import sys
from pathlib import Path

ext_path = Path(sys.argv[1])
mkt_path = Path(sys.argv[2])

if not ext_path.exists():
    raise AssertionError(f"gemini-extension.json missing at {ext_path}")
if not mkt_path.exists():
    raise AssertionError(f"marketplace.json missing at {mkt_path}")

ext = json.loads(ext_path.read_text(encoding="utf-8"))
mkt = json.loads(mkt_path.read_text(encoding="utf-8"))

def assert_equal(actual, expected, label):
    if actual != expected:
        raise AssertionError(f"{label}: expected {expected!r}, got {actual!r}")

assert_equal(ext.get("name"), "insane-search", "gemini-extension.json name")
assert_equal(ext.get("contextFileName"), "GEMINI.md", "gemini-extension.json contextFileName")

assert_equal(mkt.get("name"), "insane-search-dev", "marketplace.json name")
plugins = mkt.get("plugins", [])
if not plugins or len(plugins) == 0:
    raise AssertionError("marketplace.json plugins list is empty")

plugin = plugins[0]
assert_equal(plugin.get("name"), "insane-search", "marketplace plugin name")
assert_equal(plugin.get("source", {}).get("url"), "./", "marketplace plugin url source")

print("Antigravity extension and marketplace manifests look good")
PY
