# Bangcom V1

🔗 배포 링크 : [https://www.bangcom.store](https://www.bangcom.store)

<br>

### 목차

1. [프로젝트 소개](#프로젝트-소개)
   - 사용 기술
   - 구현 기능
2. [미리보기](#미리보기)
3. [개발 과정](#개발-과정)
   - ERD
   - 개발-배포 프로세스
4. [구현 설명](#구현-설명)
   - 회원 관련
   - 카테고리 게시판 구현
   - 댓글/대댓글 CRUD
   - DB
   - 보안
   - 빌드 및 배포

<br>
<br>

## 프로젝트 소개

**Bangcom은 한국방송통신대학교 컴퓨터과학과 가상 커뮤니티 게시판입니다.**

 - 게시판의 주제는 **방송대 컴퓨터과학과 오픈 카톡**에서 아이디어를 얻었으며, **UI**는 개발자 커뮤니티 **OKKY를 참고**했습니다.
 - **1인 프로젝트**입니다.

<br>



### 사용 기술
- **Back-end :** Java 17, Spring Boot 3, Spring Security (암호화), MyBatis, MySQL 8.0 (운영), H2 (개발)
- **Front-end :** JSP, JQuery, Bootstrap 5
- **빌드 및 배포 :** Gradle, NGINX, Rocky Linux 8, Vultr Cloud Compute
- **개발 환경 :** IntelluJ IDEA, Mac OS

<br>

### 구현 기능
- **회원 :** 로그인/로그아웃, 프로필 수정, 프로필 이미지 업로드, 비밀번호 변경, 작성 글/댓글 조회, 회원탈퇴
- **게시판 :** 카테고리 - 서브 카테고리 게시판, 게시글 CRUD, 최신순/조회순 정렬
- **댓글 :** 댓글 및 대댓글 CRUD (ajax)
- **UI :** 모바일/태블릿/PC 반응형 화면

<br>
<p align="right"><a href="#Bangcom-V1">▲ TOP</a></p>

<br>
<br>

## 미리보기

<br>


<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/5d2ca3be-2888-4603-a966-825fba0aed72" width="500"/>
</p>
<br>

<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/a6b4f0e9-5774-4776-a52d-9de3c81f0005" width="500"/>
</p>
<br>

<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/b487572e-00d2-4da3-aca2-322e9b39e23d" width="500"/>
</p>
<br>

<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/a3b208c4-a051-4fd7-beb5-ce4693aa0fb0" width="500"/>
</p>

<p align="right"><a href="#Bangcom-V1">▲ TOP</a></p>

<br>
<br>

## 개발 과정

### ERD

<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/8adb2fb1-2582-422c-9c18-cfbd13c10177" width="500"/>
</p>

### 개발-배포 프로세스
<p align="center">
<img src="https://github.com/dondonee/bangcom-board/assets/119798748/bc39de23-3902-441b-84aa-e4d5ef255758" width="500"/>
</p>

<p align="right"><a href="#Bangcom-V1">▲ TOP</a></p>

<br>
<br>

## 구현 설명

### 회원 관련

- 회원 가입 등 `form` 데이터는 `Bean Validation`으로 **유효성을 검증**하고 입력값이 올바르지 않은 경우 사용자에게 인라인 **오류메세지를 안내**했습니다.
- **비밀번호**는 Spring Security `BCryptPasswordEncoder`를 통해 단방향 **암호화**하여 저장하였습니다.
- **세션 및 인터셉터를 이용해 인증/인가**를 구현하였습니다.
- **프로필 이미지 업로드**는 `MultipartFile` 인터페이스를 이용하고 **파일은 스프링 외부 경로에 저장**하였습니다.


### 카테고리 게시판 구현

- 각 **게시판**은 **토픽**을 가집니다. (카테고리 - 서브 카테고리)
- **게시판은 하나의 DB 테이블**로 통합했고 **토픽 컬럼만으로 게시판을 구분**했습니다. 게시판 컬럼은 토픽 컬럼과 중복되기 때문에 생략했습니다. 토픽 컬럼은 `enum Topic` 클래스를 생성해 DB 컬럼에 매핑했습니다.
- `enum TopicGroup` 클래스를 만들어 각 게시판의 하위 `Topic`을 묶었습니다. `TopicGroup`을 사용하여 비슷한 메서드들을 하나로 합치고 View에 표시되는 값을 `TopicGroup` 클래스에서 관리할 수 있게 되었습니다.
  
  ```java
  public enum TopicGroup {

    NOTICE("공지사항", new Topic[]{Topic.NOTICE}, "notice"),
    INFO("정보", new Topic[]{Topic.MENTOR, Topic.USER}, "info"),
    COMMUNITY("커뮤니티", new Topic[]{Topic.CAMPUS, Topic.LIFE, Topic.MARKET}, "community"),
    QUESTIONS("Q&A", new Topic[]{Topic.CAREER, Topic.STUDY, Topic.QNA_ETC}, "questions");

    private String description;
    private Topic[] topics;
    private String uri;

    /// 생략
  }
  ```

- 게시글 CRUD는 **Spring MVC**로 구현하였습니다.


### 댓글/대댓글 CRUD

- 렌더링된 페이지에서 댓글 CRUD 수행시 **REST API & Ajax로 댓글 영역만 갱신**하도록 했습니다.


### DB

- 회원의 권한, 학년, 지역 등 **값이 제한되어있으며 잘 변하지 않는 필드는 Java `enum` 클래스로 관리**하였습니다.


### 보안

- **XSS 방어 :**
    - JSP에서 사용자가 입력한 문자열 출력시 `<c:out>`을 사용했습니다.
    - Ajax 응답으로 HTML 생성시 사용자가 입력한 문자열 출력은 `text()`를 사용했습니다.
- **SQL Injection 방어 :** MyBatis를 통한 쿼리는 `#{}` 바인딩을 통해 `PreparedStatement`를 사용했습니다.
- **HTTPS**를 적용하고 `http://`로 접속한 사용자도 `https://`로 **포워딩**하였습니다.
- **민감한 정보가 있는 설정**은 프로필을 분리하고 `.gitignore`을 통해 **추적 제외**하였습니다.
- **서버측 오류 발생시** 클라이언트에는 오류 정보를 응답하지 않고 **사용자 친화적 오류 페이지**만 보여주도록 했습니다.

### 빌드 및 배포

- **백엔드와 DB, 두 개의 클라우드 서버**를 사용했습니다.
- Gradle을 통해 WAR로 패키징하여 FileZiila SFTP를 통해 백엔드 서버에 배포하였고 **웹 서버로는 NGINX**를 사용했습니다.
- 배포 전 **프로시저**를 통해 **더미데이터**를 생성하였습니다.
- **오류 로그**는 디버깅할 수 있도록 파일로 저장했습니다.
- **도메인**을 등록하고 **HTTPS**를 적용하였습니다.

<p align="right"><a href="#Bangcom-V1">▲ TOP</a></p>

<br>
<br>
