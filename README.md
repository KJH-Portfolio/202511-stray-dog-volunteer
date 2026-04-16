# UBIG Semi Project 🐾

## 📖 프로젝트 개요
**UBIG**은 유기동물 입양, 봉사 및 펀딩을 연결하여 유기동물과 새로운 가족을 이어주는 종합 플랫폼입니다. 
동물 보호와 복지에 관심이 있는 사람들이 모여, 안전하고 체계적인 동물 입양 절차를 밟고 봉사활동 및 후원에 참여할 수 있는 커뮤니티 기능을 제공합니다.

---

## 🎯 주요 기능
- **회원 및 관리자 기능 (`Member` & `Admin`)**
  - 일반 사용자, 관리자 등급에 따른 권한 분리 (Spring Security 적용)
  - 마이페이지를 통한 입양/봉사/후원 내역 조회
  - 관리자 대시보드를 통한 사이트 전반의 컨텐츠 및 회원 관리

- **반려동물 입양 (`Adoption`)**
  - 유기동물 프로필 리스트업 및 상세 정보 확인
  - 입양 신청 및 심사/승인 프로세스

- **봉사활동 (`Volunteer`)**
  - 동물 보호소나 기관의 봉사 프로그램 모집 공고
  - 봉사 신청 및 스케줄 관리

- **후원/펀딩 (`Funding`)**
  - 유기동물 치료비나 보호소 운영 등을 위한 크라우드 펀딩
  - 펀딩 참여 결제 및 진행률 확인

- **커뮤니티 (`Community`)**
  - 입양 후기 작성 및 정보 공유
  - 반려동물 양육 팁 및 자유게시판 운영

---

## 🛠 기술 스택 (Tech Stack)

### **Backend**
- Java 11
- Spring Legacy (5.3.39)
- MyBatis
- Spring Security 5 
- Apache Tomcat 9

### **Database**
- Oracle Database XE 21c (Docker)
- DBCP2 Connection Pool

### **Frontend** *(추측)*
- JSP / JSTL
- HTML5, CSS3, JavaScript, jQuery

### **Infrastructure & Deployment**
- Docker & Docker Compose
- Maven 3

---

## 🚀 프로젝트 실행 방법 (Docker 활용)
이 프로젝트는 **Docker** 환경이 모두 세팅되어 있어 간편하게 실행할 수 있습니다.

1. **사전 준비**: 로컬 환경에 `Docker Desktop` 설치 및 실행
2. **프로젝트 클론 및 폴더 이동**
   ```bash
   git clone [레포지토리 주소]
   cd 2026-bootcamp_semi_project
   ```
3. **Docker Compose를 통한 컨테이너 빌드 및 백그라운드 실행**
   ```bash
   docker-compose up -d --build
   ```
4. **접속**
   - 브라우저에서 `http://localhost:8080` 으로 접속하여 메인 화면 확인.

---

## 📸 스크린샷 가이드 (Screenshots)
> 💡 *이곳에 직접 캡처한 화면들을 마크다운 이미지 삽입 문법(`![설명](이미지경로)`)을 이용해 추가해주세요.*

**1. 메인 화면 (Main Page)**
> (이미지를 넣어주세요)

**2. 유기동물 입양 신청 과정 (Adoption Flow)**
> (이미지를 넣어주세요)

**3. 후원 / 펀딩 상세 화면 (Funding Detail)**
> (이미지를 넣어주세요)

**4. 봉사활동 게시판 (Volunteer Board)**
> (이미지를 넣어주세요)

---

## 🗓 개발 및 업데이트 내역
- 2026-04-16: 프로젝트 도커라이징 완료 및 README 초안 작성
- *[이후 작업 내역들을 이곳에 기록해주세요]*
