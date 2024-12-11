//
//  AuthStore.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import Factory
import FirebaseAuth
import Foundation

class AuthStore: ObservableObject {
    
    @Injected(\.authService) private var authService
    
    enum AuthState {
        case splash
        case unAuthenticated
        case signUp
        case authenticated, guest
    }
    
    @Published var authState: AuthState = .splash
    
    @MainActor
    func login() async throws {
        guard let userUid = Auth.auth().currentUser?.uid else {
            throw AuthError.invalidate
        }
        do {
            if try await authService.isExistUser(uid: userUid) {
                self.authState = .authenticated
            } else {
                self.authState = .signUp
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func autoLogin() async {
        guard let userUid = Auth.auth().currentUser?.uid else {
            authState = .unAuthenticated
            return
        }
        do {
            if try await authService.isExistUser(uid: userUid) {
                authState = .authenticated
            } else {
                authState = .unAuthenticated
            }
        } catch {
            authState = .unAuthenticated
        }
    }
}
