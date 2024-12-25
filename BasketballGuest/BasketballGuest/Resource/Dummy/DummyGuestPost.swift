//
//  DummyGuestPost.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/11/24.
//

import Foundation

let dummyPost: GuestPost = GuestPost(
    writerUid: "",
    title: "12.15 주말 농구 하실 분 구합니다.",
    description: "즐겁게 농구하실 분 구합니다12.15 일요일 농구입니다게스트비 1000원입니다문의사항 채팅 주세요 ㅋ",
    date: Date(),
    startDate: Date(),
    endDate: Date(),
    memberCount: 10,
    positions: [.pointGuard, .center, .powerForward],
    lat: 37.33875766,
    lng: 126.9364757,
    placeName: "군포국민체육센터",
    placeAddress: "경기 군포시 군포로 339",
    parkFlag: "1",
    currentMemberCount: 2
)
