package com.knou.board.web;

import java.time.*;
import java.time.temporal.ChronoUnit;

public class JspFunction {

    public String getElapsedTime(LocalDateTime createdTime) {

        LocalDateTime now = LocalDateTime.now();
        long nowMS = now.atZone(ZoneId.of("Asia/Seoul")).toEpochSecond();
        long createdMS = createdTime.atZone(ZoneId.of("Asia/Seoul")).toEpochSecond();

        long seconds = nowMS - createdMS;
        if (seconds < 60) {
            return "방금 전";
        }

        long minutes = seconds / 60;
        if (minutes < 60) {
            return minutes + "분 전";
        }

        long hours = minutes / 60;
        if (hours < 24) {
            return hours + "시간 전";
        }

        long days = hours / 24;
        long weeks = ChronoUnit.WEEKS.between(createdTime, now);
        long months = ChronoUnit.MONTHS.between(createdTime, now);
        long years = ChronoUnit.YEARS.between(createdTime, now);

        if (days < 7) {
            return days + "일 전";
        }

        if (months < 1) {
            return "약 " + weeks + "주 전";
        }

        if (months < 12) {
            return "약 " + months + "개월 전";
        }

        return "약 " + years + "년 전";
    }
}
