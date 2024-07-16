package com.knou.board.web.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class ProfileController {

    private final Environment env;

    @GetMapping("/spring-profile")
    public String getProfile() {
        List<String> profiles = Arrays.asList(env.getActiveProfiles());
        List<String> sets = Arrays.asList("set1", "set2");
        return profiles.stream()
                .filter(sets::contains)
                .findFirst()
                .orElse("no set profile");
    }
}
