# insane-search Tests

Test suite and verification guide for `insane-search` across different environment runtimes: **Claude Code** and **Google Antigravity (`agy`)**.

## Directory Structure

```
tests/
├── README.md                      # This document (English)
├── README.ko.md                   # Korean translation of this document
├── claude-code/
│   └── test-plugin-manifest.sh    # Verifies .claude-plugin/plugin.json syntax and fields
└── antigravity/
    ├── run-tests.sh               # Runs all Antigravity integration tests
    ├── test-plugin-manifest.sh    # Verifies gemini-extension.json and marketplace.json
    └── test-antigravity-tools.sh  # Verifies references/gemini-tools.md tool mappings
```

---

## 1. Engine & Network Coverage Tests

### Python Unit & Smoke Tests
These tests verify core components of the python bypass engine (validators, URL transformers, and profile loaders) and run basic smoke checks against mock or live benign endpoints.
* **Path:** `skills/insane-search/engine/tests/`
* **Run command:**
  ```bash
  python skills/insane-search/engine/tests/test_smoke.py
  ```

### Live Coverage Battery
The coverage battery tests the network-live bypass routes for all supported platforms (Reddit, X, YouTube, HN, arXiv, Naver, LinkedIn). It checks that the syndication gateways, oEmbed routes, RSS feeds, and TLS-impersonation layers are functioning correctly.
* **Path:** `skills/insane-search/tests/coverage_battery.py`
* **Run command (all platforms):**
  ```bash
  python skills/insane-search/tests/coverage_battery.py
  ```
* **Run command (specific platforms):**
  ```bash
  python skills/insane-search/tests/coverage_battery.py reddit x naver
  ```
* **Output JSON results:**
  ```bash
  python skills/insane-search/tests/coverage_battery.py --json
  ```

---

## 2. Claude Code Integration Tests

### Manifest Verification
Validates that `.claude-plugin/plugin.json` conforms to Claude Code plugin requirements, verifying attributes like `name`, `version`, `author`, and plugin keywords.
* **Run command:**
  ```bash
  bash tests/claude-code/test-plugin-manifest.sh
  ```

---

## 3. Google Antigravity (agy) Integration Tests

### Antigravity Test Suite
Runs all integration and verification checks for Google Antigravity.
* **Run command:**
  ```bash
  bash tests/antigravity/run-tests.sh
  ```

### Manifest Verification
Checks that the extension metadata (`gemini-extension.json`) and the local marketplace settings (`.agents/plugins/marketplace.json`) are correctly defined so the plugin loads dynamically and registers in the `/skills` menu.
* **Run command:**
  ```bash
  bash tests/antigravity/test-plugin-manifest.sh
  ```

### Tool Mapping Verification
Checks that `gemini-tools.md` contains the correct equivalents mapping Claude Code tools to Antigravity tools (e.g. `Bash` -> `run_command`), and that `SKILL.md` is properly linked.
* **Run command:**
  ```bash
  bash tests/antigravity/test-antigravity-tools.sh
  ```

---

## 4. Interactive Bypass Verification

You can manually trigger the bypass engine to verify that WAF-protected pages are retrieved successfully (returning `200 OK` structure) compared to standard HTTP clients which get blocked (returning `403 Forbidden` / `503 Service Unavailable`).

### Akamai Bypass Test (Coupang)
```powershell
# 1. Standard curl gets blocked by WAF
curl.exe --ssl-no-revoke -I https://www.coupang.com

# 2. insane-search bypass engine succeeds
$env:PYTHONPATH="skills/insane-search"; python -X utf8 -m engine "https://www.coupang.com"
```

### Cloudflare Bypass Test (FMKorea)
```powershell
# 1. Standard curl gets blocked by Cloudflare (503 / Challenge page)
curl.exe --ssl-no-revoke -I https://www.fmkorea.com

# 2. insane-search bypass engine succeeds
$env:PYTHONPATH="skills/insane-search"; python -X utf8 -m engine "https://www.fmkorea.com"
```
