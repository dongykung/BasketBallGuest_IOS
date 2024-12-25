//
//  AuthService+Kakao.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import FirebaseAuth

extension AuthServiceImpl {
    
    @MainActor
    func signInWithKakao() async throws -> String {
        do {
            let oauthToken: OAuthToken
            if UserApi.isKakaoTalkLoginAvailable() {
                oauthToken = try await loginWithKakaoTalkAsync()
            } else {
                oauthToken = try await loginWithKakaoTalkAccountAsync()
            }
            
            _ = try await loginWithEmailPermissionAsync()
            
            guard let idToken = oauthToken.idToken else {
                throw AuthError.tokenError
            }
            let accessToken = oauthToken.accessToken
            
            let credential = OAuthProvider.credential(providerID: .custom("oidc.kakao"), idToken: idToken, accessToken: accessToken)
            return try await authenticationUserWithFirebase(credential: credential)
        } catch {
            throw AuthError.invalidate
        }
    }
    
    @MainActor
    private func loginWithKakaoTalkAsync() async throws -> OAuthToken {
        // 비동기 코드가 아닌 것을 비동기로 실행할 수 있도록 하는 함수, 오류 반환 가능
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoTalkAccountAsync() async throws -> OAuthToken {
        // 비동기 코드가 아닌 것을 비동기로 실행할 수 있도록 하는 함수, 오류 반환 가능
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithEmailPermissionAsync() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            let scopes: [String] = ["openid", "account_email"]
            
            UserApi.shared.loginWithKakaoAccount(scopes: scopes) { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                if let oauthToken {
                    continuation.resume(returning: oauthToken)
                }
            }
        }
    }
}
