# SDD (Spec-Driven Development) Standard - Clarification

> **Date**: 2026-01-23
> **Purpose**: SDD 표준 명확화 및 구조 검증

---

## SDD 3-Layer 정의 (WHAT → WHEN → HOW)

### Layer 1: roadmap.md (WHAT to build)

**목적**: 전체 피처 로드맵과 방향성 정의

**역할**:
- **전체 기능 목록**: 앞으로 만들 모든 기능
- **우선순위**: P0 (필수), P1 (중요), P2 (개선)
- **의존성**: 기능 간 선후 관계
- **상태 추적**: Pending → Planning → Spec Complete → In Progress → Done

**내용 예시**:
```markdown
# Web-Admin Roadmap

| Scope | Priority | Feature      | Status          |
|-------|----------|--------------|-----------------|
| 1     | P0       | Email Service| ✅ Spec Complete|
| 2     | P0       | Login        | 📋 Planning     |
| 3     | P0       | Roles        | Pending         |
```

**작성 방식**:
- **Human**: 전체 방향 설계 및 우선순위 결정
- **LLM**: Human의 지시를 roadmap.md로 문서화

---

### Layer 2: scopes/{scope}.md (WHEN to build)

**목적**: Roadmap에서 이번에 작업할 범위 추출

**역할**:
- **작업 범위 정의**: Roadmap의 어떤 항목들을 이번 기간에 할 것인가
- **기간 설정**: 2026-01 ~ 2026-02, 또는 2026-Q1
- **목표 명확화**: 이번 Scope의 완료 조건

**내용 예시**:
```markdown
# Scope: 2026-Scope1 (Mail & Notification Services)

## Period
2026-01 ~ 2026-02

## Items from Roadmap
- Email Service (Priority P0)
- Notification Service (Priority P0)

## Target
Build foundational email and notification infrastructure.
```

**작성 방식**:
- **Human**: "Scope 1은 Email Service와 Notification Service를 포함한다"
- **LLM**: Human의 정의를 scopes/2026-scope1.md로 문서화

---

### Layer 3: tasks/{scope}.md (HOW to build)

**목적**: Scope를 실행 가능한 작업 단위로 분해

**역할**:
- **작업 분해**: Scope의 각 기능을 Step 단위로 나눔
- **실행 순서**: Parallel (동시 작업 가능) vs Sequential (순차 필수)
- **의존성**: Step A가 완료되어야 Step B 시작 가능
- **CDD 참조**: 각 작업이 참조해야 할 .ai/ 또는 docs/llm/ 문서

**내용 예시**:
```markdown
# Tasks: 2026-Scope1

## CDD References
- `.ai/rules.md`: Core rules
- `docs/llm/guides/grpc.md`: gRPC patterns

## Phase 1 (Parallel) ✅ Can run simultaneously
- [ ] Step 1: Define mail.proto
- [ ] Step 2: Create mail-service skeleton

## Phase 2 (Sequential) ⏳ Must complete Phase 1 first
- [ ] Step 3: Implement gRPC handlers (depends on Step 1)
- [ ] Step 4: Add database layer (depends on Step 3)
```

**작성 방식**:
- **LLM**: Scope를 분석하고 CDD를 참조하여 작업 생성
- **Human**: 생성된 작업 검토 및 승인 (필요시 수정)

---

## 구조 표준 (Monorepo vs Single App)

### Case 1: Single Application

```
project/
└── .specs/
    ├── README.md
    ├── roadmap.md          # 전체 로드맵
    ├── scopes/
    │   ├── 2026-Q1.md
    │   └── 2026-Q2.md
    ├── tasks/
    │   ├── 2026-Q1.md
    │   └── 2026-Q2.md
    └── history/
```

**적용 대상**: 단일 애플리케이션 프로젝트

---

### Case 2: Monorepo (Multiple Apps/Services)

```
project/
└── .specs/
    ├── README.md
    ├── apps/
    │   └── web-admin/          # App별로 분리
    │       ├── roadmap.md      # web-admin의 로드맵
    │       ├── scopes/
    │       │   └── 2026-scope1.md
    │       ├── tasks/
    │       │   └── 2026-scope1.md
    │       └── history/
    │
    └── services/
        └── auth-service/       # Service별로 분리
            ├── roadmap.md      # auth-service의 로드맵
            ├── scopes/
            └── tasks/
```

**적용 대상**: Monorepo (apps/, services/, packages/ 구조)

**이유**:
- 각 App/Service는 독립적인 개발 로드맵이 필요
- 여러 팀이 동시에 작업할 때 Git 충돌 방지
- Scope/Tasks 파일도 독립적으로 관리

---

## my-girok 구조 검증

### 실제 구조

```
my-girok/
└── .specs/
    ├── README.md                               ✅
    └── apps/
        └── web-admin/
            ├── roadmap.md                      ✅ WHAT
            ├── scopes/
            │   └── 2026-scope1.md              ✅ WHEN
            ├── tasks/
            │   └── 2026-scope1.md              ✅ HOW
            └── history/
                ├── scopes/                     ✅
                └── decisions/                  ✅
```

### 검증 결과: ✅ 표준 준수

| 항목 | 요구사항 | my-girok | 상태 |
|------|----------|----------|------|
| roadmap.md | 필수 | ✅ apps/web-admin/roadmap.md | 준수 |
| scopes/ | 필수 | ✅ apps/web-admin/scopes/ | 준수 |
| tasks/ | 필수 | ✅ apps/web-admin/tasks/ | 준수 |
| history/ | 권장 | ✅ apps/web-admin/history/ | 준수 |
| 구조 타입 | Monorepo | ✅ apps/{app}/ 구조 | 올바름 |

### 리뷰어 오해 해명

**리뷰어 지적**:
> "my-girok의 .specs 디렉토리에는 표준 SDD 정책이 요구하는 roadmap.md, scopes/, tasks/가 존재하지 않습니다."

**실제 상황**:
- ✅ roadmap.md 존재: `.specs/apps/web-admin/roadmap.md`
- ✅ scopes/ 존재: `.specs/apps/web-admin/scopes/`
- ✅ tasks/ 존재: `.specs/apps/web-admin/tasks/`

**오해 원인**:
리뷰어가 `.specs/` 루트에 바로 roadmap.md가 있어야 한다고 생각한 것으로 추정.

**실제**:
my-girok은 Monorepo이므로 `.specs/apps/{app}/roadmap.md` 구조가 **올바른 표준**입니다.

---

## roadmap.md, scopes/, tasks/ 상세 설명

### roadmap.md의 역할

**질문**: "무엇을 만들 것인가?"

**내용**:
1. **전체 기능 목록**: 앞으로 6개월~1년 동안 만들 모든 기능
2. **우선순위**: P0 (필수), P1 (중요), P2 (개선)
3. **의존성 그래프**: Feature A → Feature B → Feature C
4. **상태 추적**: 각 기능의 진행 상태

**예시**:
```markdown
# Web-Admin Roadmap

| Scope | Feature      | Status          | Dependencies |
|-------|--------------|-----------------|--------------|
| 1     | Email Service| ✅ Spec Complete| -            |
| 2     | Login        | 📋 Planning     | Email (Scope 1)|
| 3     | Roles        | Pending         | Login (Scope 2)|
```

**해석**:
- Scope 1 (Email Service)이 완료되어야
- Scope 2 (Login)를 시작할 수 있고 (비밀번호 재설정 이메일 필요)
- Scope 2가 완료되어야
- Scope 3 (Roles)를 시작할 수 있다 (역할 할당 시 로그인 필요)

---

### scopes/{scope}.md의 역할

**질문**: "언제, 어떤 범위를 작업할 것인가?"

**내용**:
1. **작업 기간**: 2026-01 ~ 2026-02, 또는 2026-Q1
2. **Roadmap에서 선택**: Roadmap의 여러 기능 중 이번에 할 것만 추출
3. **목표 정의**: 이번 Scope 완료 시 달성할 상태
4. **포함 항목**: 세부 Feature 목록과 우선순위

**예시**:
```markdown
# Scope: 2026-Scope1

## Period
2026-01 ~ 2026-02 (2개월)

## Items from Roadmap
- Scope 1: Email Service (from roadmap.md)

## Target
이메일 발송 인프라 구축 완료.
다른 서비스들이 이메일을 보낼 수 있는 상태.

## Features
- mail-service: 이메일 발송 서비스
- notification-service: 통합 알림 허브
```

**해석**:
- 2026년 1~2월 동안
- Roadmap의 Scope 1 (Email Service)만 집중
- 완료 시 플랫폼 전체가 이메일을 보낼 수 있는 인프라 완성

---

### tasks/{scope}.md의 역할

**질문**: "어떻게 만들 것인가? (구체적 작업)"

**내용**:
1. **CDD 참조**: 이 작업에 필요한 .ai/ 또는 docs/llm/ 문서 목록
2. **작업 분해**: Feature → Step 단위로 분해
3. **실행 순서**: Parallel (동시) vs Sequential (순차)
4. **의존성**: Step A 완료 → Step B 시작
5. **체크리스트**: 각 Step의 완료 여부

**예시**:
```markdown
# Tasks: 2026-Scope1

## CDD References
- `.ai/rules.md`: 핵심 규칙
- `docs/llm/guides/grpc.md`: gRPC 패턴

## Phase 1 (Parallel) - 동시 작업 가능
- [ ] Step M1: mail.proto 정의
- [ ] Step M2: mail-service skeleton 생성
- [ ] Step N1: notification.proto 정의

## Phase 2 (Sequential) - Phase 1 완료 후
- [ ] Step M3: mail-service gRPC 구현 (depends on M1)
- [ ] Step M4: Database layer 추가 (depends on M3)

## Phase 3 (Sequential) - Phase 2 완료 후
- [ ] Step M5: Kafka 통합 (depends on M4)
- [ ] Step M6: AWS SES 연동 (depends on M5)
```

**해석**:
- Phase 1: proto 정의들은 동시에 작업 가능 (서로 독립적)
- Phase 2: gRPC 구현은 proto 정의 완료 후 가능
- Phase 3: Kafka/SES 통합은 기본 구현 완료 후 가능

**CDD 참조**:
- Step M3 작업 시: `docs/llm/guides/grpc.md` 읽고 패턴 따름
- 모든 작업 시: `.ai/rules.md` 규칙 준수

---

## 작업 흐름 예시

### Step 1: Roadmap 정의 (Human → LLM)

**Human 지시**:
```
web-admin은 다음 기능이 필요해:
1. 이메일 발송 (가장 중요)
2. 로그인 (이메일 재설정 위해 이메일 필요)
3. 역할 관리
4. 관리자 계정
```

**LLM 문서화** → `roadmap.md`:
```markdown
| Scope | Feature      | Dependencies    |
|-------|--------------|-----------------|
| 1     | Email Service| -               |
| 2     | Login        | Email (Scope 1) |
| 3     | Roles        | Login (Scope 2) |
| 4     | Admin Accounts| Roles (Scope 3)|
```

---

### Step 2: Scope 정의 (Human → LLM)

**Human 지시**:
```
2026년 1~2월에는 Scope 1 (Email Service)만 집중하자.
mail-service와 notification-service를 만들어야 해.
```

**LLM 문서화** → `scopes/2026-scope1.md`:
```markdown
## Period
2026-01 ~ 2026-02

## Items from Roadmap
- Scope 1: Email Service

## Services
- mail-service: 이메일 발송
- notification-service: 통합 알림
```

---

### Step 3: Tasks 생성 (LLM → Human 승인)

**LLM 분석**:
1. CDD 읽음: `.ai/architecture.md`, `docs/llm/guides/grpc.md`
2. mail-service 구현 단계 분석:
   - Proto 정의 → Service 생성 → gRPC 구현 → DB → Kafka → SES
3. 의존성 파악: Proto 없으면 gRPC 구현 불가
4. 병렬/순차 그룹핑: Proto들은 병렬, 나머지는 순차

**LLM 생성** → `tasks/2026-scope1.md`:
```markdown
## Phase 1 (Parallel)
- [ ] M1: mail.proto 정의
- [ ] N1: notification.proto 정의

## Phase 2 (Sequential)
- [ ] M2: mail-service skeleton (depends on M1)
- [ ] M3: gRPC 구현 (depends on M2)
...
```

**Human 검토**:
- 단계가 너무 크면 더 작게 나누라고 지시
- 누락된 작업 있으면 추가 요청
- 승인 → 작업 시작

---

### Step 4: 작업 실행 (ADD - Agent Driven)

**현재 (Manual)**:
```
Human: "Claude, tasks/2026-scope1.md 보고 M1 작업 해줘"
Claude: M1 작업 수행 → mail.proto 생성
```

**미래 (Automated ADD)**:
```
orchestrator .specs/tasks/2026-scope1.md

Orchestrator:
  - Reads tasks file
  - Assigns M1 → Claude Code (Terminal 1)
  - Assigns N1 → Gemini CLI (Terminal 2)
  - Monitors progress
  - Collects results
  - Validates via consensus
```

---

## 표준 준수 체크리스트

### Monorepo 프로젝트

```yaml
Structure:
  - [ ] .specs/README.md exists
  - [ ] .specs/apps/{app}/roadmap.md exists (각 app마다)
  - [ ] .specs/apps/{app}/scopes/ exists
  - [ ] .specs/apps/{app}/tasks/ exists
  - [ ] .specs/services/{service}/roadmap.md exists (필요시)

Content:
  - [ ] roadmap.md has WHAT (features, priorities, dependencies)
  - [ ] scopes/{scope}.md has WHEN (period, items from roadmap)
  - [ ] tasks/{scope}.md has HOW (CDD refs, steps, phases)
  - [ ] Tasks reference CDD (Tier 1-2)
  - [ ] Phases marked as Parallel or Sequential
```

### Single App 프로젝트

```yaml
Structure:
  - [ ] .specs/README.md exists
  - [ ] .specs/roadmap.md exists (루트에 직접)
  - [ ] .specs/scopes/ exists
  - [ ] .specs/tasks/ exists

Content:
  - [ ] (same as Monorepo content checklist)
```

---

## 결론

### my-girok 검증 결과

| 항목 | 표준 요구사항 | my-girok 실제 | 준수 여부 |
|------|--------------|---------------|-----------|
| **구조 타입** | Monorepo → apps/{app}/ | ✅ apps/web-admin/ | ✅ 준수 |
| **roadmap.md** | WHAT 정의 | ✅ 전체 6개 Scope 정의 | ✅ 준수 |
| **scopes/** | WHEN 정의 | ✅ 2026-scope1.md | ✅ 준수 |
| **tasks/** | HOW 정의 | ✅ 2026-scope1.md (38 steps) | ✅ 준수 |
| **CDD 참조** | Tasks에서 .ai/ 참조 | ✅ rules, architecture, guides | ✅ 준수 |
| **병렬/순차** | Phase 구분 | ✅ Phase 0~5 정의 | ✅ 준수 |
| **history/** | 완료 기록 | ✅ scopes/, decisions/ | ✅ 준수 |

**결론**: my-girok은 SDD 표준을 **완벽히 준수**하고 있습니다.

---

### 리뷰어 피드백 대응

**리뷰어 지적**:
> ".specs 디렉토리에 roadmap.md, scopes/, tasks/가 존재하지 않습니다."

**대응**:
1. **구조 설명**: Monorepo는 `.specs/apps/{app}/` 구조 사용
2. **파일 확인**:
   - roadmap.md: `.specs/apps/web-admin/roadmap.md` ✅
   - scopes/: `.specs/apps/web-admin/scopes/` ✅
   - tasks/: `.specs/apps/web-admin/tasks/` ✅
3. **표준 문서 제시**: 이 문서 (SDD_STANDARD_CLARIFICATION.md)

---

## roadmap, scopes, tasks 요약표

| Layer | 파일 | 질문 | 작성자 | 내용 | 예시 |
|-------|------|------|--------|------|------|
| **L1** | `roadmap.md` | **WHAT** to build? | Human 설계 → LLM 문서화 | 전체 기능 목록, 우선순위, 의존성 | "Email → Login → Roles" |
| **L2** | `scopes/{scope}.md` | **WHEN** to build? | Human 정의 → LLM 문서화 | 작업 기간, Roadmap에서 선택 | "2026-01~02: Email Service" |
| **L3** | `tasks/{scope}.md` | **HOW** to build? | LLM 생성 → Human 승인 | 작업 분해, 순서, CDD 참조 | "Step 1: proto → Step 2: service" |

### 핵심 흐름

```
Roadmap (전체 지도)
    ↓
Scope (이번 여행지)
    ↓
Tasks (세부 일정)
    ↓
ADD (실행)
```

---

**Document Version**: 1.0
**Date**: 2026-01-23
**Purpose**: SDD 표준 명확화 및 my-girok 검증