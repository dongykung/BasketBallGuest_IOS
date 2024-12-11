//
//  AuthService+Google.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation
import GoogleSignIn

extension AuthServiceImpl {
    
    @MainActor
    func signInWithGoogle() async throws -> String {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            throw AuthError.clientIdError
        }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw AuthError.invalidate
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            
            guard let idToken = user.idToken?.tokenString else {
                throw AuthError.tokenError
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            return try await authenticationUserWithFirebase(credential: credential)
        } catch {
            throw AuthError.invalidate
        }
    }
}
