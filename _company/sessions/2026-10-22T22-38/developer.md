# 💻 코다리 — P2P 음원 업로드(S3 연동), 파일 메타데이터 관리, 그리고 스트리밍(WebSockets/REST)에 필요한 최소한의 API 엔드포인트 및 데이터베이스 스키마 초안을 설계하고, 실현 가능성 검토를 진행하여 결과를 준비하십시오. (참조: sessions/2026-10-22T09-29/developer.md)

**[자율 사이클 실행 결과 보고]**

**선택된 단일 작업:** P2P 음원 업로드, 메타데이터 관리, 스트리밍을 위한 최소 API 엔드포인트 및 데이터베이스 스키마 초안 설계 및 실현 가능성 검토.

**선택 이유:**
현재 시스템은 MVP 기능 정의 및 기술 스택 설계 단계에 집중되어 있습니다. CEO의 지시는 이 기술적 청사진을 구체화하여 **실행 단계로 넘어가기 위한 가장 핵심적인 기반(Blueprint)**을 제공합니다. 이 설계는 향후 개발 로드맵(WBS) 및 리소스 계획의 정확도를 결정하는 데 필수적이므로, 현재 가장 가치 있는 단일 작업으로 판단합니다.

---

## 🎵 P2P 음원 스트리밍 시스템 설계 초안

요청하신 P2P 음원 업로드, 메타데이터 관리, 스트리밍에 필요한 최소한의 API 엔드포인트, 데이터베이스 스키마 초안, 그리고 실현 가능성 검토 결과를 아래와 같이 제시합니다.

### 1. 시스템 아키텍처 개요 (Conceptual Architecture)

시스템은 크게 **업로드/관리 레이어 (REST API)**, **파일 저장 레이어 (S3)**, **실시간 스트리밍 레이어 (WebSockets/REST)**로 구성됩니다.

| 구성 요소 | 역할 | 주요 기술 스택 (제안) |
| :--- | :--- | :--- |
| **API Gateway (REST)** | 사용자 인증, 메타데이터 요청, 파일 링크 제공 | RESTful API (Node.js/Python 기반) |
| **File Storage** | 실제 음원 파일 저장 | AWS S3 (Object Storage) |
| **Metadata DB** | 파일 정보, 사용자 관계, 스트림 상태 관리 | PostgreSQL 또는 MongoDB |
| **Streaming Server** | 실시간 데이터 전송 (음원 스트리밍) | WebSocket Server + 미디어 서버 (예: HLS/DASH 또는 직접 스트리밍) |

### 2. 최소 API 엔드포인트 설계 (RESTful API)

사용자 및 파일 관리를 위한 핵심 엔드포인트는 다음과 같습니다.

| HTTP Method | Endpoint | 설명 | 요청 데이터 (Input) | 응답 데이터 (Output) |
| :--- | :--- | :--- | :--- | :--- |
| **POST** | `/api/v1/upload` | 음원 파일 업로드 및 메타데이터 등록 | `file (S3 URL)`, `metadata (title, artist, duration, owner_id)` | `{ "status": "success", "file_id": "...", "stream_url": "..." }` |
| **GET** | `/api/v1/files/{file_id}` | 특정 파일의 메타데이터 및 접근 정보 조회 | N/A | 파일 메타데이터, 접근 권한 정보 |
| **GET** | `/api/v1/streams/{stream_id}` | 특정 스트림의 실시간 스트리밍 요청 (WebSocket 연결 시작) | N/A | WebSocket 연결 핸드셰이크 |
| **GET** | `/api/v1/streams/{stream_id}/status` | 스트림 진행 상태 조회 | N/A | `{ "status": "live", "bitrate": "..." }` |
| **POST** | `/api/v1/streams/{stream_id}/control` | 스트림 제어 (예: 재생/일시정지 요청) | `{ "action": "pause" }` | `{ "status": "paused" }` |

### 3. 데이터베이스 스키마 초안 (Database Schema Draft)

**테이블 1: `MusicFiles` (음원 파일 메타데이터)**

| 필드명 | 데이터 타입 | 제약 조건 | 설명 | 비고 |
| :--- | :--- | :--- | :--- | :--- |
| `file_id` | UUID | PRIMARY KEY | 파일 고유 식별자 | |
| `s3_key` | VARCHAR | UNIQUE, NOT NULL | S3 버킷 내 파일 경로 | |
| `title` | VARCHAR(255) | NOT NULL | 곡 제목 | |
| `artist` | VARCHAR(255) | NOT NULL | 아티스트 이름 | |
| `duration_seconds`| INTEGER | NOT NULL | 곡 길이 (초) | |
| `uploader_id` | UUID | FOREIGN KEY | 업로더의 사용자 ID | 사용자 테이블 참조 |
| `status` | ENUM | NOT NULL | 파일 상태 (Pending, Uploading, Ready, Failed) | |
| `created_at` | TIMESTAMP | NOT NULL | 등록 시간 | |

**테이블 2: `Streams` (실시간 스트리밍 세션 관리)**

| 필드명 | 데이터 타입 | 제약 조건 | 설명 | 비고 |
| :--- | :--- | :--- | :--- | :--- |
| `stream_id` | UUID | PRIMARY KEY | 스트림 세션 고유 식별자 | |
| `file_id` | UUID | FOREIGN KEY | 연결된 음원 파일 ID | `MusicFiles` 참조 |
| `stream_type` | ENUM | NOT NULL | 스트리밍 방식 (WebSocket, REST) | |
| `status` | ENUM | NOT NULL | 스트림 상태 (Connecting, Live, Ended, Paused) | |
| `start_time` | TIMESTAMP | | 스트림 시작 시간 | |
| `current_position`| INTEGER | | 현재 재생 위치 (초) | |
| `connection_id` | VARCHAR | | WebSocket 연결 ID | |

### 4. 실현 가능성 검토 (Feasibility Review)

**✅ 기술적 실현 가능성: 높음 (High)**
제안된 구조는 현대적인 클라우드 기반 서비스(S3, REST, WebSocket)를 활용하므로 기술적으로 구현하는 데 큰 무리가 없습니다. 특히, S3를 파일 저장소로 분리하고 메타데이터를 DB에 저장하는 방식은 확장성과 안정성을 보장합니다.

**⚠️ 잠재적 병목 지점 (Bottlenecks):**

1.  **스트리밍 대역폭 관리:** WebSocket을 통해 대용량 오디오 데이터를 실시간으로 전송할 때, 서버의 네트워크 대역폭과 미디어 인코딩/전송 최적화(Bitrate 관리)가 가장 큰 병목이 될 수 있습니다.
2.  **동시 접속 처리:** 대규모 동시 스트리밍 요청 시, WebSocket 서버와 DB의 동시 쓰기/읽기 작업에 대한 트랜잭션 관리 및 세션 관리가 중요합니다.
3.  **S3 연동 지연:** 파일 업로드 시 S3에 파일이 완전히 저장되고, 그 정보를 DB에 기록하는 과정의 지연 시간을 최소화해야 합니다.

**🚀 권장 실행 단계 (Next Steps):**

1.  **Step 1 (Database Focus):** `MusicFiles` 및 `Streams` 테이블의 최종 스키마를 확정하고, 사용자 인증 및 권한(ACL) 모델을 추가합니다.
2.  **Step 2 (Streaming Protocol Selection):** WebSocket으로 직접 오디오 스트림을 전송할지, 아니면 S3에 호스팅된 짧은 청크(Chunk)를 REST로 요청하는 방식(HLS/DASH와 유사) 중 어떤 것을 선택할지 기술적 타당성을 검토합니다. (이 결정이 성능에 가장 큰 영향을 미칩니다.)
3.  **Step 3 (Proof of Concept):** 최소한의 파일 업로드 및 메타데이터 저장 기능에 대한 PoC(Proof of Concept)를 우선적으로 진행하여 핵심 흐름의 실현 가능성을 검증합니다.

---

**다음 지시 대기:** 위 설계 초안을 바탕으로, 다음 단계인 **Step 1 (Database Focus)** 또는 **Step 2 (Streaming Protocol Selection)** 중 어떤 항목을 우선적으로 심화하여 진행할지 지시해 주십시오.
