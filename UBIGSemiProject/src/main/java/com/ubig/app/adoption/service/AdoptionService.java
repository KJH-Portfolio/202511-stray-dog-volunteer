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

	// [동물 등록] 동물 상세 정보(AnimalDetailVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	int insertAnimal(AnimalDetailVO animal);

	// [동물 수정] 동물 상세 정보(AnimalDetailVO)를 받아 DB를 정보를 수정하고 결과를 반환하는 메서드
	int updateAnimal(AnimalDetailVO animal);

	// [게시글 목록] 검색 필터(AdoptionSearchFilterVO)를 사용하여 전체 게시글 수를 조회하고 반환하는 메서드
	int listCount(AdoptionSearchFilterVO filter);

	// [게시글 목록] 검색 필터와 페이징 정보를 사용하여 게시글 목록을 조회하고 반환하는 메서드
	List<AdoptionMainListVO> selectAdoptionMainList(AdoptionPageInfoVO pi, AdoptionSearchFilterVO filter);

	// [게시글 등록] 입양 게시글 정보(AdoptionPostVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	int insertBoard(AdoptionPostVO post);

	// [입양 상세] 동물 고유 번호(anino)를 사용하여 동물 상세 정보를 조회하고 반환하는 메서드
	AnimalDetailVO goAdoptionDetail(int anino);

	// [입양 신청] 입양 신청 정보(AdoptionApplicationVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	int insertApplication(AdoptionApplicationVO application);

	// [입양 상세] 동물 번호(animalNo)를 사용하여 조회수를 1 증가시키고 결과를 반환하는 메서드
	int updateViewCount(int animalNo);

	// [동물 삭제] 동물 번호(anino)를 사용하여 동물 정보를 삭제하고 결과를 반환하는 메서드
	int deleteAnimal(int anino);

	// [동물 삭제] 동물 번호(anino)를 사용하여 동물 정보 및 관련 데이터(게시글, 신청내역)를 일괄 삭제하고 결과를 반환하는 메서드
	int deleteAnimalFull(int anino);

	// [게시글 등록] 동물 번호(anino)를 사용하여 게시글 등록 여부를 확인하고 결과를 반환하는 메서드
	int checkpost(int anino);

	// [게시글 관리] 검색 조건과 페이징 정보를 사용하여 관리용 동물/게시글 목록을 조회하고 반환하는 메서드
	List<AnimalDetailVO> managepost(AdoptionPageInfoVO pi, Map<String, Object> map);

	// [마이페이지] 사용자 ID를 사용하여 등록한 동물 목록을 조회하고 반환하는 메서드
	List<AdoptionMainListVO> selectAnimalList1(String userId, AdoptionPageInfoVO pi, String keyword);

	// [마이페이지] 사용자 ID를 사용하여 등록한 동물 수를 조회하고 반환하는 메서드
	int myList1Count(String userId, String keyword);

	// [마이페이지] 사용자 ID를 사용하여 신청한 입양 목록을 조회하고 반환하는 메서드
	List<AdoptionApplicationVO> selectAnimalList2(String userId, AdoptionPageInfoVO pi);

	// [마이페이지] 사용자 ID를 사용하여 신청한 입양 수를 조회하고 반환하는 메서드
	int myList2Count(String userId);

	// [게시글 삭제] 동물 번호(anino)를 사용하여 게시글을 삭제하고 결과를 반환하는 메서드
	int deletePost(int anino);

	// [동물 삭제] 동물 번호(anino)를 사용하여 관련 입양 신청 내역을 전체 삭제하고 결과를 반환하는 메서드
	int deleteApplicationsByAnimalNo(int anino);

	// [입양 관리] 동물 번호와 상태 값을 사용하여 입양 상태를 변경하고 결과를 반환하는 메서드
	int updateAdoptionStatus(Map<String, Object> map);

	// [입양 신청] 신청 아이디(adoptionAppId)를 사용하여 신청서 정보를 조회하고 반환하는 메서드
	AdoptionApplicationVO selectApplication(int adoptionAppId);

	// [입양 신청] 신청 아이디(adoptionAppId)를 사용하여 신청서를 삭제하고 결과를 반환하는 메서드
	int deleteapp(int adoptionAppId);

	// [게시글 관리] 동물 번호(anino)를 사용하여 입양 게시글(동물 상태)을 반려 처리하고 결과를 반환하는 메서드
	int denyBoard(int anino);

	// [입양 신청] 동물 번호(animalNo)와 사용자 ID를 사용하여 중복 신청 여부를 확인하고 결과를 반환하는 메서드
	int checkApplication(int animalNo, String userId);

	// [게시글 관리] 검색 조건을 사용하여 전체 관리 항목 수를 조회하고 반환하는 메서드
	int managepostCount(Map<String, Object> map);

	// [입양 수락] 동물 번호(anino)를 사용하여 입양 신청 상태를 수락으로 변경하고 결과를 반환하는 메서드
	int acceptAdoption(int anino);

	// [입양 거절] 동물 번호(anino)를 사용하여 입양 신청 상태를 거절로 변경하고 결과를 반환하는 메서드
	int denyAdoption(int anino);

	// [입양 수락] 동물 번호(anino)를 사용하여 신청자의 신청 정보를 수락 상태로 변경하고 결과를 반환하는 메서드
	int acceptAdoptionApp(int anino);

	// [입양 거절] 동물 번호(anino)를 사용하여 신청자의 신청 정보를 거절 상태로 변경하고 결과를 반환하는 메서드
	int denyAdoptionApp(int anino);

	// [신청자 목록] 동물 번호(anino)를 사용하여 입양 신청자 목록을 조회하고 반환하는 메서드
	List<AdoptionApplicationVO> getApplicantsList(int anino);

	// [입양 확정] 입양 신청 번호(adoptionAppId)와 동물 번호를 사용하여 최종 입양을 확정하고 결과를 반환하는 메서드
	int confirmAdoption(int adoptionAppId, int animalNo);

	// [입양 관리] 마감 기한이 지난 동물의 상태를 '마감'으로 일괄 변경하고 결과를 반환하는 메서드
	int expireOverdueAdoptions();
}
