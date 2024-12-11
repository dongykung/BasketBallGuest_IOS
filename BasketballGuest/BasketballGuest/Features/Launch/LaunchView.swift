//
//  LaunchView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject private var authStore: AuthStore
    
    var body: some View {
        Group {
            switch authStore.authState {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .unAuthenticated:
                LoginView(viewModel: LoginViewModel(authStore: authStore))
                    .transition(.opacity)
            case .signUp:
                SignUpContainerView(viewModel: SignUpContainerViewModel(authStore: authStore))
                    .transition(.opacity)
            case .authenticated, .guest:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.smooth, value: authStore.authState)
    }
}

struct SplashView: View {
    
    @EnvironmentObject private var authStore: AuthStore
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .task {
            await authStore.autoLogin()
        }
        .overlay {
            ProgressView()
                .tint(Color(uiColor: .systemGray3))
                .scaleEffect(1.5)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
        .environmentObject(AuthStore())
}
