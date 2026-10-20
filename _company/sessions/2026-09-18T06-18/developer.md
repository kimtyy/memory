# 💻 코다리 — 현빈이 제시할 가격 전략에 따른 MVP 기능의 기술적 구현 타당성 검증(2단계)을 위한 WBS를 준비합니다.

💻 코다리: 작업 시작합니다.

CEO 지시에 따라 현빈의 가격 전략에 따른 MVP 기능의 기술적 구현 타당성 검증을 위한 WBS(Work Breakdown Structure)를 준비하겠습니다. 이 WBS는 기능별로 필요한 기술 스택, 데이터 모델, API 통합 지점, 그리고 예상되는 구현 복잡도를 명확히 하여, 개발 착수 전 기술적 리스크를 최소화하는 데 중점을 둘 것입니다.

기존의 개발 메모리(`sessions/2026-09-09T08-07/developer.md` 등)를 바탕으로, MVP 기능 목록을 기술 구현 관점에서 세분화하여 WBS를 구성하겠습니다.

<create_file path="sessions/2026-09-18T05-48/mvp_technical_wbs.md"># MVP 기능 기술 구현 타당성 WBS

## 1. 데이터 모델 및 백엔드 구조 확립 (Foundation)
### 1.1. 사용자 및 구독 관리 모듈
- **목표:** 사용자 인증(Auth), 구독 상태(Subscription Status)를 관리하는 DB 스키마 및 API 엔드포인트 정의.
- **기술 검증:** PostgreSQL/MongoDB 스키마 설계, JWT 기반 인증/인가 흐름 검증.
- **핵심 산출물:** `User` 테이블, `Subscription` 테이블의 관계 정의 및 ERD 초안.

### 1.2. 콘텐츠 및 상품 데이터 파이프라인
- **목표:** 상품(Kit) 정보, 가격, 접근 권한 등의 동적 데이터 관리를 위한 파이프라인 구축.
- **기술 검증:** 데이터베이스 인덱싱 전략, 데이터 정합성(Consistency) 확보 방안 검토.

## 2. 핵심 기능 구현 (Core Features)
### 2.1. 미니 게임 구현 (chick-game-kit / neon-survivor-kit)
- **목표:** 클라이언트 측 로직(게임 메카닉)과 서버 측 상태 관리(Session/Persistence)의 분리 및 통합 검증.
- **기술 검증:** 클라이언트-서버 통신(WebSocket 또는 REST) 설계, 게임 상태의 무결성 보장 로직 검토.

### 2.2. 결제 및 외부 API 통합 (doggie-mystic-kit 연동)
- **목표:** PayPal 연동 및 AI 서비스(Gemini) 호출의 안정성 및 보안성 검증.
- **기술 검증:** Stripe/PayPal API 연동 모듈 설계, API 키 환경변수 관리(보안), Rate Limiting 전략 검토.

## 3. 사용자 경험 및 배포 (UX & Deployment)
### 3.1. 랜딩 페이지 (landing-kit) 구현
- **목표:** 6-섹션 구조(Hero, Features, Pricing, FAQ, CTA)의 반응형(Responsive) 디자인 및 데이터 바인딩 검증.
- **기술 검증:** 프론트엔드 프레임워크(React/Vue 등)의 컴포넌트 재사용성 검증, A/B 테스트를 위한 데이터 구조 설계.

### 3.2. 배포 및 모니터링
- **목표:** MVP를 최소한의 인프라(Serverless 또는 VPS)에 배포하고, 핵심 지표(KPI)를 모니터링하는 환경 구축.
- **기술 검증:** CI/CD 파이프라인(GitHub Actions) 설정 검토,
