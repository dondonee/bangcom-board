package com.knou.board.domain.member;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

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
    private String description;

    @MappedTypes(Region.class)
    public static class TypeHandler extends CodeEnumTypeHandler<Region> {
        public TypeHandler() {
            super(Region.class);
        }
    }
}
