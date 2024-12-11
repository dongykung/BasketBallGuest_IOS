//
//  SocialType.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI

protocol SocialConfigurable {
    var title: String { get }
    var backgroundColor: Color { get }
    var foregroundColor: Color { get }
    var logo: ImageResource { get }
}

struct KakaoConfig: SocialConfigurable {
    var title: String { "Kakao로 시작하기" }
    var backgroundColor: Color { .kakao }
    var foregroundColor: Color { .black }
    var logo: ImageResource { .kakaologo }
}

struct AppleConfig: SocialConfigurable {
    var title: String { "Apple로 시작하기" }
    var backgroundColor: Color { .black }
    var foregroundColor: Color { .white }
    var logo: ImageResource { .applelogo }
}

struct GoogleConfig: SocialConfigurable {
    var title: String { "Google로 시작하기" }
    var backgroundColor: Color { .white }
    var foregroundColor: Color { .black }
    var logo: ImageResource { .googlelogo }
}

extension SocialConfigurable where Self == KakaoConfig {
    static var kakao: SocialConfigurable { KakaoConfig() }
}

extension SocialConfigurable where Self == GoogleConfig {
    static var google: SocialConfigurable { GoogleConfig() }
}

extension SocialConfigurable where Self == AppleConfig {
    static var apple: SocialConfigurable { AppleConfig() }
}

