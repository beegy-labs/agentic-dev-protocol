# LLM Development Protocol

LLM 기반 개발 방법론(CDD, SDD, ADD) 정책과 문서 생성 스크립트를 중앙 관리하는 저장소입니다.

## 핵심 방법론

| 정책 | 목적 | 파일 |
|------|------|------|
| **CDD** | Context-Driven Development - 4티어 문서 아키텍처 | `docs/llm/policies/cdd.md` |
| **SDD** | Spec-Driven Development - WHAT→WHEN→HOW 구조 | `docs/llm/policies/sdd.md` |
| **ADD** | Agent-Driven Development - 멀티 에이전트 자율 실행 | `docs/llm/policies/add.md` |

## 저장소 구조

```
llm-dev-protocol/
├── .ai/README.md                         # CDD Tier 1 indicator
├── docs/llm/policies/                    # 정책 파일 (6개)
│   ├── cdd.md                            # Context-Driven Development
│   ├── sdd.md                            # Spec-Driven Development
│   ├── add.md                            # Agent-Driven Development
│   ├── development-methodology.md        # 핵심 철학
│   ├── development-methodology-details.md
│   └── agents-customization.md           # AGENTS.md 커스터마이징
└── scripts/docs/                         # 문서 생성 스크립트
    ├── generate.ts                       # Tier 2 → Tier 3
    ├── translate.ts                      # Tier 3 → Tier 4
    ├── utils.ts
    ├── tsconfig.json
    ├── providers/                        # LLM 프로바이더
    │   ├── ollama.ts                     # 로컬 LLM
    │   ├── gemini.ts                     # Google Gemini
    │   ├── claude.ts                     # Anthropic Claude
    │   └── openai.ts                     # OpenAI
    └── prompts/
        ├── generate.txt
        └── translate.txt
```

## 사용법

### 1. 새 프로젝트에 동기화 설정

프로젝트에 `scripts/sync-protocol.sh` 생성:

```bash
#!/bin/bash
set -e

PROTOCOL_REPO="https://github.com/beegy-labs/llm-dev-protocol.git"
TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

git clone --depth 1 --quiet "${PROTOCOL_REPO}" "${TEMP_DIR}/src"

# 정책 동기화
mkdir -p docs/llm/policies
for f in cdd.md sdd.md add.md development-methodology.md development-methodology-details.md agents-customization.md; do
  cp "${TEMP_DIR}/src/docs/llm/policies/${f}" "docs/llm/policies/${f}"
done

# 스크립트 동기화
mkdir -p scripts/docs/providers scripts/docs/prompts
cp ${TEMP_DIR}/src/scripts/docs/*.ts scripts/docs/
cp ${TEMP_DIR}/src/scripts/docs/tsconfig.json scripts/docs/
cp ${TEMP_DIR}/src/scripts/docs/providers/*.ts scripts/docs/providers/
cp ${TEMP_DIR}/src/scripts/docs/prompts/*.txt scripts/docs/prompts/

echo "✅ Sync complete"
```

`package.json`에 스크립트 추가:

```json
{
  "scripts": {
    "sync:protocol": "scripts/sync-protocol.sh"
  }
}
```

### 2. 동기화 실행

```bash
# 동기화 실행
pnpm sync:protocol
```

### 3. 문서 생성 (CDD Tier 3/4)

```bash
# Tier 2 → Tier 3 (SSOT → 인간 가독용)
pnpm docs:generate --provider ollama
pnpm docs:generate --provider gemini
pnpm docs:generate --provider claude
pnpm docs:generate --provider openai

# Tier 3 → Tier 4 (영문 → 번역)
pnpm docs:translate --locale kr --provider gemini
```

## CDD 4티어 구조

```
Tier 1: .ai/README.md          ← 진입점 (≤50줄)
Tier 2: docs/llm/**/*.md       ← SSOT (LLM 최적화)
Tier 3: docs/en/**/*.md        ← 인간 가독용 (생성)
Tier 4: docs/{locale}/**/*.md  ← 번역 (생성)
```

## SDD 3레이어 구조

```
.specs/apps/{app}/
├── roadmap.md           # L1: WHAT - 전체 방향
├── scopes/{scope}.md    # L2: WHEN - 작업 범위
└── tasks/{scope}.md     # L3: HOW - 구현 계획
```

## 동기화 정책

| 구분 | 동기화 | 이유 |
|------|--------|------|
| `docs/llm/policies/` | ✅ | 공통 정책 |
| `scripts/docs/` | ✅ | 문서 생성 스크립트 |
| `.ai/` | ❌ | 프로젝트별 커스터마이징 |
| `.specs/` | ❌ | 프로젝트별 스펙 |

## 기여

1. 이 저장소에서 정책/스크립트 수정
2. main 브랜치에 푸시
3. 각 프로젝트에서 `pnpm sync:protocol` 실행

## 라이선스

MIT
