package com.ubig.app.adoption.dao;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.ubig.app.vo.adoption.AdoptionApplicationVO;
import com.ubig.app.vo.adoption.AdoptionMainListVO;
import com.ubig.app.vo.adoption.AdoptionPageInfoVO;
import com.ubig.app.vo.adoption.AdoptionPostVO;
import com.ubig.app.vo.adoption.AnimalDetailVO;

import com.ubig.app.vo.adoption.AdoptionSearchFilterVO;

@Repository
public class AdoptionDao {

	// 동물 등록
	public int insertAnimal(SqlSessionTemplate sqlSession, AnimalDetailVO animal) {
		return sqlSession.insert("adoptionMapper.insertAnimal", animal);
	}

	// 동물 수정
	public int updateAnimal(SqlSessionTemplate sqlSession, AnimalDetailVO animal) {
		return sqlSession.update("adoptionMapper.updateAnimal", animal);
	}

	// 게시글 목록 수 조회
	public int listCount(SqlSessionTemplate sqlSession, AdoptionSearchFilterVO filter) {
		return sqlSession.selectOne("adoptionMapper.listCount", filter);
	}

	// 게시글 목록 조회
	public List<AdoptionMainListVO> selectAdoptionMainList(SqlSessionTemplate sqlSession,
			AdoptionPageInfoVO pi, AdoptionSearchFilterVO filter, RowBounds rowBounds) {
		return sqlSession.selectList("adoptionMapper.selectAdoptionMainList", filter, rowBounds);
	}

	// 게시글 등록
	public int insertBoard(SqlSessionTemplate sqlSession, AdoptionPostVO post) {
		return sqlSession.insert("adoptionMapper.insertBoard", post);
	}

	// 입양 상세 조회
	public AnimalDetailVO goAdoptionDetail(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectOne("adoptionMapper.goAdoptionDetail", anino);
	}

	// 입양 신청 등록
	public int insertApplication(SqlSessionTemplate sqlSession, AdoptionApplicationVO application) {
		return sqlSession.insert("adoptionMapper.insertApplication", application);
	}

	// 입양 상태 변경
	public int updateAdoptionStatus(SqlSessionTemplate sqlSession, int animalNo, String status) {
		Map<String, Object> map = new HashMap<>();
		map.put("animalNo", animalNo);
		map.put("status", status);
		return sqlSession.update("adoptionMapper.updateAdoptionStatus", map);
	}

	// 마감 기한 지난 동물 상태 변경
	public int updateExpiredAdoptionStatus(SqlSessionTemplate sqlSession) {
		return sqlSession.update("adoptionMapper.updateExpiredAdoptionStatus");
	}

	// 조회수 증가
	public int updateViewCount(SqlSessionTemplate sqlSession, int animalNo) {
		return sqlSession.update("adoptionMapper.updateViewCount", animalNo);
	}

	// 동물 정보 삭제
	public int deleteAnimal(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deleteanimal", anino);
	}

	// 게시글 존재 여부 확인
	public int checkpost(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectOne("adoptionMapper.checkpost", anino);
	}

	// 관리용 게시글 목록 조회
	public List<AnimalDetailVO> managepost(SqlSessionTemplate sqlSession, RowBounds rowBounds,
			Map<String, Object> map) {
		return sqlSession.selectList("adoptionMapper.allList", map, rowBounds);
	}

	// 사용자가 등록한 동물 목록 조회
	public List<AdoptionMainListVO> selectAnimalList1(SqlSessionTemplate sqlSession, String userId,
			RowBounds rowBounds, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("keyword", keyword);
		return sqlSession.selectList("adoptionMapper.selectAnimalList1", map, rowBounds);
	}

	// 사용자가 등록한 동물 수 조회
	public int myList1Count(SqlSessionTemplate sqlSession, String userId, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("keyword", keyword);
		return sqlSession.selectOne("adoptionMapper.selectAnimalList1Count", map);
	}

	// 신청한 입양 목록 조회
	public List<AdoptionApplicationVO> selectAnimalList2(SqlSessionTemplate sqlSession, String userId,
			RowBounds rowBounds) {
		return sqlSession.selectList("adoptionMapper.selectAnimalList2", userId, rowBounds);
	}

	// 신청한 입양 수 조회
	public int myList2Count(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("adoptionMapper.selectAnimalList2Count", userId);
	}

	// 게시글 삭제
	public int deletePost(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deletePost", anino);
	}

	// 관련 입양 신청 내역 삭제
	public int deleteApplicationsByAnimalNo(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deleteApplicationsByAnimalNo", anino);
	}

	// 입양 상태 변경
	public int updateAdoptionStatus(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("adoptionMapper.updateAdoptionStatus", map);
	}

	// 신청서 정보 조회
	public AdoptionApplicationVO selectApplication(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.selectOne("adoptionMapper.selectApplication", adoptionAppId);
	}

	// 신청서 삭제
	public int deleteapp(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.delete("adoptionMapper.deleteapp", adoptionAppId);
	}

	// 입양 게시글 반려 처리
	public int denyBoard(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyBoard", anino);
	}

	// 신청서 중복 여부 확인
	public int checkApplication(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectOne("adoptionMapper.checkApplication", map);
	}

	// 관리 항목 수 조회
	public int managepostCount(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectOne("adoptionMapper.managepostCount", map);
	}

	// 입양 신청 상태 수락 변경
	public int acceptAdoption(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.acceptAdoption", anino);
	}

	// 신청 정보 수락 상태 변경
	public int acceptAdoptionApp(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.acceptAdoptionApp", anino);
	}

	// 입양 신청 상태 거절 변경
	public int denyAdoption(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyAdoption", anino);
	}

	// 신청 정보 거절 상태 변경
	public int denyAdoptionApp(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyAdoptionApp", anino);
	}

	// 신청자 목록 조회
	public List<AdoptionApplicationVO> selectApplicantsByAnimalNo(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectList("adoptionMapper.selectApplicantsByAnimalNo", anino);
	}

	// 최종 입양자 확정
	public int confirmApplication(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.update("adoptionMapper.confirmApplication", adoptionAppId);
	}

	// 나머지 신청자 일괄 반려 처리
	public int rejectOtherApplications(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("adoptionMapper.rejectOtherApplications", map);
	}
}
