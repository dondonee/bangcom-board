-- 인메모리 모드 초기화 SQL
-- PR 전, 완성된 스키마는 /sql/ddl.sql에 저장하고 application-sensitve.yml에 지정된 정식 DB로 변경 적용해야 함.


-- ** 회원 관련 **

DROP TABLE member_user IF EXISTS;
CREATE TABLE member_user
(
    user_no    BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login_name VARCHAR(20) NOT NULL
);

DROP TABLE auth_password IF EXISTS;
CREATE TABLE auth_password
(
    password_id  BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no      BIGINT       NOT NULL UNIQUE,
    password     VARCHAR(128) NOT NULL,
    updated_date DATETIME     NULL,
    FOREIGN KEY (user_no) REFERENCES member_user (user_no) ON DELETE CASCADE
);

DROP TABLE member_profile IF EXISTS;
CREATE TABLE member_profile
(
    profile_id   BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no      BIGINT       NOT NULL UNIQUE,
    nickname     VARCHAR(12)  NULL UNIQUE,
    image_name   VARCHAR(100) NULL,
    bio          VARCHAR(150) NULL,
    transferred  TINYINT      NULL,
    grade        VARCHAR(10)  NULL,
    authority    VARCHAR(10)  NULL,
    region       VARCHAR(2)   NULL,

--     grade       ENUM('0', '1', '2', '3', '4', 'graduate'),
--     authority   ENUM('admin', 'mentor', 'user'),
--     region      ENUM('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99'),
    joined_date  DATETIME     NULL,
    updated_date DATETIME     NULL

-- H2 임시 제약조건 (MySQL ENUM 타입 대체)
    CHECK (grade IN ('1', '2', '3', '4', 'graduate')),
    CHECK (authority IN ('A', 'M', 'U')),
    CHECK (region IN
           ('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99')),

   FOREIGN KEY (user_no) REFERENCES member_user (user_no) ON DELETE CASCADE
);

DROP TABLE profile_image IF EXISTS;
CREATE TABLE profile_image
(
    image_id    BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no     BIGINT       NOT NULL UNIQUE,
    upload_name VARCHAR(255) NULL,
    FOREIGN KEY (user_no) REFERENCES member_user (user_no) ON DELETE CASCADE
);


-- ** 게시판 관련 **

DROP TABLE post IF EXISTS;
CREATE TABLE post
(
    post_id       BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    topic         VARCHAR(10) NOT NULL,
    author_id     BIGINT      NOT NULL,
    title         VARCHAR(50) NOT NULL,
    content       TEXT        NOT NULL,
    created_date  DATETIME    NOT NULL,
    modified_date DATETIME    NULL,
    view_count    INT DEFAULT 0
);

DROP TABLE post_comment IF EXISTS;
CREATE TABLE post_comment
(
    comment_id    BIGINT   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    post_id       BIGINT   NOT NULL,
    writer_id     BIGINT   NOT NULL,
    content       TEXT     NOT NULL,
    parent_id     BIGINT   NULL,
    mentioned_id  BIGINT   NULL,
    group_no      INT      NULL,
    depth_no      INT      NULL,
    order_no      INT      NULL,
    created_date  DATETIME NOT NULL,
    modified_date DATETIME NULL,
    FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE
);


-- ** 탈퇴 **

DROP TABLE withdrawal_member IF EXISTS;
CREATE TABLE withdrawal_member
(
    withdrawal_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no       BIGINT UNIQUE NOT NULL
);

DROP TABLE withdrawal_log IF EXISTS;
CREATE TABLE withdrawal_log
(
    withdrawal_log_id BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no           BIGINT       NOT NULL,
    status_code       TINYINT      NOT NULL,
    reason_code       TINYINT      NOT NULL,
    reason_text       VARCHAR(255) NULL,
    withdrawal_date   DATETIME     NOT NULL,
    FOREIGN KEY (user_no) REFERENCES withdrawal_member (user_no) ON DELETE CASCADE
);