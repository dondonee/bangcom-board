package com.knou.board.domain.member;

import com.fasterxml.jackson.annotation.JsonValue;
import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.apache.ibatis.type.MappedTypes;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class Member {

    private Long userNo;
    private String nickname;
    private String imageName;
    private String bio;
    private Grade grade;
    private Boolean transferred;
    private Region region;
    private Authority authority;
    private LocalDateTime joinedDate;
    private LocalDateTime updatedDate;


    @Getter
    @AllArgsConstructor
    public enum Grade implements CodeEnum {

        GRADE_1("1", "1학년"),
        GRADE_2("2", "2학년"),
        GRADE_3("3", "3학년"),
        GRADE_4("4", "4학년"),
        GRADUATE("9", "졸업생");

        private String code;
        @JsonValue
        private String description;

        @MappedTypes(Grade.class)
        public static class TypeHandler extends CodeEnumTypeHandler<Grade> {
            public TypeHandler() {
                super(Grade.class);
            }
        }
    }

    @Getter
    @AllArgsConstructor
    public enum Region implements CodeEnum {

        SEOUL("11", "서울"),
        BUSAN("21", "부산"),
        DAEGU("22", "대구"),
        INCHEON("23", "인천"),
        GWANGJU("24", "광주"),
        DAEJEON("25", "대전"),
        ULSAN("26", "울산"),
        SEJONG("29", "세종"),
        GYEONGGI("31", "경기"),
        GANGWON("32", "강원"),
        CHUNGBUK("33", "충북"),
        CHUNGNAM("34", "충남"),
        JEONBUK("35", "전북"),
        JEONNAM("36", "전남"),
        GYEONGBUK("37", "경북"),
        GYEONGNAM("38", "경남"),
        JEJU("39", "제주"),
        OVERSEAS("99", "해외");


        private String code;
        @JsonValue
        private String description;

        @MappedTypes(Region.class)
        public static class TypeHandler extends CodeEnumTypeHandler<Region> {
            public TypeHandler() {
                super(Region.class);
            }
        }
    }

    @Getter
    @AllArgsConstructor
    public enum Authority implements CodeEnum {

        ADMIN("A", "관리자"),
        MENTOR("M", "멘토"),
        USER("U", "사용자");

        private String code;
        @JsonValue
        private String description;

        @MappedTypes(Authority.class)
        public static class TypeHandler extends CodeEnumTypeHandler<Authority> {
            public TypeHandler() {
                super(Authority.class);
            }
        }
    }
}
