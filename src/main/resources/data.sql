-- 인메모리 모드 초기화 SQL
-- PR 전, 완성된 스키마는 /sql/ddl.sql에 저장하고 application-sensitve.yml에 지정된 정식 DB로 변경 적용해야 함.

DROP TABLE post IF EXISTS;
CREATE TABLE post
(
    post_id       BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    topic         VARCHAR(10) NOT NULL,
    author_id     BIGINT      NOT NULL,
    title         VARCHAR(50) NOT NULL,
    content       TEXT        NOT NULL,
    created_date  DATETIME    NOT NULL,
    modified_date DATETIME,
    view_count    INT DEFAULT 0
--     FOREIGN KEY (category_id) REFERENCES post_category (category_id),
--     FOREIGN KEY (author_id) REFERENCES member_user (user_no)
);

DROP TABLE member_user IF EXISTS;
CREATE TABLE member_user
(
    user_no    BIGINT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login_name VARCHAR(20) NOT NULL
);

DROP TABLE member_profile IF EXISTS;
CREATE TABLE member_profile
(
    profile_id   BIGINT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no      BIGINT UNIQUE      NOT NULL,
    nickname     VARCHAR(12) UNIQUE NOT NULL,
    image_name    VARCHAR(100)       NULL DEFAULT NULL,
    bio          VARCHAR(150)       NULL DEFAULT NULL,
    transferred  TINYINT            NULL DEFAULT NULL,
    grade        VARCHAR(10)        NULL DEFAULT NULL,
    authority    VARCHAR(10)        NULL DEFAULT NULL,
    region       VARCHAR(2)         NULL DEFAULT NULL,
--     grade       ENUM('0', '1', '2', '3', '4', 'graduate'),
--     authority   ENUM('admin', 'mentor', 'user'),
--     region      ENUM('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99'),
    joined_date  DATETIME           NOT NULL,
    updated_date DATETIME           NULL DEFAULT NULL,
--     FOREIGN KEY (user_no) REFERENCES member_user (user_no)
    CHECK (grade IN ('1', '2', '3', '4', 'graduate')),
    CHECK (authority IN ('A', 'M', 'U')),
    CHECK (region IN
           ('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99'))
);

DROP TABLE profile_image IF EXISTS;
CREATE TABLE profile_image
(
    image_id    BIGINT        NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no     BIGINT UNIQUE NOT NULL,
    upload_name VARCHAR(255)  NULL DEFAULT NULL
);

DROP TABLE auth_password IF EXISTS;
CREATE TABLE auth_password
(
    password_id  BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no      BIGINT       NOT NULL,
    password     VARCHAR(128) NOT NULL,
    updated_date DATETIME     NULL DEFAULT NULL
--     FOREIGN KEY (user_no) REFERENCES member_user (user_no)
);

-- Dummy Data
INSERT INTO member_user (login_name) VALUES ('knou01');
INSERT INTO auth_password (user_no, password) VALUES (1, 'password12!@');
INSERT INTO member_profile (user_no, nickname, grade, region, authority, joined_date) VALUES (1, '방콤', '1', '11', 'U', '2021-01-01 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('C-CAMPUS', 1, '예시 제목입니다.', '예시 내용입니다.', '2024-05-01 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('C-CAMPUS', 1, '예시 제목입니다.', '예시 내용입니다.', '2023-05-15 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('C-LIFE', 1, '예시 제목입니다.', '예시 내용입니다.', '2024-05-13 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('C-CAMPUS', 1, '예시 제목입니다.', '예시 내용입니다.', '2024-05-13 18:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('NOTICE', 1, 'NOTICE 예시 제목입니다.', '예시 내용입니다.', '2021-01-01 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('I-USER', 1, 'INFO 예시 제목입니다.', '예시 내용입니다.', '2021-01-01 00:00:00');
INSERT INTO post (topic, author_id, title, content, created_date) VALUES ('Q-CAREER', 1, 'Q&A 예시 제목입니다.', '예시 내용입니다.', '2021-01-01 00:00:00');