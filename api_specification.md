# 📋 UBIG 세미 프로젝트 API Specification

> **유기동물 매칭 및 커뮤니티 플랫폼 인터페이스 명세**  
> 이 문서는 세미 프로젝트의 핵심 기능인 입양 신청, 봉사 활동 참여, 펀딩 및 기부 처리를 위한 주요 API 명세를 정의합니다.

---

## 📑 목차
1. [입양 시스템 (Adoption System)](#1-입양-시스템-adoption-system)
2. [봉사 및 커뮤니티 (Volunteer & Community)](#2-봉사-및-커뮤니티-volunteer--community)
3. [경제 생태계 (Funding & Donation)](#3-경제-생태계-funding--donation)

---

## 💡 API 설계 원칙 (Technical Note)
- **MVC 아키텍처 준수**: Spring Legacy의 Controller-Service-Mapper 구조를 엄격히 따르며, 뷰와 데이터의 관심사를 분리합니다.
- **방어적 데이터 처리**: 모든 요청에 대해 서버 사이드 유효성 검증(Validation)을 수행하여 클라이언트 단의 변조 시도를 차단합니다.
- **데이터 일관성**: 입양 상태 변경 및 포인트 차감 등 민감한 작업은 트랜잭션 관리를 통해 데이터 무결성을 보장합니다.

---

## 🐾 1. 입양 시스템 (Adoption System)

### 1.1 입양 신청서 제출
- **Endpoint**: `POST /adoption.insertapplication`
- **Description**: 특정 유기동물에 대한 입양 신청서를 제출합니다.

**Request Parameters:**
| Parameter | Type | Description |
|---|---|---|
| `animalNo` | Integer | 신청 대상 동물 고유 번호 |
| `userId` | String | 신청자 아이디 (세션 기반 자동 설정) |
| `adoptReason` | String | 입양 신청 사유 |

**Response**: 성공 시 상세 페이지로 리다이렉트 및 알림 메시지 출력.

### 1.2 입양 승인/반려 (관리자)
- **Endpoint**: `GET /adoption.acceptadoptionapp` (수락), `/adoption.denyadoptionapp` (반려)
- **Description**: 관리자가 특정 동물의 입양 신청 건을 최종 승인하거나 반려합니다.

---

## 🌱 2. 봉사 및 커뮤니티 (Volunteer & Community)

### 2.1 봉사 활동 신청
- **Endpoint**: `POST /volunteer.apply`
- **Description**: 특정 봉사 프로그램에 참여 신청을 합니다.

**Request Parameters:**
| Parameter | Type | Description |
|---|---|---|
| `vNo` | Integer | 봉사 프로그램 고유 번호 |
| `userId` | String | 참여자 아이디 |

---

## 💰 3. 경제 생태계 (Funding & Donation)

### 3.1 펀딩 참여 및 결제 처리
- **Endpoint**: `POST /funding.pay`
- **Description**: 유기동물 보호 프로젝트에 후원금을 결제하고 참여합니다.

**Request Body (JSON):**
```json
{
  "fNo": 201,
  "amount": 50000,
  "payMethod": "CARD"
}
```

---

## 🚀 4. Response Header Specification
- **Encoding**: `application/json; charset=UTF-8`
- **Result Handling**: 성공/실패 여부에 따라 `HttpSession`을 통한 `alertMsg` 전달 및 페이지 리다이렉션 수행.
