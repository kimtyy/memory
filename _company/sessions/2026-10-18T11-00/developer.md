# 💻 코다리 — MVP 기능 목록을 기반으로 각 기능 구현에 필요한 예상 개발 리소스(시간/인력)와 기술적 복잡성(Cost Factor)을 산출하여 기술적 제약 조건을 정의할 것.

💻 코다리: 작업 시작합니다.

CEO의 지시에 따라, 현재까지 정의된 MVP 기능 목록을 기반으로 각 기능 구현에 필요한 예상 개발 리소스(시간/인력)와 기술적 복잡성(Cost Factor)을 산출하여 기술적 제약 조건을 정의하겠습니다.

이 분석은 현재까지 논의된 **`chick-game-kit`, `doggie-mystic-kit`, `landing-kit`, `neon-survivor-kit`**의 핵심 기능을 통합하여 추정합니다. 실제 개발 착수 전, 이 추정치를 기반으로 리소스 배분을 최종 확정해야 합니다.

### 📊 MVP 기능별 리소스 및 복잡성 분석

| MVP 기능 그룹 | 핵심 기능 | 예상 개발 시간 (Man-Hour) | 기술 복잡성 (Cost Factor: 1-5) | 주요 기술 스택 | 기술적 제약 조건 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. 핵심 게임 엔진** | `chick-game-kit` (다마고치 스타일) | 30h | 2 | HTML/JS (Vanilla), CSS | 상태 관리 및 클라이언트 측 로직의 정확성 확보. |
| **2. AI/데이터 레이어** | `doggie-mystic-kit` (사주 명리학 연동) | 40h | 4 | Gemini API, Backend/DB | API 호출 안정성, 데이터 파싱 및 명리학 알고리즘의 정확성 검증. |
| **3. 비즈니스 프레젠테이션** | `landing-kit` (랜딩 페이지) | 25h | 2 | HTML/CSS (Static Site) | 반응형 디자인 구현, CTA 흐름의 UX 최적화. |
| **4. 인앱 결제 통합** | `doggie-mystic-kit` (PayPal 연동) | 35h | 5 | External API Integration | 보안(PCI Compliance), 결제 성공/실패 로직 처리, 구독 상태 관리. **가장 높은 리스크.** |
| **5. 네온 비주얼 게임** | `neon-survivor-kit` (메카닉 통합) | 45h | 3 | Canvas/WebGL (선택), 게임 루프 최적화 | 프레임 속도(FPS) 안정성, 물리 엔진 및 충돌 계산의 효율성. |
| **총 예상 리소스** | **(모든 기능 통합)** | **175h** | **3.8** | **Full Stack (Frontend/Backend/API)** | **API 통합 및 보안 측면에서 리
