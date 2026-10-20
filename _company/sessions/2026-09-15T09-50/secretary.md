# 📱 영숙 — MVP 핵심 기능 목록 및 기술적 구현 우선순위(WBS) 초안 작성 시작. 이 WBS를 기반으로 Developer/Engineer Agent에게 세부 작업 분배를 요청할 준비를 한다.

## 🚀 MVP 핵심 기능 목록 및 기술적 구현 우선순위(WBS) 초안

요청하신 대로 MVP(Minimum Viable Product)의 핵심 기능 목록, 기술적 구현 우선순위(WBS) 초안, 그리고 권장 기술 스택을 제안합니다. 이 초안은 Developer/Engineer Agent에게 세부 작업 분배를 요청하기 위한 기반이 될 것입니다.

---

### 1. MVP 핵심 기능 목록 (Core Features)

MVP는 '핵심 가치'를 최소한의 노력으로 제공하는 것에 중점을 둡니다. 현재 맥락(AI 에이전트 기반 시스템)을 고려할 때, 기능은 **Agent 관리/실행**과 **결과 보고/상호작용**에 집중해야 합니다.

| ID | 기능 모듈 | 상세 기능 설명 | 목표 (MVP 기준) |
| :--- | :--- | :--- | :--- |
| **F1** | **Agent Definition & Management** | 에이전트(Agent)의 정의, 역할(Goal), 목표(Goal.md), 메모리 구조를 설정하고 관리하는 기능. | 시스템의 기본 구조 확립 |
| **F2** | **Task Decomposition & WBS Generation** | 사용자가 제시한 상위 목표를 분석하여, 실행 가능한 세부 작업(Task) 목록과 그 우선순위(WBS)를 자동 생성하는 기능. | 실행 계획의 자동화 |
| **F3** | **Execution & Tracking** | 생성된 WBS에 따라 에이전트가 작업을 실행하고, 각 단계의 진행 상황을 실시간으로 추적하는 기능. | 작업의 실제 수행 및 모니터링 |
| **F4** | **Reporting & Feedback** | 실행 결과를 요약하여 CEO/사용자에게 명확하게 보고하고, 실행 과정에서 발생한 피드백을 기록하는 기능. | 투명한 결과 제공 |
| **F5** | **Memory & Context Layer** | 에이전트 간, 작업 간의 맥락(Context)과 과거의 의사결정 기록(Memory)을 안전하게 저장하고 검색하는 기능. | 지능적 의사결정 지원 |

---

### 2. 기술적 구현 우선순위 (WBS Draft)

기능의 의존성을 고려하여, 가장 핵심적인 기능(Agent의 존재와 실행)을 먼저 구현하고, 이후 지능화 및 보고 기능을 추가하는 순서로 WBS를 구성합니다.

| 우선순위 | 모듈 | 세부 작업 (Task) | 예상 기간 (개발 시) | 주요 의존성 |
| :--- | :--- | :--- | :--- | :--- |
| **P1 (Foundation)** | **F1** | Agent 정의 및 메모리 구조(Goal.md) 데이터베이스 설계 및 CRUD API 구현. | 1주 | - |
| **P2 (Core Logic)** | **F5** | Memory/Context 검색 및 저장 메커니즘(Graph RAG 연동) 구현. | 1.5주 | F1 |
| **P3 (Execution)** | **F3** | Task 분해 및 실행 엔진(Scheduler) 구현. (Agent 호출 및 상태 관리) | 2주 | F1, F5 |
| **P4 (Output)** | **F2** | WBS 자동 생성 알고리즘 개발. (Goal 기반 Task 분해 로직) | 1.5주 | F3 (실행 결과 필요) |
| **P5 (Interface)** | **F4** | 최종 보고서 생성 모듈 구현. (결과 취합 및 시각화) | 1주 | F3, F4 |
| **P6 (Polish)** | **F5** | 시스템 전체의 오류 처리 및 보안 강화, 사용자 인터페이스(UI/UX) 개선. | 지속 | P1~P5 완료 |

---

### 3. 기술 스택 제안 (Technology Stack Proposal)

AI 에이전트 시스템은 데이터 처리, 복잡한 추론, 그리고 안정적인 상태 관리가 중요하므로, Python 생태계를 중심으로 설계하는 것을 권장합니다.

| 영역 | 권장 기술 스택 | 선택 이유 및 역할 |
| :--- | :--- | :--- |
| **Backend & Logic** | **Python (FastAPI)** | AI/ML 라이브러리(LangChain, LlamaIndex 등)와의 연동이 용이하며, 에이전트 로직 구현에 가장 적합합니다. FastAPI를 통해 API를 안정적으로 제공합니다. |
| **Agent Framework** | **LangChain / LlamaIndex** | 복잡한 RAG(Retrieval-Augmented Generation) 및 에이전트 간의 연결(Tool Use, Chain)을 효과적으로 구현하여 F5(Memory)와 F3(Execution)를 지원합니다. |
| **Database (Memory)** | **PostgreSQL / Neo4j** | **PostgreSQL**은 구조화된 데이터(Agent 정의, Task 상태) 관리에 적합하며, **Neo4j**는 에이전트 간의 복잡한 관계(Context, 의존성)를 그래프 형태로 저장하여 F5의 지능적 연결(Graph RAG)을 극대화합니다. |
| **Frontend (Interface)** | **Streamlit / React** | MVP 단계에서는 **Streamlit**을 사용하여 데이터 시각화 및 빠른 프로토타입 제작을 우선시하고, 추후 확장 시 **React**를 통해 전문적인 UI/UX를 구축합니다. |
| **Deployment** | **Docker** | 모든 컴포넌트(Backend, DB)를 컨테이너화하여 환경 종속성을 제거하고 배포를 용이하게 합니다. |

---

### 다음 단계 제안

이 WBS 초안과 기술 스택 제안을 기반으로, **Developer/Engineer Agent**에게 다음과 같이 구체적인 작업 분배를 요청할 준비를 완료했습니다.

**다음 단계:**
1. **Developer/Engineer Agent**에게 위 WBS와 기술 스택을 전달하고, **P1 (Foundation)** 작업을 최우선으로 시작하도록 지시합니다.
2. **Secretary Agent**는 이 WBS를 검토하여, **P1**에 대한 기술적 타당성 검토 의견을 도출할 준비를 합니다.
