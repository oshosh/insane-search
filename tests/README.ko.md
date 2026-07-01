# insane-search 테스트 가이드

각 환경 런타임인 **Claude Code** 및 **Google Antigravity (`agy`)**에서 `insane-search` 플러그인의 정상 로드 및 작동 여부를 검증하기 위한 테스트 가이드라인입니다.

## 디렉토리 구조

```
tests/
├── README.md                      # 테스트 가이드라인 (영문)
├── README.ko.md                   # 테스트 가이드라인 (국문 - 본 문서)
├── claude-code/
│   └── test-plugin-manifest.sh    # .claude-plugin/plugin.json 구문 및 필드 검증
└── antigravity/
    ├── run-tests.sh               # Antigravity 관련 전체 통합 테스트 실행 스크립트
    ├── test-plugin-manifest.sh    # gemini-extension.json 및 marketplace.json 검증
    └── test-antigravity-tools.sh  # references/gemini-tools.md 도구 매핑 규칙 검증
```

---

## 1. 코어 엔진 및 네트워크 커버리지 테스트

### Python 유닛 및 스모크 테스트
우회 바이패스 엔진의 핵심 로직(검증기, URL 변환기, WAF 프로필 로더)이 잘 로딩되는지 유닛 테스트와 정상 엔드포인트에 대한 자가 검증을 수행합니다.
* **경로:** `skills/insane-search/engine/tests/`
* **실행 명령어:**
  ```bash
  python skills/insane-search/engine/tests/test_smoke.py
  ```

### 실시간 플랫폼 라이브 커버리지 검증 (Coverage Battery)
각각 지원되는 주요 플랫폼(Reddit, X, YouTube, HN, arXiv, Naver, LinkedIn)의 우회 경로(syndication, oEmbed, RSS, TLS-impersonation 등)가 정상 작동하는지 실시간 통신을 통해 검증합니다.
* **경로:** `skills/insane-search/tests/coverage_battery.py`
* **실행 명령어 (전체 플랫폼 대상):**
  ```bash
  python skills/insane-search/tests/coverage_battery.py
  ```
* **실행 명령어 (특정 플랫폼 선택):**
  ```bash
  python skills/insane-search/tests/coverage_battery.py reddit x naver
  ```
* **결과 JSON으로 추출:**
  ```bash
  python skills/insane-search/tests/coverage_battery.py --json
  ```

---

## 2. Claude Code 연동 테스트

### 플러그인 매니페스트 검증
`.claude-plugin/plugin.json` 파일이 Claude Code 플러그인 규격(이름, 버전, 작성자 정보, 키워드 정의)에 올바르게 부합하는지 검증합니다.
* **실행 명령어:**
  ```bash
  bash tests/claude-code/test-plugin-manifest.sh
  ```

---

## 3. Google Antigravity (agy) 연동 테스트

### Antigravity 통합 테스트 실행
Antigravity 런타임에 대한 모든 플러그인 사양 및 도구 매핑 자동화 테스트를 일괄 구동합니다.
* **실행 명령어:**
  ```bash
  bash tests/antigravity/run-tests.sh
  ```

### 확장 기능 매니페스트 및 로컬 마켓플레이스 설정 검증
확장 프로그램 정보 파일인 `gemini-extension.json`과 agy 에이전트의 `/skills` 목록에 스킬이 노출되도록 하는 `.agents/plugins/marketplace.json` 설정이 규격에 맞게 기입되어 있는지 검증합니다.
* **실행 명령어:**
  ```bash
  bash tests/antigravity/test-plugin-manifest.sh
  ```

### 도구 매핑 파일(Tool Mapping) 검증
`gemini-tools.md`가 Claude Code용 도구를 Antigravity용 도구(예: `Bash` -> `run_command`)로 잘 번역하여 매핑해두었는지, 그리고 `SKILL.md`가 이에 연결되어 있는지를 검증합니다.
* **실행 명령어:**
  ```bash
  bash tests/antigravity/test-antigravity-tools.sh
  ```

---

## 4. 실시간 수동 우회 검증 (Interactive Verification)

사용자 환경의 터미널에서 아래 테스트를 구동하여 WAF(웹 방화벽) 보안 솔루션이 걸려 있는 실제 사이트들을 어떻게 우회해서 뚫어내는지 직접 확인할 수 있습니다.

### Akamai 우회 테스트 (쿠팡 대상)
```powershell
# 1. 일반 curl이나 브라우저가 없는 단순 요청은 Akamai에 의해 403 Forbidden으로 차단됨
curl.exe --ssl-no-revoke -I https://www.coupang.com

# 2. insane-search의 위장 및 우회 엔진 작동 시 200 OK 수준의 정상적인 결과를 긁어옴
$env:PYTHONPATH="skills/insane-search"; python -X utf8 -m engine "https://www.coupang.com"
```

### Cloudflare 우회 테스트 (에펨코리아 대상)
```powershell
# 1. 일반 curl 요청 시 Cloudflare 보안 챌린지로 인해 503 Service Unavailable 및 봇 방지 화면 반환
curl.exe --ssl-no-revoke -I https://www.fmkorea.com

# 2. insane-search 우회 엔진 실행 시 정상적인 페이지 데이터 확보 성공
$env:PYTHONPATH="skills/insane-search"; python -X utf8 -m engine "https://www.fmkorea.com"
```
