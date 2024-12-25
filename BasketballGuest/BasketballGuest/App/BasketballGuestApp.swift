//
//  BasketballGuestApp.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/1/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct BasketballGuestApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authStore: AuthStore = AuthStore()
    @StateObject private var locationStore: LocationStore = LocationStore()
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String
        print(kakaoAppKey ?? "")
        KakaoSDK.initSDK(appKey: kakaoAppKey ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authStore)
                .environmentObject(locationStore)
        }
    }
}
