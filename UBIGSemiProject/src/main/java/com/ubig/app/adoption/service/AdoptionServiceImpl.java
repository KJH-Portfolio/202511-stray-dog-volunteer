package com.ubig.app.adoption.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.adoption.dao.AdoptionDao;
import com.ubig.app.member.service.KickService;
import com.ubig.app.member.service.MessageService;
import com.ubig.app.vo.adoption.AdoptionApplicationVO;
import com.ubig.app.vo.adoption.AdoptionMainListVO;

import org.springframework.transaction.annotation.Transactional;
import com.ubig.app.vo.adoption.AdoptionPageInfoVO;
import com.ubig.app.vo.adoption.AdoptionPostVO;
import com.ubig.app.vo.adoption.AnimalDetailVO;
import com.ubig.app.vo.member.KickVO;
import com.ubig.app.vo.member.MessageVO;
import com.ubig.app.vo.adoption.AdoptionSearchFilterVO;

@Service
public class AdoptionServiceImpl implements AdoptionService {

	@Autowired
	AdoptionDao dao;
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private MessageService messageService;
	@Autowired
	private KickService kickService;

	// 동물 상세 정보(AnimalDetailVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	@Override
	public int insertAnimal(AnimalDetailVO animal) {
		if (animal.getDeadlineDate() != null) {
			java.time.LocalDate deadline = animal.getDeadlineDate().toLocalDate();
			if (deadline.isBefore(java.time.LocalDate.now())) {
				throw new IllegalArgumentException("마감일은 과거 날짜일 수 없습니다.");
			}
		}
		return dao.insertAnimal(sqlSession, animal);
	}

	// 동물 상세 정보(AnimalDetailVO)를 받아 DB를 정보를 수정하고 결과를 반환하는 메서드
	@Override
	public int updateAnimal(AnimalDetailVO animal) {
		if (animal.getDeadlineDate() != null) {
			java.time.LocalDate deadline = animal.getDeadlineDate().toLocalDate();
			if (deadline.isBefore(java.time.LocalDate.now())) {
				throw new IllegalArgumentException("마감일은 과거 날짜일 수 없습니다.");
			}
		}
		return dao.updateAnimal(sqlSession, animal);
	}

	// 검색 필터(AdoptionSearchFilterVO)를 사용하여 전체 게시글 수를 조회하고 반환하는 메서드
	@Override
	public int listCount(AdoptionSearchFilterVO filter) {
		return dao.listCount(sqlSession, filter);
	}

	// 검색 필터와 페이징 정보를 사용하여 게시글 목록을 조회하고 반환하는 메서드
	@Override
	public List<AdoptionMainListVO> selectAdoptionMainList(AdoptionPageInfoVO pi, AdoptionSearchFilterVO filter) {

		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;

		RowBounds rowBounds = new RowBounds(offset, limit);

		return dao.selectAdoptionMainList(sqlSession, pi, filter, rowBounds);
	}

	// 입양 게시글 정보(AdoptionPostVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	@Override
	public int insertBoard(AdoptionPostVO post) {
		int result = dao.insertBoard(sqlSession, post);

		if (result > 0) {
			// 게시글 등록(승인) 시 주인에게 알림 발송 - post객체의 userId는 동물 주인의 ID임
			sendMessage("admin", post.getUserId(), "[알림] 회원님의 입양 동물 홍보 게시글이 승인(등록)되었습니다.");
		}

		return result;
	}

	// 동물 고유 번호(anino)를 사용하여 동물 상세 정보를 조회하고 반환하는 메서드
	@Override
	public AnimalDetailVO goAdoptionDetail(int anino) {
		return dao.goAdoptionDetail(sqlSession, anino);
	}

	// 입양 신청 정보(AdoptionApplicationVO)를 받아 DB에 등록하고 결과를 반환하는 메서드
	@Override
	public int insertApplication(AdoptionApplicationVO application) {
		int result = dao.insertApplication(sqlSession, application);

		if (result > 0) {
			// 1. 신청 성공 시 해당 동물의 입양 상태를 '신청중'으로 자동 변경
			dao.updateAdoptionStatus(sqlSession, application.getAnimalNo(), "신청중");

			// 2. 동물 주인에게 알림 발송
			// 동물 정보를 조회해서 주인을 찾음
			AnimalDetailVO animal = dao.goAdoptionDetail(sqlSession, application.getAnimalNo());
			if (animal != null) {
				sendMessage("admin", animal.getUserId(),
						"[알림] '" + animal.getAnimalName() + "' 동물에게 새로운 입양 신청이 도착했습니다.");
			}
		}

		return result;
	}

	// 동물 번호(animalNo)를 사용하여 조회수를 1 증가시키고 결과를 반환하는 메서드
	@Override
	public int updateViewCount(int animalNo) {
		return dao.updateViewCount(sqlSession, animalNo);
	}

	// 동물 번호(anino)를 사용하여 동물 정보를 삭제하고 결과를 반환하는 메서드
	@Override
	public int deleteAnimal(int anino) {
		return dao.deleteAnimal(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 동물 정보 및 관련 데이터(게시글, 신청내역)를 일괄 삭제하고 결과를 반환하는 메서드
	@Override
	@Transactional
	public int deleteAnimalFull(int anino) {
		// 1. 신청내역 삭제
		dao.deleteApplicationsByAnimalNo(sqlSession, anino);

		// 2. 게시글 삭제
		dao.deletePost(sqlSession, anino);

		// 3. 동물 정보 삭제 (이 결과가 최종 성공 여부)
		return dao.deleteAnimal(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 게시글 등록 여부를 확인하고 결과를 반환하는 메서드
	@Override
	public int checkpost(int anino) {
		return dao.checkpost(sqlSession, anino);
	}

	// 검색 조건과 페이징 정보를 사용하여 관리용 동물/게시글 목록을 조회하고 반환하는 메서드
	@Override
	public List<AnimalDetailVO> managepost(AdoptionPageInfoVO pi, Map<String, Object> map) {
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		RowBounds rowBounds = new RowBounds(offset, limit);
		return dao.managepost(sqlSession, rowBounds, map);
	}

	// 사용자 ID를 사용하여 등록한 동물 목록을 조회하고 반환하는 메서드
	@Override
	public List<AdoptionMainListVO> selectAnimalList1(String userId, AdoptionPageInfoVO pi, String keyword) {
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		RowBounds rowBounds = new RowBounds(offset, limit);
		return dao.selectAnimalList1(sqlSession, userId, rowBounds, keyword);
	}

	// 사용자 ID를 사용하여 등록한 동물 수를 조회하고 반환하는 메서드
	@Override
	public int myList1Count(String userId, String keyword) {
		return dao.myList1Count(sqlSession, userId, keyword);
	}

	// 사용자 ID를 사용하여 신청한 입양 목록을 조회하고 반환하는 메서드
	@Override
	public List<AdoptionApplicationVO> selectAnimalList2(String userId, AdoptionPageInfoVO pi) {
		int limit = pi.getBoardLimit();
		int offset = (pi.getCurrentPage() - 1) * limit;
		RowBounds rowBounds = new RowBounds(offset, limit);
		return dao.selectAnimalList2(sqlSession, userId, rowBounds);
	}

	// 사용자 ID를 사용하여 신청한 입양 수를 조회하고 반환하는 메서드
	@Override
	public int myList2Count(String userId) {
		return dao.myList2Count(sqlSession, userId);
	}

	// 동물 번호(anino)를 사용하여 게시글을 삭제하고 결과를 반환하는 메서드
	@Override
	public int deletePost(int anino) {
		return dao.deletePost(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 관련 입양 신청 내역을 전체 삭제하고 결과를 반환하는 메서드
	@Override
	public int deleteApplicationsByAnimalNo(int anino) {
		return dao.deleteApplicationsByAnimalNo(sqlSession, anino);
	}

	// 동물 번호와 상태 값을 사용하여 입양 상태를 변경하고 결과를 반환하는 메서드
	@Override
	public int updateAdoptionStatus(Map<String, Object> map) {
		return dao.updateAdoptionStatus(sqlSession, map);
	}

	// 신청 아이디(adoptionAppId)를 사용하여 신청서 정보를 조회하고 반환하는 메서드
	@Override
	public AdoptionApplicationVO selectApplication(int adoptionAppId) {
		return dao.selectApplication(sqlSession, adoptionAppId);
	}

	// 신청 아이디(adoptionAppId)를 사용하여 신청서를 삭제하고 결과를 반환하는 메서드
	@Override
	public int deleteapp(int adoptionAppId) {
		return dao.deleteapp(sqlSession, adoptionAppId);
	}

	// 동물 번호(anino)를 사용하여 입양 게시글(동물 상태)을 반려 처리하고 결과를 반환하는 메서드
	@Override
	public int denyBoard(int anino) {
		int result = dao.denyBoard(sqlSession, anino);

		if (result > 0) {
			// 반려 시 동물 주인을 찾아서 알림 발송
			AnimalDetailVO animal = dao.goAdoptionDetail(sqlSession, anino);
			if (animal != null) {
				sendMessage("admin", animal.getUserId(),
						"[알림] 신청하신 '" + animal.getAnimalName() + "' 동물의 입양 홍보 등록이 반려되었습니다.");
			}
		}

		return result;
	}

	// 동물 번호(animalNo)와 사용자 ID를 사용하여 중복 신청 여부를 확인하고 결과를 반환하는 메서드
	@Override
	public int checkApplication(int animalNo, String userId) {
		Map<String, Object> map = new HashMap<>();
		map.put("animalNo", animalNo);
		map.put("userId", userId);
		return dao.checkApplication(sqlSession, map);
	}

	// 검색 조건을 사용하여 전체 관리 항목 수를 조회하고 반환하는 메서드
	@Override
	public int managepostCount(Map<String, Object> map) {
		return dao.managepostCount(sqlSession, map);
	}

	// 동물 번호(anino)를 사용하여 입양 신청 상태를 수락으로 변경하고 결과를 반환하는 메서드
	@Override
	public int acceptAdoption(int anino) {
		return dao.acceptAdoption(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 신청자의 신청 정보를 수락 상태로 변경하고 결과를 반환하는 메서드
	@Override
	public int acceptAdoptionApp(int anino) {
		return dao.acceptAdoptionApp(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 입양 신청 상태를 거절로 변경하고 결과를 반환하는 메서드
	@Override
	public int denyAdoption(int anino) {
		return dao.denyAdoption(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 신청자의 신청 정보를 거절 상태로 변경하고 결과를 반환하는 메서드
	@Override
	public int denyAdoptionApp(int anino) {
		return dao.denyAdoptionApp(sqlSession, anino);
	}

	// 동물 번호(anino)를 사용하여 입양 신청자 목록을 조회하고 반환하는 메서드
	@Override
	public List<AdoptionApplicationVO> getApplicantsList(int anino) {
		return dao.selectApplicantsByAnimalNo(sqlSession, anino);
	}

	// 입양 신청 번호(adoptionAppId)와 동물 번호를 사용하여 최종 입양을 확정하고 결과를 반환하는 메서드
	@Override
	@Transactional
	public int confirmAdoption(int adoptionAppId, int animalNo) {

		// 0. 알림 발송을 위해 신청자 목록 및 동물 정보 미리 조회
		List<AdoptionApplicationVO> applicants = dao.selectApplicantsByAnimalNo(sqlSession, animalNo);
		AnimalDetailVO animal = dao.goAdoptionDetail(sqlSession, animalNo);
		String animalName = (animal != null) ? animal.getAnimalName() : "신청하신 동물";

		// 1. 해당 신청자 '입양완료(2)' 처리
		int result1 = dao.confirmApplication(sqlSession, adoptionAppId);

		// 2. 나머지 신청자 '반려(3)' 처리
		Map<String, Object> map = new HashMap<>();
		map.put("animalNo", animalNo);
		map.put("adoptionAppId", adoptionAppId);
		dao.rejectOtherApplications(sqlSession, map);

		// 3. 동물 상태 '입양완료' 처리
		int result2 = dao.acceptAdoption(sqlSession, animalNo);

		// 4. 알림 발송 (확정자 및 반려자들에게 쪽지 발송)
		if (result1 > 0 && result2 > 0) {
			for (AdoptionApplicationVO app : applicants) {
				if (app.getAdoptionAppId() == adoptionAppId) {
					// 입양 확정자에게 알림
					sendMessage("admin", app.getUserId(),
							"[알림] 축하합니다! '" + animalName + "' 동물의 입양 신청이 확정되었습니다. 상세 절차는 동물 주인과 상의해주세요.");
				} else {
					// 반려자(탈락자)에게 알림
					if (app.getAdoptStatus() != 3) {
						sendMessage("admin", app.getUserId(),
								"[알림] 죄송합니다. 신청하신 '" + animalName + "' 동물은 다른 분께 입양이 확정되었습니다.");
					}
				}
			}
		}

		return (result1 > 0 && result2 > 0) ? 1 : 0;
	}

	// 마감 기한이 지난 동물의 상태를 '마감'으로 일괄 변경하고 결과를 반환하는 메서드
	@Override
	public int expireOverdueAdoptions() {
		return dao.updateExpiredAdoptionStatus(sqlSession);
	}

	// 메시지 보내기 기능(서비스로만 존재함)
	// MessageService와 KickService를 autowired로 필드에 넣어둠
	// adoptionService에서 사용할 수 있게 독자적인 메서드로 정의
	private void sendMessage(String senderId, String receiverId, String content) {

		// 차단여부부터 체크하기(기존 로직 그대로 가져옴)
		int isKicked = kickService.isKicked(KickVO.builder()
				.kicker(receiverId)
				.kickedUser(senderId)
				.build());

		String status = (isKicked > 0) ? "K" : "N"; // 차단됨(K) 또는 안 읽음(N)

		// 메시지 객체 생성
		MessageVO message = MessageVO.builder()
				.messageSendUserId(senderId)
				.messageReceiveUserId(receiverId)
				.messageContent(content)
				.messageIsCheck(status)
				.build();

		// 전송
		messageService.insertMessage(message);
	}

}
