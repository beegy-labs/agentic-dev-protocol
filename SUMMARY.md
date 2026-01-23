# llm-dev-protocol 완성 요약

> CDD/SDD/ADD 표준 + Agent CLI 기반 문서 자동 생성 + 강제 동기화

## 📦 완성된 기능

### 1. 마커 기반 AGENTS.md 구조

```markdown
<!-- BEGIN: STANDARD POLICY -->
... 공통 표준 (llm-dev-protocol에서 강제 동기화) ...
<!-- END: STANDARD POLICY -->

<!-- BEGIN: PROJECT CUSTOM -->
... 프로젝트별 커스텀 (각 프로젝트에서 편집 가능) ...
<!-- END: PROJECT CUSTOM -->
```

### 2. Agent별 문서 자동 생성

각 LLM Agent CLI가 AGENTS.md를 읽고 자신에게 최적화된 문서 생성:

| Agent | CLI | 최적화 |
| ----- | --- | ------ |
| Claude | `claude` | 긴 문맥, 복잡한 추론, chain-of-thought |
| Gemini | `gemini` / `aistudio` | 1M+ context, 멀티모달, 빠른 반복 |
| Cursor | Fallback | IDE 통합, 인라인 편집 |

### 3. CDD Tier 3/4 자동 생성

**LLM Provider 자동 감지**:
1. Local LLM (Ollama, vLLM, LM Studio) 우선
2. 없으면 Claude CLI
3. 없으면 Gemini CLI  
4. 없으면 OpenAI CLI
5. 모두 없으면 오류

**Tier 3 생성 (docs/llm/ → docs/en/)**:
```bash
./scripts/docs-generate.sh              # Auto-detect
./scripts/docs-generate.sh --provider local
./scripts/docs-generate.sh --provider claude
```

**Tier 4 번역 (docs/en/ → docs/kr/, docs/ja/, ...)**:
```bash
./scripts/docs-translate.sh --locale kr  # Korean
./scripts/docs-translate.sh --locale ja  # Japanese
./scripts/docs-translate.sh --locale zh  # Chinese
```

### 4. 강제 동기화 시스템

```bash
cd llm-dev-protocol

# 모든 등록된 프로젝트에 강제 동기화
./scripts/sync-standards.sh

# 실행 내역:
# ✓ AGENTS.md (STANDARD만, CUSTOM 보존)
# ✓ CLAUDE.md, GEMINI.md, CURSOR.md 자동 생성
# ✓ 정책 파일들 (cdd.md, sdd.md, add.md, ...)
# ✓ CDD 스크립트들 (docs-generate.sh, docs-translate.sh)
# ✓ 구조 검증
```

## 🗂️ 최종 디렉토리 구조

```
llm-dev-protocol/
├── AGENTS.md                          # 공통 표준 (마커 기반)
├── README.md
├── QUICKSTART.md
├── ARCHITECTURE.md
├── SUMMARY.md                         # 이 파일
├── LICENSE
├── .gitignore
│
├── .ai/
│   └── README.md
│
├── docs/
│   ├── llm/                           # Tier 2 (SSOT)
│   │   ├── README.md
│   │   └── policies/
│   │       ├── development-methodology.md
│   │       ├── cdd.md
│   │       ├── sdd.md
│   │       ├── add.md
│   │       └── agents-customization.md
│   ├── en/                            # Tier 3 (auto-generated)
│   └── kr/                            # Tier 4 (auto-translated)
│
├── .specs/
│   └── README.md
│
├── .github/workflows/
│   └── propagate-to-projects.yml
│
├── scripts/
│   ├── sync-standards.sh              # 🔄 메인 동기화
│   ├── sync-agents-md.sh              # AGENTS.md 마커 기반 동기화
│   ├── generate-agent-docs.sh         # 🤖 Claude/Gemini/Cursor 문서 생성
│   ├── docs-generate.sh               # 📄 Tier 2 → Tier 3
│   ├── docs-translate.sh              # 🌍 Tier 3 → Tier 4
│   ├── migrate-agents-md.sh           # 기존 AGENTS.md 마이그레이션
│   └── validate-structure.sh          # 구조 검증
│
├── templates/
│   └── prompts/                       # Agent CLI용 프롬프트
│
└── projects.json                      # 프로젝트 설정
```

## 🎯 핵심 메커니즘

### 1. AGENTS.md 동기화

```
llm-dev-protocol/AGENTS.md 변경
    ↓
sync-standards.sh 실행
    ↓
모든 프로젝트의 AGENTS.md 업데이트
    ├─ STANDARD POLICY 섹션: 덮어쓰기
    └─ PROJECT CUSTOM 섹션: 보존
```

### 2. Agent 문서 생성

```
프로젝트/AGENTS.md 존재
    ↓
generate-agent-docs.sh --all
    ├─ Claude CLI → CLAUDE.md
    ├─ Gemini CLI → GEMINI.md
    └─ Fallback → CURSOR.md
```

### 3. CDD 문서 생성

```
프로젝트/docs/llm/*.md (Tier 2)
    ↓
docs-generate.sh --provider auto
    ↓
프로젝트/docs/en/*.md (Tier 3)
    ↓
docs-translate.sh --locale kr
    ↓
프로젝트/docs/kr/*.md (Tier 4)
```

## 📋 사용 시나리오

### 시나리오 1: 새 프로젝트 초기화

```bash
# 1. llm-dev-protocol에 프로젝트 등록
vim llm-dev-protocol/projects.json

# 2. 표준 동기화
cd llm-dev-protocol
./scripts/sync-standards.sh

# 3. 프로젝트별 커스터마이징
cd ../my-new-project
vim AGENTS.md  # PROJECT CUSTOM 섹션 편집

# 4. Agent 문서 생성
cd ../llm-dev-protocol
./scripts/generate-agent-docs.sh --project ../my-new-project --all

# 5. CDD 문서 생성
cd ../my-new-project
./scripts/docs-generate.sh           # Tier 2 → Tier 3
./scripts/docs-translate.sh --locale kr  # Tier 3 → Tier 4
```

### 시나리오 2: 표준 업데이트 전파

```bash
# 1. 표준 변경
cd llm-dev-protocol
vim AGENTS.md  # STANDARD POLICY 섹션 수정
vim docs/llm/policies/cdd.md  # 정책 업데이트

# 2. 모든 프로젝트에 전파
./scripts/sync-standards.sh

# 결과:
# - 모든 프로젝트 AGENTS.md STANDARD 섹션 업데이트
# - 모든 프로젝트 정책 파일 업데이트
# - 모든 프로젝트 CDD scripts 업데이트
# - 각 프로젝트 CUSTOM 섹션은 보존
# - Agent 문서 (CLAUDE.md, GEMINI.md) 자동 재생성
```

### 시나리오 3: LLM Provider 전환

```bash
# Local LLM 설치 전: Claude 사용
./scripts/docs-generate.sh --provider claude

# Local LLM 설치 후: 자동 전환
./scripts/docs-generate.sh  # Ollama 자동 감지 및 사용

# 특정 provider 강제 지정
./scripts/docs-generate.sh --provider local --model qwen2.5:32b
```

## 🔐 강제 표준 메커니즘

1. **AGENTS.md STANDARD 섹션**: llm-dev-protocol에서만 수정, 프로젝트는 sync로만 업데이트
2. **정책 파일들**: llm-dev-protocol에서 직접 동기화, 프로젝트에서 수정 금지
3. **CDD 스크립트들**: llm-dev-protocol에서 강제 동기화, 모든 프로젝트가 동일한 방식 사용
4. **마커 보호**: pre-commit hook으로 STANDARD 섹션 수정 차단 가능

## ⚙️ 설정 파일

### projects.json

```json
{
  "projects": [
    {
      "name": "my-girok",
      "path": "../my-girok",
      "enabled": true,
      "sync": {
        "AGENTS.md": true,
        "docs/llm/policies/development-methodology.md": true,
        "docs/llm/policies/cdd.md": true,
        "docs/llm/policies/sdd.md": true,
        "docs/llm/policies/add.md": true
      }
    }
  ],
  "sync_rules": {
    "mandatory_files": ["AGENTS.md"],
    "marker_based_sync": {
      "AGENTS.md": {
        "preserve_section": "PROJECT CUSTOM",
        "sync_section": "STANDARD POLICY"
      }
    },
    "policy_files": [
      "docs/llm/policies/development-methodology.md",
      "docs/llm/policies/cdd.md",
      "docs/llm/policies/sdd.md",
      "docs/llm/policies/add.md"
    ],
    "cdd_scripts": [
      "scripts/docs-generate.sh",
      "scripts/docs-translate.sh"
    ]
  }
}
```

## 🚀 다음 단계

1. **my-girok 등록**: projects.json에 my-girok 추가
2. **테스트 동기화**: `./scripts/sync-standards.sh --dry-run`
3. **실제 동기화**: `./scripts/sync-standards.sh`
4. **문서 생성 테스트**: my-girok에서 CDD scripts 실행
5. **CI/CD 설정**: GitHub Actions로 자동화

---

**프로젝트 위치**: `/home/beegy/workspace/labs/llm-dev-protocol`

**모든 프로젝트에 CDD/SDD/ADD 표준을 강제하고, LLM provider를 유연하게 선택하며, 각 Agent가 자신에 최적화된 문서를 자동 생성하는 시스템이 완성되었습니다!**
