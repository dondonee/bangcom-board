DROP TABLE post IF EXISTS;
CREATE TABLE post
(
    post_id       BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    topic         VARCHAR(10) NOT NULL,
    author_id     BIGINT NOT NULL,
    title         VARCHAR(50) NOT NULL,
    content       TEXT NOT NULL,
    created_date          DATETIME NOT NULL,
    modified_date DATETIME,
    view_count    INT DEFAULT 0
--     FOREIGN KEY (category_id) REFERENCES post_category (category_id),
--     FOREIGN KEY (author_id) REFERENCES member_user (user_no)
);

DROP TABLE member_user IF EXISTS;
CREATE TABLE member_user
(
    user_no BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login_name    VARCHAR(20) NOT NULL
);

DROP TABLE member_profile IF EXISTS;
CREATE TABLE member_profile
(
    profile_id  BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no     BIGINT UNIQUE NOT NULL,
    nickname    VARCHAR(12) UNIQUE NOT NULL,
    image_url   VARCHAR(100) NULL DEFAULT NULL,
    bio         VARCHAR(150) NULL DEFAULT NULL,
    transferred TINYINT NULL DEFAULT NULL,
    grade VARCHAR(10) NULL DEFAULT NULL,
    authority VARCHAR(10) NULL DEFAULT NULL,
    region VARCHAR(2) NULL DEFAULT NULL,
--     grade       ENUM('0', '1', '2', '3', '4', 'graduate'),
--     authority   ENUM('admin', 'mentor', 'user'),
--     region      ENUM('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99'),
    joined_date   DATETIME NOT NULL,
    updated_date DATETIME NULL DEFAULT NULL,
--     FOREIGN KEY (user_no) REFERENCES member_user (user_no)
    CHECK (grade IN ('1', '2', '3', '4', 'graduate')),
    CHECK (authority IN ('A', 'M', 'U')),
    CHECK (region IN ('11', '21', '22', '23', '24', '25', '26', '29', '31', '32', '33', '34', '35', '36', '37', '38', '39', '99'))
);

DROP TABLE auth_password IF EXISTS;
CREATE TABLE auth_password
(
    password_id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_no     BIGINT NOT NULL,
    password    VARCHAR(128) NOT NULL,
    updated_date DATETIME NULL DEFAULT NULL
--     FOREIGN KEY (user_no) REFERENCES member_user (user_no)
);