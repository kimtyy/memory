# 📱 영숙 — 회사 목표, 각 에이전트의 개인 목표, 최근 의사결정 및 메모리를 검토하여 현재 가장 가치 있는 단일 작업 1개를 결정하고, 이를 실행하기 위한 초기 데이터 요약을 준비하라

## 🎯 CEO 지시 수행: 현재 가장 가치 있는 단일 작업 결정 및 초기 데이터 요약

제공해주신 회사 목표, 각 에이전트의 개인 목표, 최근 의사결정 및 메모리를 종합적으로 검토한 결과, 현재 시점에서 **가장 가치 있는 단일 작업**과 이를 실행하기 위한 **초기 데이터 요약 및 실행 계획**을 다음과 같이 보고드립니다.

---

### 1. 현재 가장 가치 있는 단일 작업 선정 (Single Most Valuable Task)

**선정된 작업:** **P2P 음원 업로드 시스템의 기술적 실현 가능성 검토 및 API/DB 스키마 초안 확정**

**선정 근거:**
1.  **전략적 일치성:** 현재 시스템의 핵심 목표는 P2P 음원 업로드 및 스트리밍 기능의 구현입니다. 이 기능은 서비스의 핵심 가치(Value Proposition)를 직접적으로 구현하며, 기술적 기반(API, DB, S3 연동)이 미비한 상태이므로, **기술적 기반을 확립하는 것이 모든 향후 비즈니스 목표 달성의 선행 조건**입니다.
2.  **긴급성 및 영향력:** 다른 운영/관리 작업들보다, 이 기술적 기반 작업이 지연될 경우 전체 프로젝트의 착수가 불가능해지므로 최우선 순위입니다.
3.  **에이전트 역량 분배:** 이 작업은 개발(Development)과 데이터베이스 설계(Schema Design)에 특화된 에이전트의 역량을 집중적으로 활용할 수 있어, **개발 에이전트와 설계 에이전트의 협업**이 가장 효율적입니다.

### 2. 실행 계획 및 에이전트 분배 (Execution Plan & Agent Distribution)

**최적의 에이전트 선정:**
1.  **개발 에이전트:** P2P 업로드 로직, FastAPI API 엔드포인트 설계, WebSocket/REST 스트리밍 구현에 집중.
2.  **데이터베이스/인프라 에이전트:** 파일 메타데이터 관리 및 S3 연동을 위한 PostgreSQL 스키마 및 S3 연동 API 명세 정의에 집중.

**분배 계획:**
*   **개발 에이전트:** API 명세 및 초기 코드 구조 생성 담당.
*   **데이터베이스/인프라 에이전트:** 필요한 API 명세 및 데이터베이스 스키마 초안 생성 담당.

### 3. 초기 데이터 요약 및 실행 준비 (Initial Data Summary for Execution)

본 작업의 성공적인 실행을 위해 필요한 **API 명세 및 데이터베이스 스키마 초기 구상**을 아래와 같이 준비했습니다.

#### A. 필요한 API 엔드포인트 초안 (REST/WebSocket)

| 기능 | 엔드포인트 (REST/WebSocket) | 설명 | 필요한 데이터 필드 (초기) |
| :--- | :--- | :--- | :--- |
| **음원 업로드** | `POST /upload` (REST) | S3에 파일 업로드 요청 및 메타데이터 등록 | `filename`, `uploader_id`, `s3_key`, `duration` |
| **스트리밍 요청** | `GET /stream/{id}` (WebSocket) | 특정 음원의 스트리밍 시작 요청 | `session_id`, `stream_type` |
| **메타데이터 조회** | `GET /metadata/{file_id}` (REST) | 업로드된 파일의 메타데이터 조회 | `file_id`, `filename`, `uploader_id`, `upload_date`, `duration`, `s3_url` |
| **상태 관리** | `GET /status/{file_id}` (REST) | 파일 업로드/스트리밍 상태 조회 | `file_id`, `status` (Pending, Uploading, Ready, Streaming) |

#### B. 데이터베이스 스키마 초기 구상 (PostgreSQL)

**테이블 1: `files` (음원 메타데이터 관리)**

| 필드명 | 데이터 타입 | 제약 조건 | 설명 |
| :--- | :--- | :--- | :--- |
| `file_id` | UUID | PRIMARY KEY | 파일 고유 식별자 |
| `filename` | VARCHAR(255) | NOT NULL | 원본 파일 이름 |
| `s3_key` | VARCHAR(512) | UNIQUE, NOT NULL | S3 버킷 내 파일 경로 |
| `uploader_id` | UUID | NOT NULL | 업로드 사용자 ID (에이전트 ID) |
| `duration_sec` | INTEGER | NOT NULL | 음원의 길이 (초) |
| `upload_timestamp` | TIMESTAMP WITH TIME ZONE | NOT NULL | 업로드 시각 |
| `status` | VARCHAR(50) | NOT NULL | 파일 상태 (Pending, Uploading, Ready, Error) |
| `stream_url` | TEXT | NULL | 스트리밍 관련 정보 (WebSocket 연결 정보 등) |

**테이블 2: `users` (사용자/업로더 관리)**

| 필드명 | 데이터 타입 | 제약 조건 | 설명 |
| :--- | :--- | :--- | :--- |
| `user_id` | UUID | PRIMARY KEY | 사용자 고유 식별자 |
| `username` | VARCHAR(100) | UNIQUE, NOT NULL | 사용자 닉네임 |
| `telegram_chat_id` | BIGINT | UNIQUE | 텔레그램 채팅 ID (접근 권한용) |

---

### 🚀 다음 단계 지시

**[개발 에이전트]**는 위 **A. API 명세**와 **B. DB 스키마 초안**을 바탕으로 **FastAPI 프로젝트의 초기 파일 구조 및 DB 마이그레이션 스크립트**를 작성하십시오.

**[데이터베이스/인프라 에이전트]**는 위 스키마를 기반으로 **PostgreSQL 초기 설정 파일 및 S3 연동을 위한 IAM/권한 구조의 초기 구상**을 준비하십시오.
