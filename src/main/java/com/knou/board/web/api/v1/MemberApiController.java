package com.knou.board.web.api.v1;

import com.knou.board.domain.member.Member;
import com.knou.board.service.MemberService;
import com.knou.board.web.argumentresolver.Login;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api/v1")
@RestController
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;

    @GetMapping("/members/me")
    public ResponseEntity<Member> getLoginMember(@Login Member loginMember) {

        Member member = memberService.findProfileByUserNo(loginMember.getUserNo());
        return ResponseEntity.ok(member);
    }
}
