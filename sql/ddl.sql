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
);

DROP TABLE post_comment IF EXISTS;
CREATE TABLE post_comment
(
    comment_id    BIGINT   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    post_id       BIGINT   NOT NULL,
    writer_id     BIGINT   NOT NULL,
    content       TEXT     NOT NULL,
    parent_id     BIGINT   NULL DEFAULT NULL,
    mentioned_id  BIGINT   NULL DEFAULT NULL,
    group_no      INT      NULL DEFAULT NULL,
    depth_no      INT      NULL DEFAULT NULL,
    order_no      INT      NULL DEFAULT NULL,
    created_date  DATETIME NOT NULL,
    modified_date DATETIME
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
    profile_id   BIGINT        NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no      BIGINT UNIQUE NOT NULL,
    nickname     VARCHAR(12)   UNIQUE NULL DEFAULT NULL,
    image_name   VARCHAR(100)  NULL DEFAULT NULL,
    bio          VARCHAR(150)  NULL DEFAULT NULL,
    transferred  TINYINT       NULL DEFAULT NULL,
    grade        VARCHAR(10)   NULL DEFAULT NULL,
    authority    VARCHAR(10)   NULL DEFAULT NULL,
    region       VARCHAR(2)    NULL DEFAULT NULL,
    joined_date  DATETIME      NULL DEFAULT NULL,
    updated_date DATETIME      NULL DEFAULT NULL,
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
);

DROP TABLE withdrawal_member IF EXISTS;
CREATE TABLE withdrawal_member
(
    withdrawal_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no       BIGINT NOT NULL
);

DROP TABLE withdrawal_log IF EXISTS;
CREATE TABLE withdrawal_log
(
    withdrawal_log_id BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no           BIGINT       NOT NULL,
    status_code       TINYINT      NOT NULL,
    reason_code       TINYINT      NOT NULL,
    reason_text       VARCHAR(255) NULL DEFAULT NULL,
    withdrawal_date   DATETIME     NOT NULL

);
