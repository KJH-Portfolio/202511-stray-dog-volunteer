package com.ubig.app.adoption.controller;

import java.util.List;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.ubig.app.adoption.common.AdoptionPagination;
import com.ubig.app.adoption.service.AdoptionService;
import com.ubig.app.vo.adoption.AdoptionApplicationVO;
import com.ubig.app.vo.adoption.AdoptionMainListVO;
import com.ubig.app.vo.adoption.AdoptionPageInfoVO;
import com.ubig.app.vo.adoption.AdoptionPostVO;
import com.ubig.app.vo.adoption.AdoptionSearchFilterVO;
import com.ubig.app.vo.adoption.AnimalDetailVO;
import com.ubig.app.vo.member.MemberVO;
import com.ubig.app.member.service.MessageService;

@Controller
public class AdoptionController {

	@Autowired
	AdoptionService service;

	@Autowired
	MessageService messageService;

	// [입양 상세] 동물 고유 번호(anino)를 사용하여 동물 상세 정보를 조회하고 반환하는 메서드
	@RequestMapping("/adoption.detailpage")
	public String goAdoptionDetail(int anino, Model model, HttpSession session) {

		MemberVO loginUser = (MemberVO) session.getAttribute("loginMember");

		// 1. 로그인 체크
		if (loginUser == null) {
			session.setAttribute("alertMsgAd", "로그인 후 이용 가능합니다.");
			return "redirect:/adoption.mainpage";
		}

		AnimalDetailVO ani = service.goAdoptionDetail(anino);

		// 2. 비공개(승인 대기, 게시글 없음) 동물 접근 제한
		if (ani != null && ani.getPostNo() == 0) {
			boolean isOwner = ani.getUserId().equals(loginUser.getUserId());
			boolean isAdmin = "ADMIN".equals(loginUser.getUserRole());

			if (!isOwner && !isAdmin) {
				session.setAttribute("alertMsgAd", "비공개 상태(승인 대기)인 동물입니다.");
				return "redirect:/adoption.mainpage";
			}
		}

		model.addAttribute("animal", ani);

		service.updateViewCount(anino);

		return "/adoption/adoptiondetailpage";
	}

	// [동물 등록] 동물 등록 페이로 이동하는 메서드
	@RequestMapping("/adoption.enrollpageanimal")
	public String goAdoptionInsertPage() {
		return "/adoption/adoptionenrollpageanimal";
	}

	// [입양 신청] 동물 번호(anino)를 사용하여 입양 신청 페이지로 이동하는 메서드
	@RequestMapping("/adoption.applicationpage")
	public String goAdoptionApplicationPage(int anino, HttpSession session, Model model) {

		MemberVO loginUser = (MemberVO) session.getAttribute("loginMember");

		// 1. 로그인 체크
		if (loginUser == null) {
			session.setAttribute("alertMsgAd", "로그인 후 이용 가능합니다.");
			return "redirect:/adoption.detailpage?anino=" + anino;
		}

		String userId = loginUser.getUserId();

		// 2. 동물 정보 조회
		AnimalDetailVO animal = service.goAdoptionDetail(anino);
		if (animal == null) {
			session.setAttribute("alertMsgAd", "존재하지 않는 동물입니다.");
			return "redirect:/adoption.mainpage";
		}

		// 3. 본인 동물인지 확인
		if (animal.getUserId().equals(userId)) {
			session.setAttribute("alertMsgAd", "본인이 등록한 동물에는 입양 신청을 할 수 없습니다.");
			return "redirect:/adoption.detailpage?anino=" + anino;
		}

		// 4. 마감 여부 확인
		if ("마감".equals(animal.getAdoptionStatus()) || "입양완료".equals(animal.getAdoptionStatus())) {
			session.setAttribute("alertMsgAd", "이미 입양 완료되었거나 마감된 입양건입니다.");
			return "redirect:/adoption.detailpage?anino=" + anino;
		}

		// 5. 중복 신청 확인
		int check = service.checkApplication(anino, userId);
		if (check > 0) {
			session.setAttribute("alertMsgAd", "이미 입양 신청을 하셨습니다.");
			return "redirect:/adoption.detailpage?anino=" + anino;
		}

		model.addAttribute("animal", animal); // 뷰에서 필요할 수 있으므로 전달 (선택사항)

		return "/adoption/adoptionapplication";
	}

	// [게시글 등록] 동물 번호(anino)를 사용하여 게시글 등록 페이지로 이동하는 메서드
	@RequestMapping("/adoption.enrollpagepost")
	public String goAdoptionEnrollPostPage(@RequestParam(value = "anino", required = false) Integer anino,
			Model model) {
		if (anino != null) {
			model.addAttribute("anino", anino);
		}
		return "/adoption/adoptionenrollpagepost";
	}

	// [게시글 등록] 입양 게시글 정보(AdoptionPostVO)를 받아 DB에 등록하고 결과 페이지로 이동하는 메서드
	@RequestMapping("/adoption.insert.board")
	public String insertBoard(AdoptionPostVO post, HttpSession session) {
		int result = service.insertBoard(post);
		if (result > 0) {
			session.setAttribute("alertMsgAd", "등록 성공");
		} else {
			session.setAttribute("alertMsgAd", "등록 실패");
		}
		return "redirect:/adoption.postmanage";
	}

	// [게시글 등록] 동물 번호(anino)를 사용하여 기본 제목으로 게시글을 즉시 등록하는 메서드
	@RequestMapping("/adoption.insert.board.direct")
	public String insertBoardDirect(int anino, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("loginMember");

		try {
			// 1. 동물 정보를 조회하여 실제 소유자(등록자)의 ID를 가져옴
			AnimalDetailVO animal = service.goAdoptionDetail(anino);
			System.out.println("[AdoptionController] insertBoardDirect 요청 - 동물: " + anino);

			if (animal == null) {
				session.setAttribute("alertMsgAd", "존재하지 않는 동물입니다.");
				return "redirect:/adoption.postmanage";
			}

			// 2. 이미 게시글이 등록되어 있는지 중복 체크
			int check = service.checkpost(anino);
			if (check > 0) {
				session.setAttribute("alertMsgAd", "이미 게시글이 등록된 동물입니다.");
				return "redirect:/adoption.postmanage";
			}

			// 3. 게시글 등록 진행
			AdoptionPostVO post = new AdoptionPostVO();
			post.setAnimalNo(anino);
			post.setUserId(animal.getUserId()); // 관리자가 아닌 동물 등록자의 ID로 설정
			post.setPostTitle("입양을 기다려요"); // 기본 제목 설정
			post.setViews(0);

			int result = service.insertBoard(post);

			if (result > 0) {
				session.setAttribute("alertMsgAd", "게시글이 등록되었습니다.");
			} else {
				session.setAttribute("alertMsgAd", "게시글 등록 실패");
			}
		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("alertMsgAd", "서버 오류로 인해 실패했습니다.");
		}

		return "redirect:/adoption.postmanage";
	}

	// [입양 신청] 입양 신청 정보(AdoptionApplicationVO)를 받아 DB에 등록하고 결과 페이지로 이동하는 메서드
	@RequestMapping("/adoption.insertapplication")
	public String insertapplication(AdoptionApplicationVO application, Model model, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("loginMember");
		application.setUserId(user.getUserId());
		application.setAdoptStatus(1); // 1: 신청완료 상태로 초기화

		// 0.같은 동물에 대한 신청이 있는지 확인
		int check = service.checkApplication(application.getAnimalNo(), application.getUserId());

		// 0.내가 등록한 동물을 입양 신청하고 있지 않는지 확인
		AnimalDetailVO animal = service.goAdoptionDetail(application.getAnimalNo());
		if (animal != null && animal.getUserId().equals(user.getUserId())) {
			session.setAttribute("alertMsgAd", "본인이 등록한 동물에는 입양 신청을 할 수 없습니다.");
			return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
		}

		// [추가] 마감된 동물인지 확인
		if (animal != null && ("마감".equals(animal.getAdoptionStatus()) || "입양완료".equals(animal.getAdoptionStatus()))) {
			session.setAttribute("alertMsgAd", "이미 입양 완료되었거나 마감된 입양건입니다.");
			return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
		}

		if (check > 0) {
			session.setAttribute("alertMsgAd", "이미 입양 신청을 하셨습니다.");
			return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
		}

		// 1. 신청서 저장
		int result = service.insertApplication(application);

		// 2. 신청 성공 시, 해당 동물의 상태를 '신청중'으로 업데이트
		if (result > 0) {
			Map<String, Object> map = new HashMap<>();
			map.put("animalNo", application.getAnimalNo());
			map.put("status", "신청중");
			service.updateAdoptionStatus(map);
		}

		model.addAttribute("anino", application.getAnimalNo());
		if (result > 0) {
			session.setAttribute("alertMsgAd", "입양 신청 성공");
		} else {
			session.setAttribute("alertMsgAd", "입양 신청 실패");
		}
		// 처리 후 상세 페이지로 다시 이동
		return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
	}

	// [동물 등록] 동물 상세 정보(AnimalDetailVO)와 업로드된 파일을 받아 DB에 등록하고 메인 페이지로 이동하는 메서드
	@RequestMapping("/adoption.insert.animal")
	public String insertAnimal(HttpSession session, MultipartFile uploadFile, AnimalDetailVO animal) {

		MemberVO user = (MemberVO) session.getAttribute("loginMember");
		animal.setUserId(user.getUserId());

		// A. 기존 파일 정보가 있다면 삭제 (신규 등록에서는 발생 가능성 낮음)
		if (animal.getPhotoUrl() != null) {
			String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
			File file = new File(savePath + animal.getPhotoUrl());
			if (file.exists()) {
				file.delete();
			}
		}

		// B. 신규 파일 업로드 처리
		// B. 신규 파일 업로드 처리
		if (uploadFile != null && !uploadFile.isEmpty()) {
			// 파일명 변경 및 저장
			String changeName = uploadFile(session, uploadFile);
			// VO에 변경된 파일명 설정
			animal.setPhotoUrl(changeName);

			// C. DB에 동물 정보 저장, 실패 시 파일 삭제
			String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
			try {
				int result = service.insertAnimal(animal);

				if (result > 0) {
					session.setAttribute("alertMsgAd", "동물 등록 성공!");
				} else {
					session.setAttribute("alertMsgAd", "동물 등록 실패!");
					new File(savePath + changeName).delete(); // 실패 시 파일 삭제
				}
			} catch (Exception e) {
				e.printStackTrace();
				session.setAttribute("alertMsgAd", "등록 중 오류 발생: " + e.getMessage());
				new File(savePath + changeName).delete(); // 예외 발생 시 파일 삭제
			}
		} else {
			// 파일 없이 등록 시도한 경우 (기존 로직 유지)
			try {
				int result = service.insertAnimal(animal);
				if (result > 0)
					session.setAttribute("alertMsgAd", "동물 등록 성공!");
				else
					session.setAttribute("alertMsgAd", "동물 등록 실패!");
			} catch (Exception e) {
				session.setAttribute("alertMsgAd", "등록 중 오류 발생");
			}
		}
		return "redirect:/adoption.mainpage";
	}

	// [공통] 업로드된 파일을 서버에 저장하고 변경된 파일명을 반환하는 메서드
	public String uploadFile(HttpSession session, MultipartFile uploadFile) {
		String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
		String originName = uploadFile.getOriginalFilename();
		String ext = originName.substring(originName.lastIndexOf("."));
		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int ranNum = (int) (Math.random() * 90000 + 10000);
		String changeName = currentTime + ranNum + ext;

		try {
			uploadFile.transferTo(new File(savePath + changeName));
			return changeName;
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
			return "";
		}
	}

	// [입양 메인] 검색 필터와 페이징 정보를 사용하여 입양 동물 목록을 조회하고 반환하는 메서드
	@RequestMapping("/adoption.mainpage")
	public String AdoptionList(@RequestParam(value = "page", defaultValue = "1") int currentPage,
			AdoptionSearchFilterVO filter, Model model) {

		System.out.println("Search Filter: " + filter);

		// 전체 게시글 수 조회 (필터 적용)
		int listCount = service.listCount(filter);

		int boardLimit = 9; // 한 페이지당 게시글 수
		int pageLimit = 5; // 페이지 번호 표시 수

		// 페이징 정보 생성
		AdoptionPageInfoVO pi = AdoptionPagination.getPageInfo(listCount, currentPage, boardLimit, pageLimit);

		// 페이징된 목록 조회 (필터 적용)
		List<AdoptionMainListVO> adoptionList = service.selectAdoptionMainList(pi, filter);

		model.addAttribute("pi", pi);
		model.addAttribute("adoptionList", adoptionList);
		model.addAttribute("filter", filter); // 필터 상태 유지

		return "/adoption/adoptionmainpage";
	}

	// [동물 수정] 동물 번호(anino)를 사용하여 동물 정보를 조회하고 수정 페이지로 이동하는 메서드
	@RequestMapping("/adoption.updateanimal")
	public String updateAnimal(int anino, Model model, HttpSession session) {
		AnimalDetailVO animal = service.goAdoptionDetail(anino);

		// [검증] 승인되거나 입양완료된 동물은 수정 불가
		if (animal != null) {
			if (animal.getPostNo() != 0 || "입양완료".equals(animal.getAdoptionStatus())) {
				session.setAttribute("alertMsgAd", "승인되거나 입양 완료된 동물은 수정할 수 없습니다.");
				return "redirect:/user/mypage.me";
			}
		}

		// [보안] 본인 동물인지 확인
		MemberVO loginUser = (MemberVO) session.getAttribute("loginMember");
		if (animal != null && !animal.getUserId().equals(loginUser.getUserId())
				&& !"ADMIN".equals(loginUser.getUserRole())) {
			session.setAttribute("alertMsgAd", "수정 권한이 없습니다.");
			return "redirect:/adoption.detailpage?anino=" + anino;
		}

		model.addAttribute("animal", animal);
		return "/adoption/adoptionenrollpageanimal";
	}

	// [동물 수정] 수정된 동물 정보(AnimalDetailVO)를 받아 DB를 업데이트하고 결과 페이지로 이동하는 메서드
	@RequestMapping("/adoption.update.animal.action")
	public String updateAnimalAction(HttpSession session, MultipartFile uploadFile, AnimalDetailVO animal,
			String originalPhotoUrl) {

		// [검증] 승인되거나 입양완료된 동물은 수정 불가 (DB 조회 필요)
		AnimalDetailVO dbAnimal = service.goAdoptionDetail(animal.getAnimalNo());
		if (dbAnimal != null) {
			if (dbAnimal.getPostNo() != 0 || "입양완료".equals(dbAnimal.getAdoptionStatus())) {
				session.setAttribute("alertMsgAd", "승인되거나 입양 완료된 동물은 수정할 수 없습니다.");
				return "redirect:/user/mypage.me";
			}
		}

		// [보안] 본인 동물인지 확인
		MemberVO loginUser = (MemberVO) session.getAttribute("loginMember");
		if (dbAnimal != null && !dbAnimal.getUserId().equals(loginUser.getUserId())
				&& !"ADMIN".equals(loginUser.getUserRole())) {
			session.setAttribute("alertMsgAd", "수정 권한이 없습니다.");
			return "redirect:/user/mypage.me";
		}

		// 1. 파일 업로드 로직 (새 파일이 있으면 교체)
		String changeName = null;
		if (uploadFile != null && !uploadFile.isEmpty()) {
			changeName = uploadFile(session, uploadFile);
			animal.setPhotoUrl(changeName);

			if (originalPhotoUrl != null && !originalPhotoUrl.isEmpty()) {
				String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
				File file = new File(savePath + originalPhotoUrl);
				if (file.exists()) {
					file.delete();
				}
			}
		} else {
			animal.setPhotoUrl(originalPhotoUrl);
		}

		// 2. 상태 초기화 ('대기중')
		animal.setAdoptionStatus("대기중");

		// 3. DB 업데이트
		try {
			int result = service.updateAnimal(animal);

			// 4. [중요] 관리자가 아닌 사용자가 수정했을 경우, 기존의 승인된 게시글 삭제 (재승인 필요)
			MemberVO user = (MemberVO) session.getAttribute("loginMember");
			if (user != null && !"ADMIN".equals(user.getUserRole())) {
				service.deletePost(animal.getAnimalNo());
			}

			if (result > 0) {
				session.setAttribute("alertMsgAd", "동물 정보가 성공적으로 수정되었습니다.");
			} else {
				session.setAttribute("alertMsgAd", "정보 수정 실패");
				// 실패 시 업로드된 새 파일이 있다면 삭제
				if (changeName != null) {
					String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
					new File(savePath + changeName).delete();
				}
			}
		} catch (Exception e) {
			session.setAttribute("alertMsgAd", "수정 중 오류 발생: " + e.getMessage());
			// 예외 발생 시 업로드된 새 파일이 있다면 삭제
			if (changeName != null) {
				String savePath = session.getServletContext().getRealPath("resources/download/adoption/");
				new File(savePath + changeName).delete();
			}
		}

		// MemberVO loginUser = (MemberVO) session.getAttribute("loginMember"); //
		// Duplicate removed
		if (loginUser != null && "ADMIN".equals(loginUser.getUserRole())) {
			return "redirect:/adoption.postmanage";
		} else {
			return "redirect:/user/mypage.me";
		}
	}

	// [동물 삭제] 동물 번호(anino)를 사용하여 동물 정보 및 관련 데이터를 삭제하고 결과 페이지로 이동하는 메서드
	@RequestMapping("/adoption.deleteanimal")
	public String deleteAnimal(int anino, HttpSession session, javax.servlet.http.HttpServletRequest request) {
		MemberVO user = (MemberVO) session.getAttribute("loginMember");
		String userRole = user.getUserRole();
		String userId = user.getUserId();

		// [검증] 승인되거나 입양완료된 동물은 삭제 불가 (관리자 제외하고 검증) -> [수정] 본인도 삭제 가능하도록 변경 (제한 해제)
		AnimalDetailVO animal = service.goAdoptionDetail(anino);
		/*
		 * if (animal != null && !"ADMIN".equals(userRole)) {
		 * if (animal.getPostNo() != 0 || "입양완료".equals(animal.getAdoptionStatus())) {
		 * session.setAttribute("alertMsgAd", "승인되거나 입양 완료된 동물은 삭제할 수 없습니다.");
		 * return "redirect:/user/mypage.me";
		 * }
		 * }
		 */

		// 관리자: 강제 삭제 (트랜잭션 적용)
		if ("ADMIN".equals(userRole)) {
			int result = service.deleteAnimalFull(anino);

			if (result > 0) {
				session.setAttribute("alertMsgAd", "관리자 권한으로 동물(및 관련 데이터) 삭제 성공");
			} else {
				session.setAttribute("alertMsgAd", "동물 삭제 실패");
			}
		}
		// 일반 유저: 본인 확인 (트랜잭션 적용)
		else if ("MEMBER".equals(userRole)) {
			// AnimalDetailVO animal = service.goAdoptionDetail(anino); // 위에서 이미 조회함

			if (animal != null && userId.equals(animal.getUserId())) {
				int result = service.deleteAnimalFull(anino);

				if (result > 0) {
					session.setAttribute("alertMsgAd", "동물 삭제 성공");
				} else {
					session.setAttribute("alertMsgAd", "동물 삭제 실패");
				}
			} else {
				session.setAttribute("alertMsgAd", "본인이 등록한 동물만 삭제할 수 있습니다.");
			}
		} else {
			session.setAttribute("alertMsgAd", "적절한 권한이 없습니다.");
		}

		String referer = request.getHeader("Referer");
		return "redirect:" + (referer != null ? referer : "/adoption.mainpage");

	}

	// [마이페이지] 입양 신청 번호(adoptionAppId)를 사용하여 입양 신청을 취소하고 결과 페이지로 이동하는 메서드
	@RequestMapping("adoption.deleteadoptionapp")
	public String deleteadoptionapp(HttpSession session, int adoptionAppId) {

		// 1. 동물 번호 조회를 위해 신청 정보 확인
		AdoptionApplicationVO application = service.selectApplication(adoptionAppId);

		int result = 0;
		if (application != null) {
			// [검증] 입양 완료된 상태(2)이면 취소 불가
			if (application.getAdoptStatus() == 2) {
				session.setAttribute("alertMsgAd", "입양 완료된 신청 내역은 취소할 수 없습니다.");
				return "redirect:/user/mypage.me";
			}

			int animalNo = application.getAnimalNo();

			// 2. 신청 내역 삭제
			result = service.deleteapp(adoptionAppId);

			if (result > 0) {
				// [수정] 동물 상태 및 남은 신청자 확인 후 상태 업데이트
				AnimalDetailVO animal = service.goAdoptionDetail(animalNo);

				if (animal != null && !"입양완료".equals(animal.getAdoptionStatus())) {
					// 남은 신청자 수 확인 (삭제 후 시점이므로 남은 신청자만 조회됨)
					List<AdoptionApplicationVO> remaining = service.getApplicantsList(animalNo);

					String newStatus = "신청중";
					if (remaining == null || remaining.isEmpty()) {
						newStatus = "대기중";
					}

					Map<String, Object> map = new HashMap<>();
					map.put("animalNo", animalNo);
					map.put("status", newStatus);
					service.updateAdoptionStatus(map);

					if ("대기중".equals(newStatus)) {
						session.setAttribute("alertMsgAd", "신청 취소 성공 (대기중 상태로 변경됨)");
					} else {
						session.setAttribute("alertMsgAd", "신청 취소 성공 (신청중 상태 유지)");
					}
				} else {
					session.setAttribute("alertMsgAd", "신청 취소 성공");
				}
			} else {
				session.setAttribute("alertMsgAd", "삭제 실패");
			}
		} else {
			session.setAttribute("alertMsgAd", "존재하지 않는 신청 내역입니다.");
		}

		return "redirect:/user/mypage.me";
	}

	// [게시글 관리] 검색 조건과 페이징 정보를 사용하여 관리용 동물/게시글 목록을 조회하고 반환하는 메서드
	@RequestMapping("/adoption.postmanage")
	public String postManage(Model model,
			@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(value = "animalNo", required = false) String animalNo,
			@RequestParam(value = "onlyPending", required = false) String onlyPending) {

		Map<String, Object> map = new HashMap<>();
		if (animalNo != null && !animalNo.isEmpty()) {
			map.put("animalNo", animalNo);
		}
		if ("true".equals(onlyPending)) {
			map.put("onlyPending", "true");
		}

		// 1. 전체 관리 항목 수 조회
		int listCount = service.managepostCount(map);

		// 2. 페이징 처리 (pageLimit=5, boardLimit=10)
		int pageLimit = 5;
		int boardLimit = 10;
		AdoptionPageInfoVO pi = AdoptionPagination.getPageInfo(listCount, currentPage, boardLimit, pageLimit);

		// 3. 관리용 동물 전체 리스트 조회 (페이징 적용)
		List<AnimalDetailVO> list = service.managepost(pi, map);

		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("animalNo", animalNo);
		model.addAttribute("onlyPending", onlyPending);

		return "/adoption/adoptionpostmanage";
	}

	// [마이페이지] 사용자 ID를 사용하여 등록한 동물 및 신청한 입양 목록을 조회하고 JSON으로 반환하는 메서드
	@ResponseBody
	@RequestMapping(value = "/adoption.mypage", produces = "application/json; charset=UTF-8")
	public String mypage(HttpSession session,
			@RequestBody(required = false) Map<String, String> body) { // required는 오류 완충장치

		int page1 = 1;
		int page2 = 1;

		String keyword = "";
		if (body != null) {
			if (body.get("page1") != null)
				page1 = Integer.parseInt(body.get("page1"));
			if (body.get("page2") != null)
				page2 = Integer.parseInt(body.get("page2"));
			if (body.get("keyword") != null) // keyword 추가
				keyword = body.get("keyword");
		}

		MemberVO user = (MemberVO) session.getAttribute("loginMember");

		// 세션 만료 시 처리
		if (user == null) {
			Map<String, Object> errorMap = new HashMap<>();
			errorMap.put("error", "not_login");
			errorMap.put("message", "로그인이 필요한 서비스입니다.");
			return new Gson().toJson(errorMap);
		}

		int boardLimit = 5; // 한 페이지당 게시글 수
		int pageLimit = 5; // 페이지 번호 표시 수

		// 1. 유저가 등록한 동물 내역 (페이징 1) + 검색어 전달
		int listCount1 = service.myList1Count(user.getUserId(), keyword);
		AdoptionPageInfoVO pi1 = AdoptionPagination.getPageInfo(listCount1, page1, boardLimit, pageLimit);
		List<AdoptionMainListVO> list1 = service.selectAnimalList1(user.getUserId(), pi1, keyword);

		// 2. 유저가 신청한 입양 내역 (페이징 2)
		int listCount2 = service.myList2Count(user.getUserId());
		AdoptionPageInfoVO pi2 = AdoptionPagination.getPageInfo(listCount2, page2, boardLimit, pageLimit);
		List<AdoptionApplicationVO> list2 = service.selectAnimalList2(user.getUserId(), pi2);

		Map<String, Object> listAll = new HashMap<>();
		listAll.put("myAdoptions", list1);
		listAll.put("pi1", pi1);
		listAll.put("myApplications", list2);
		listAll.put("pi2", pi2);

		return new Gson().toJson(listAll);
	}

	// [게시글 관리] 동물 번호(anino)를 사용하여 입양 게시글(동물 상태)을 반려 처리하는 메서드
	@RequestMapping("/adoption.deny.board.direct")
	public String denyBoard(int anino, HttpSession session) {
		int result = service.denyBoard(anino);
		return "redirect:/adoption.postmanage";
	}

	// 쪽지를 보내는 메서드
	// "**되었습니다." 하는 메시지와 USERID를 파라미터로 받아서 유저에게 쪽지 보내주기

	// [입양 수락] 동물 번호(anino)를 사용하여 입양 신청을 수락하고 결과 페이지로 이동하는 메서드
	@GetMapping("/adoption.acceptadoptionapp")
	public String acceptAdoption(int anino, HttpSession session) {

		MemberVO user = (MemberVO) session.getAttribute("loginMember");
		AnimalDetailVO animal = service.goAdoptionDetail(anino);

		// 본인 동물인지 확인
		if (animal == null || !animal.getUserId().equals(user.getUserId())) {
			session.setAttribute("alertMsgAd", "권한이 없습니다.");
			return "redirect:/user/mypage.me";
		}

		int result1 = service.acceptAdoption(anino);

		// 신청자의 신청 정보도 변경해주기
		int result2 = service.acceptAdoptionApp(anino);

		if (result1 > 0 && result2 > 0) {
			session.setAttribute("alertMsgAd", "입양 수락하였습니다");
		} else {
			session.setAttribute("alertMsgAd", "입양 수락 실패");
		}

		return "redirect:/user/mypage.me";
	}

	// [입양 거절] 동물 번호(anino)를 사용하여 입양 신청을 거절하고 결과 페이지로 이동하는 메서드
	@GetMapping("/adoption.denyadoptionapp")
	public String denyAdoption(int anino, HttpSession session) {

		MemberVO user = (MemberVO) session.getAttribute("loginMember");
		AnimalDetailVO animal = service.goAdoptionDetail(anino);

		// 본인 동물인지 확인
		if (animal == null || !animal.getUserId().equals(user.getUserId())) {
			session.setAttribute("alertMsgAd", "권한이 없습니다.");
			return "redirect:/user/mypage.me";
		}

		int result1 = service.denyAdoption(anino);

		// 신청자의 신청 정보도 변경해주기
		int result2 = service.denyAdoptionApp(anino);

		if (result1 > 0 && result2 > 0) {
			session.setAttribute("alertMsgAd", "입양 거절하였습니다");
		} else {
			session.setAttribute("alertMsgAd", "입양 거절 실패");
		}

		return "redirect:/user/mypage.me";
	}

	// [신청자 목록] 동물 번호(anino)를 사용하여 해당 동물의 입양 신청자 목록을 조회하고 JSON으로 반환하는 메서드
	@ResponseBody
	@RequestMapping(value = "/adoption.applicants", produces = "application/json; charset=UTF-8")
	public String getApplicants(int anino, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("loginMember");

		// 1. 로그인 체크
		if (user == null) {
			return new Gson().toJson("not_login");
		}

		try {
			AnimalDetailVO animal = service.goAdoptionDetail(anino);

			// 2. 동물 존재 여부 체크
			if (animal == null) {
				return new Gson().toJson("animal_not_found");
			}

			// 3. 권한 체크 (본인 동물인지)
			if (!animal.getUserId().equals(user.getUserId())) {
				return new Gson().toJson("permission_denied");
			}

			List<AdoptionApplicationVO> list = service.getApplicantsList(anino);
			return new Gson().toJson(list);

		} catch (Exception e) {
			e.printStackTrace();
			// 서버 오류 발생 시
			return new Gson().toJson("error_msg:" + e.getMessage());
		}
	}

	// [입양 확정] 입양 신청 번호(adoptionAppId)와 동물 번호(anino)를 사용하여 최종 입양을 확정하고 결과를 JSON으로
	// 반환하는 메서드
	@ResponseBody
	@RequestMapping(value = "/adoption.confirm", produces = "application/json; charset=UTF-8")
	public String confirmAdoption(int adoptionAppId, int anino, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("loginMember");

		// 1. 로그인 체크
		if (user == null) {
			return new Gson().toJson("not_login");
		}

		try {
			AnimalDetailVO animal = service.goAdoptionDetail(anino);

			// 2. 동물 존재 여부 체크
			if (animal == null) {
				return new Gson().toJson("animal_not_found");
			}

			// 3. 권한 체크
			if (!animal.getUserId().equals(user.getUserId())) {
				return new Gson().toJson("permission_denied");
			}

			int result = service.confirmAdoption(adoptionAppId, anino);

			return new Gson().toJson(result > 0 ? "success" : "fail");

		} catch (Exception e) {
			e.printStackTrace();
			return new Gson().toJson("error_msg:" + e.getMessage());
		}
	}

}
