//
//  AuthService.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol AuthService {
    func isExistUser(uid: String) async throws -> Bool
    func isNicknameAvailable(nickName: String) async throws -> Bool
    func signInWithGoogle() async throws -> String
}

final class AuthServiceImpl: AuthService {
    
    private let db = Firestore.firestore()
    
    func isExistUser(uid: String) async throws -> Bool {
        do {
            return try await db.collection("User").document(uid).getDocument().exists
        } catch {
            throw AuthError.signInError
        }
    }
    
    func isNicknameAvailable(nickName: String) async throws -> Bool {
        do {
            let querySnapshot = try await db.collection("User").whereField("nickName", isEqualTo: nickName).getDocuments()
            return querySnapshot.isEmpty
        } catch {
            throw error
        }
    }
    
    internal func authenticationUserWithFirebase(credential: AuthCredential) async throws -> String {
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return authResult.user.uid
        } catch {
            throw AuthError.signInError
        }
    }
}

