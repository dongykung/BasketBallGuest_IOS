//
//  LoginViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import Factory
import Foundation

class LoginViewModel: ObservableObject {
    
    @Injected(\.authService) private var authService
    @Published var loadState: LoadState = .none
    @Published var toast: Toast?
    private var authStore: AuthStore
    
    init(authStore: AuthStore) {
        print("loginViewModel init")
        self.authStore = authStore
    }
    
    @MainActor
    func googleLogin() async {
        loadState = .loading
        do {
            _ = try await authService.signInWithGoogle()
            loadState = .completed
            try await authStore.login()
        } catch {
            showToastMessage(msg: "로그인에 실패했습니다. 다시 시도해 주세요.")
            loadState = .failed
        }
    }
    
    @MainActor
    func kakaoLogin() async {
        loadState = .loading
        do {
            _ = try await authService.signInWithKakao()
            loadState = .completed
            try await authStore.login()
        } catch {
            showToastMessage(msg: "로그인에 실패했습니다. 다시 시도해 주세요.")
            loadState = .failed
        }
    }
    
    func showToastMessage(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
    
    deinit {
        print("loginViewModel deinit")
    }
}
