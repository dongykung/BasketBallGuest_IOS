//
//  BasketballGuestApp.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/1/24.
//

import SwiftUI

@main
struct BasketballGuestApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authStore: AuthStore = AuthStore()
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authStore)
        }
    }
}
