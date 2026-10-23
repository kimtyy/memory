# 💻 코다리 — P2P 음원 업로드 시스템의 API, DB 스키마, S3 연동 로직에 대한 최종 코드/설계 문서를 완성하고, 이 기술 스펙을 명확하게 문서화하여 다음 단계(수익화 전략)를 위한 완벽한 기반을 제공하세요.

**[Developer 에이전트 실행]**

CEO의 지시에 따라, P2P 음원 업로드 시스템에 대한 최종 기술 스펙 문서를 완성하고 다음 단계(수익화 전략)를 위한 기반을 제공하겠습니다.

현재까지의 메모리 기록(특히 `sessions/2026-09-09T08-07/developer.md`, `sessions/2026-09-05T05-43/developer.md`, `sessions/2026-10-10T04-50/developer.md` 등)을 바탕으로, MVP 기능, 기술 스택, 데이터 구조, 그리고 실행 로드맵을 통합하여 최종 기술 명세를 작성하겠습니다.

---

# 🎵 P2P 음원 업로드 시스템: 최종 기술 명세서 (Technical Specification)

**문서 버전:** 1.0
**작성일:** 2026-10-23
**목표:** P2P 음원 업로드 시스템의 API, 데이터베이스 스키마, S3 연동 로직에 대한 최종 설계 및 구현 기반 제공.

## 1. 시스템 개요 및 목표

본 시스템은 사용자들이 자신의 음원을 안전하고 효율적으로 업로드하고 공유할 수 있는 P2P(Peer-to-Peer) 기반의 음원 관리 플랫폼을 구축하는 것을 목표로 합니다. 핵심은 **보안성, 확장성, 그리고 수익화 연동 가능성**을 확보하는 것입니다.

## 2. 기술 스택 선정 (Technology Stack)

개발 난이도, 확장성, 그리고 초기 MVP 구현 속도를 고려하여 다음과 같은 스택을 제안하며, 이는 이전 단계의 기술 검토 결과에 기반합니다.

| 영역 | 선정 기술 | 선정 이유 |
| :--- | :--- | :--- |
| **Backend (API)** | Python (FastAPI) | 빠른 개발 속도, 비동기 처리 능력, 데이터 처리 라이브러리 연동 용이성. |
| **Database (DB)** | PostgreSQL | 관계형 데이터의 안정성 및 복잡한 관계(사용자, 파일, 트랙 정보) 관리에 최적. |
| **File Storage** | Amazon S3 | 대용량 음원 파일의 안전한 저장, 높은 내구성 및 확장성 확보. |
| **Deployment** | Docker / AWS (EC2/S3) | 환경 일관성 유지 및 클라우드 기반의 확장성 확보. |

## 3. 데이터베이스 스키마 설계 (DB Schema Design)

수익화에 직접적으로 기여하는 핵심 데이터 필드(사용자, 음원, 트랙 메타데이터)에 초점을 맞춘 스키마 초안입니다.

### A. `Users` 테이블 (사용자 정보)
*   `user_id` (PK, UUID)
*   `username` (String, Unique)
*   `email` (String, Unique)
*   `password_hash` (String)
*   `role` (Enum: 'User', 'Creator', 'Admin')
*   `created_at` (Timestamp)
*   `status` (Enum: 'Active', 'Suspended')

### B. `Music_Files` 테이블 (업로드된 음원 파일 정보)
*   `file_id` (PK, UUID)
*   `user_id` (FK to Users.user_id)
*   `s3_bucket_name` (String, 실제 S3 경로 참조)
*   `filename` (String)
*   `file_size_bytes` (BigInt)
*   `mime_type` (String)
*   `upload_date` (Timestamp)
*   `status` (Enum: 'Pending', 'Processing', 'Approved', 'Rejected')
*   `owner_id` (FK to Users.user_id)

### C. `Tracks` 테이블 (음원 세부 정보)
*   `track_id` (PK, UUID)
*   `file_id` (FK to Music_Files.file_id)
*   `title` (String)
*   `artist_name` (String)
*   `genre` (String, 선택 목록)
*   `duration_seconds` (Integer)
*   `upload_date` (Timestamp)

### D. `Transactions` 테이블 (수익화 관련 - 향후 확장)
*   `transaction_id` (PK, UUID)
*   `file_id` (FK to Music_Files.file_id)
*   `amount` (Decimal)
*   `type` (Enum: 'Sale', 'Payout')
*   `status` (Enum: 'Pending', 'Completed', 'Failed')
*   `transaction_date` (Timestamp)

## 4. API 엔드포인트 설계 (API Endpoints Design)

핵심 기능에 대한 RESTful API 엔드포인트 초안입니다.

| 기능 | HTTP Method | Endpoint | 설명 | 접근 권한 |
| :--- | :--- | :--- | :--- | :--- |
| **사용자 인증** | POST | `/api/auth/register` | 신규 사용자 등록 | Public |
| | POST | `/api/auth/login` | 사용자 로그인 및 토큰 발급 | Public |
| **음원 업로드** | POST | `/api/music/upload` | S3에 파일 업로드 및 DB 기록 시작 | Authenticated |
| **음원 조회** | GET | `/api/music/{file_id}` | 특정 음원 파일 상세 정보 조회 | Authenticated |
| **업로드 상태 조회** | GET | `/api/music/status/{file_id}` | 파일 처리 상태 조회 (S3 연동 상태 포함) | Authenticated |
| **트랙 관리** | POST | `/api/tracks/create` | 음원 파일에 대한 트랙 메타데이터 생성 | Authenticated |
| **수익/결제** | POST | `/api/transactions/record` | 업로드된 음원에 대한 거래 기록 및 수익 정산 요청 | Creator/Admin |

## 5. S3 연동 로직 (S3 Integration Logic)

S3 연동은 파일의 무결성과 보안을 위해 **업로드 시점**과 **파일 관리 시점**으로 분리하여 처리합니다.

### A. 업로드 흐름 (Upload Flow)
1.  **Client $\rightarrow$ Backend (API Call):** 사용자가 음원 파일을 서버로 전송합니다.
2.  **Backend (File Handling):** 서버는 파일을 임시 저장소에 받고, S3에 안전하게 업로드합니다. (이때, 파일명 규칙 및 권한 설정이 필수적으로 적용됩니다.)
3.  **S3 $\rightarrow$ Backend (Confirmation):** S3 업로드가 성공하면, 서버는 업로드된 파일의 **고유한 S3 경로**를 받아옵니다.
4.  **Backend $\rightarrow$ DB (Record Creation):** 서버는 `Music_Files` 테이블에 파일의 메타데이터(S3 경로, 파일 크기, 사용자 ID 등)를 기록합니다.
5.  **Backend $\rightarrow$ Client (Response):** 시스템은 사용자에게 성공적인 업로드 확인 및 `file_id`를 반환합니다.

### B. 보안 및 접근 제어
*   **접근 권한:** S3 버킷 정책을 설정하여, 파일 자체에 대한 접근은 **DB에 기록된 `file_id`와 사용자 인증(JWT)**을 통해서만 가능하도록 제한합니다.
*   **파일 이름:** S3 업로드 시, 보안 및 관리 편의를 위해 사용자 ID 또는 파일 ID를 포함하는 예측 불가능한 이름을 사용합니다.

## 6. 기술적 제약사항 및 병목 지점 (Constraints & Bottlenecks)

| 구분 | 제약사항 (Constraints) | 잠재적 병목 지점 (Bottlenecks) |
| :--- | :--- | :--- |
| **성능** | 동시 다발적 대용량 파일 업로드 처리 | S3 API 호출 지연 및 데이터베이스 쓰기(Write) 병목 현상. |
| **보안** | 민감한 파일 데이터의 저장 및 접근 제어 | S3 권한 설정 오류 및 API 인증(JWT) 누락으로 인한 데이터 유출 위험. |
| **확장성** | 향후 트래픽 증가 대비 | 초기 DB 스키마 설계가 향후 복잡한 라이선스/결제 로직 확장 시 재설계 필요성. |

## 7. 다음 단계 제안 (Next Steps for Monetization)

이 기술 스펙을 기반으로 다음 단계인 수익화 전략을 수립하기 위해, 다음 작업을 우선적으로 진행해야 합니다.

1.  **Step 1 (기술 검증):** 정의된 DB 스키마와 API 설계에 대한 **실제 코드 구현(Step 1: 기술 스택 정의)**을 완료하고, `lint_test`를 통해 기본적인 기능 테스트를 수행합니다. (Developer 메모리 내 `sessions/2026-08-21T14-18/developer.md` 참조)
2.  **Step 2 (파일럿):** `pack_apply` 도구를 사용하여 선정된 코다리 키트(`landing-kit`, `developer` 메모리 기반)를 기반으로 핵심 기능의 **최소 실행 가능한 프로토타입(MVP)**을 구축합니다.
3.  **Step 3 (수익화 통합):** `Transactions` 테이블을 중심으로 **결제 연동(Stripe 등)** 로직을 통합하고, 업로드/판매/정산의 전체 워크플로우를 검증합니다.

**[결론]**

본 문서는 P2P 음원 시스템 구축에 필요한 **기술적 청사진**을 제공합니다. 다음 단계에서는 이 청사진을 실제 작동하는 시스템으로 전환하는 **구현 작업(Step 1)**에 집중해야 합니다.
