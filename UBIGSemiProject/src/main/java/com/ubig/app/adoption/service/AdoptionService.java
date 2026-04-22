package com.ubig.app.adoption.service;

import java.util.List;
import java.util.Map;

import com.ubig.app.vo.adoption.AdoptionApplicationVO;
import com.ubig.app.vo.adoption.AdoptionMainListVO;
import com.ubig.app.vo.adoption.AdoptionPageInfoVO;
import com.ubig.app.vo.adoption.AdoptionPostVO;
import com.ubig.app.vo.adoption.AnimalDetailVO;
import com.ubig.app.vo.adoption.AdoptionSearchFilterVO;

public interface AdoptionService {

	// 동물 등록
	int insertAnimal(AnimalDetailVO animal);

	// 동물 수정
	int updateAnimal(AnimalDetailVO animal);

	// 게시글 목록 수 조회
	int listCount(AdoptionSearchFilterVO filter);

	// 게시글 목록 조회
	List<AdoptionMainListVO> selectAdoptionMainList(AdoptionPageInfoVO pi, AdoptionSearchFilterVO filter);

	// 게시글 등록
	int insertBoard(AdoptionPostVO post);

	// 입양 상세 조회
	AnimalDetailVO goAdoptionDetail(int anino);

	// 입양 신청 등록
	int insertApplication(AdoptionApplicationVO application);

	// 조회수 증가
	int updateViewCount(int animalNo);

	// 동물 정보 삭제
	int deleteAnimal(int anino);

	// 동물 정보 및 관련 데이터 일괄 삭제
	int deleteAnimalFull(int anino);

	// 게시글 등록 여부 확인
	int checkpost(int anino);

	// 관리용 게시글 목록 조회
	List<AnimalDetailVO> managepost(AdoptionPageInfoVO pi, Map<String, Object> map);

	// 등록한 동물 목록 조회
	List<AdoptionMainListVO> selectAnimalList1(String userId, AdoptionPageInfoVO pi, String keyword);

	// 등록한 동물 수 조회
	int myList1Count(String userId, String keyword);

	// 신청한 입양 목록 조회
	List<AdoptionApplicationVO> selectAnimalList2(String userId, AdoptionPageInfoVO pi);

	// 신청한 입양 수 조회
	int myList2Count(String userId);

	// 게시글 삭제
	int deletePost(int anino);

	// 관련 입양 신청 내역 전체 삭제
	int deleteApplicationsByAnimalNo(int anino);

	// 입양 상태 변경
	int updateAdoptionStatus(Map<String, Object> map);

	// 신청서 정보 조회
	AdoptionApplicationVO selectApplication(int adoptionAppId);

	// 신청서 삭제
	int deleteapp(int adoptionAppId);

	// 입양 게시글 반려 처리
	int denyBoard(int anino);

	// 중복 신청 여부 확인
	int checkApplication(int animalNo, String userId);

	// 전체 관리 항목 수 조회
	int managepostCount(Map<String, Object> map);

	// 입양 신청 상태 수락 변경
	int acceptAdoption(int anino);

	// 입양 신청 상태 거절 변경
	int denyAdoption(int anino);

	// 신청자 신청 정보 수락 상태 변경
	int acceptAdoptionApp(int anino);

	// 신청자 신청 정보 거절 상태 변경
	int denyAdoptionApp(int anino);

	// 입양 신청자 목록 조회
	List<AdoptionApplicationVO> getApplicantsList(int anino);

	// 최종 입양 확정
	int confirmAdoption(int adoptionAppId, int animalNo);

	// 마감 기한 지난 동물 상태 일괄 변경
	int expireOverdueAdoptions();
}
