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

	// [동물 등록] 동물 상세 정보(AnimalDetailVO)를 사용하여 DB에 동물 정보를 등록하고 결과를 반환하는 메서드
	public int insertAnimal(SqlSessionTemplate sqlSession, AnimalDetailVO animal) {
		return sqlSession.insert("adoptionMapper.insertAnimal", animal);
	}

	// [동물 수정] 동물 상세 정보(AnimalDetailVO)를 사용하여 DB의 동물 정보를 수정하고 결과를 반환하는 메서드
	public int updateAnimal(SqlSessionTemplate sqlSession, AnimalDetailVO animal) {
		return sqlSession.update("adoptionMapper.updateAnimal", animal);
	}

	// [게시글 목록] 검색 필터(AdoptionSearchFilterVO)를 사용하여 DB에서 전체 게시글 수를 조회하고 반환하는 메서드
	public int listCount(SqlSessionTemplate sqlSession, AdoptionSearchFilterVO filter) {
		return sqlSession.selectOne("adoptionMapper.listCount", filter);
	}

	// [게시글 목록] 검색 필터와 페이징 정보를 사용하여 DB에서 게시글 목록을 조회하고 반환하는 메서드
	public List<AdoptionMainListVO> selectAdoptionMainList(SqlSessionTemplate sqlSession,
			AdoptionPageInfoVO pi, AdoptionSearchFilterVO filter, RowBounds rowBounds) {
		return sqlSession.selectList("adoptionMapper.selectAdoptionMainList", filter, rowBounds);
	}

	// [게시글 등록] 입양 게시글 정보(AdoptionPostVO)를 사용하여 DB에 게시글을 등록하고 결과를 반환하는 메서드
	public int insertBoard(SqlSessionTemplate sqlSession, AdoptionPostVO post) {
		return sqlSession.insert("adoptionMapper.insertBoard", post);
	}

	// [입양 상세] 동물 고유 번호(anino)를 사용하여 DB에서 동물 상세 정보를 조회하고 반환하는 메서드
	public AnimalDetailVO goAdoptionDetail(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectOne("adoptionMapper.goAdoptionDetail", anino);
	}

	// [입양 신청] 입양 신청 정보(AdoptionApplicationVO)를 사용하여 DB에 입양 신청서를 등록하고 결과를 반환하는 메서드
	public int insertApplication(SqlSessionTemplate sqlSession, AdoptionApplicationVO application) {
		return sqlSession.insert("adoptionMapper.insertApplication", application);
	}

	// [입양 관리] 동물 번호와 상태 값을 사용하여 DB의 입양 상태를 변경하고 결과를 반환하는 메서드
	public int updateAdoptionStatus(SqlSessionTemplate sqlSession, int animalNo, String status) {
		Map<String, Object> map = new HashMap<>();
		map.put("animalNo", animalNo);
		map.put("status", status);
		return sqlSession.update("adoptionMapper.updateAdoptionStatus", map);
	}

	// [입양 관리] 마감 기한이 지난 동물의 상태를 '마감'으로 일괄 변경하고 결과를 반환하는 메서드
	public int updateExpiredAdoptionStatus(SqlSessionTemplate sqlSession) {
		return sqlSession.update("adoptionMapper.updateExpiredAdoptionStatus");
	}

	// [입양 상세] 동물 번호(animalNo)를 사용하여 DB의 조회수를 1 증가시키고 결과를 반환하는 메서드
	public int updateViewCount(SqlSessionTemplate sqlSession, int animalNo) {
		return sqlSession.update("adoptionMapper.updateViewCount", animalNo);
	}

	// [동물 삭제] 동물 번호(anino)를 사용하여 DB에서 동물 정보를 삭제하고 결과를 반환하는 메서드
	public int deleteAnimal(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deleteanimal", anino);
	}

	// [게시글 등록] 동물 번호(anino)를 사용하여 DB에서 게시글 존재 여부를 조회하고 반환하는 메서드
	public int checkpost(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectOne("adoptionMapper.checkpost", anino);
	}

	// [게시글 관리] 검색 조건과 페이징 정보를 사용하여 DB에서 관리용 동물/게시글 목록을 조회하고 반환하는 메서드
	public List<AnimalDetailVO> managepost(SqlSessionTemplate sqlSession, RowBounds rowBounds,
			Map<String, Object> map) {
		return sqlSession.selectList("adoptionMapper.allList", map, rowBounds);
	}

	// [마이페이지] 사용자 ID를 사용하여 DB에서 사용자가 등록한 동물 목록을 조회하고 반환하는 메서드
	public List<AdoptionMainListVO> selectAnimalList1(SqlSessionTemplate sqlSession, String userId,
			RowBounds rowBounds, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("keyword", keyword);
		return sqlSession.selectList("adoptionMapper.selectAnimalList1", map, rowBounds);
	}

	// [마이페이지] 사용자 ID를 사용하여 DB에서 사용자가 등록한 동물 수를 조회하고 반환하는 메서드
	public int myList1Count(SqlSessionTemplate sqlSession, String userId, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("keyword", keyword);
		return sqlSession.selectOne("adoptionMapper.selectAnimalList1Count", map);
	}

	// [마이페이지] 사용자 ID를 사용하여 DB에서 신청한 입양 목록을 조회하고 반환하는 메서드
	public List<AdoptionApplicationVO> selectAnimalList2(SqlSessionTemplate sqlSession, String userId,
			RowBounds rowBounds) {
		return sqlSession.selectList("adoptionMapper.selectAnimalList2", userId, rowBounds);
	}

	// [마이페이지] 사용자 ID를 사용하여 DB에서 신청한 입양 수를 조회하고 반환하는 메서드
	public int myList2Count(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("adoptionMapper.selectAnimalList2Count", userId);
	}

	// [게시글 삭제] 동물 번호(anino)를 사용하여 DB에서 게시글을 삭제하고 결과를 반환하는 메서드
	public int deletePost(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deletePost", anino);
	}

	// [동물 삭제] 동물 번호(anino)를 사용하여 DB에서 관련 입양 신청 내역을 전체 삭제하고 결과를 반환하는 메서드
	public int deleteApplicationsByAnimalNo(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.delete("adoptionMapper.deleteApplicationsByAnimalNo", anino);
	}

	// [입양 관리] 동물 번호와 상태 값을 사용하여 DB의 입양 상태를 변경하고 결과를 반환하는 메서드
	public int updateAdoptionStatus(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("adoptionMapper.updateAdoptionStatus", map);
	}

	// [입양 신청] 신청 아이디(adoptionAppId)를 사용하여 DB에서 신청서 정보를 조회하고 반환하는 메서드
	public AdoptionApplicationVO selectApplication(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.selectOne("adoptionMapper.selectApplication", adoptionAppId);
	}

	// [입양 신청] 신청 아이디(adoptionAppId)를 사용하여 DB에서 신청서를 삭제하고 결과를 반환하는 메서드
	public int deleteapp(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.delete("adoptionMapper.deleteapp", adoptionAppId);
	}

	// [게시글 관리] 동물 번호(anino)를 사용하여 DB에서 입양 게시글(동물 상태)을 반려 처리하고 결과를 반환하는 메서드
	public int denyBoard(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyBoard", anino);
	}

	// [입양 신청] 동물 번호와 사용자 ID를 사용하여 DB에서 신청서 중복 여부를 확인하고 결과를 반환하는 메서드
	public int checkApplication(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectOne("adoptionMapper.checkApplication", map);
	}

	// [게시글 관리] 검색 조건을 사용하여 DB에서 전체 관리 항목 수를 조회하고 반환하는 메서드
	public int managepostCount(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectOne("adoptionMapper.managepostCount", map);
	}

	// [입양 수락] 동물 번호(anino)를 사용하여 DB의 입양 신청 상태를 수락으로 변경하고 결과를 반환하는 메서드
	public int acceptAdoption(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.acceptAdoption", anino);
	}

	// [입양 수락] 동물 번호(anino)를 사용하여 DB의 신청 정보를 수락 상태로 변경하고 결과를 반환하는 메서드
	public int acceptAdoptionApp(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.acceptAdoptionApp", anino);
	}

	// [입양 거절] 동물 번호(anino)를 사용하여 DB의 입양 신청 상태를 거절로 변경하고 결과를 반환하는 메서드
	public int denyAdoption(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyAdoption", anino);
	}

	// [입양 거절] 동물 번호(anino)를 사용하여 DB의 신청 정보를 거절 상태로 변경하고 결과를 반환하는 메서드
	public int denyAdoptionApp(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.update("adoptionMapper.denyAdoptionApp", anino);
	}

	// [신청자 목록] 동물 번호(anino)를 사용하여 DB에서 특정 동물의 신청자 목록을 조회하고 반환하는 메서드
	public List<AdoptionApplicationVO> selectApplicantsByAnimalNo(SqlSessionTemplate sqlSession, int anino) {
		return sqlSession.selectList("adoptionMapper.selectApplicantsByAnimalNo", anino);
	}

	// [입양 확정] 신청 아이디(adoptionAppId)를 사용하여 DB에서 해당 신청자를 최종 입양자로 확정하고 결과를 반환하는 메서드
	public int confirmApplication(SqlSessionTemplate sqlSession, int adoptionAppId) {
		return sqlSession.update("adoptionMapper.confirmApplication", adoptionAppId);
	}

	// [입양 확정] 동물 번호(anino)와 제외할 신청 아이디를 사용하여 DB에서 나머지 신청자들을 일괄 반려 처리하고 결과를 반환하는 메서드
	public int rejectOtherApplications(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("adoptionMapper.rejectOtherApplications", map);
	}
}
