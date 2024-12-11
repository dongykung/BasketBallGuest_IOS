//
//  UserService.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

protocol UserService {
    func uploadUserData(user: UserDTO) async throws
}

final class UserServiceImpl: UserService {
    
    private let db = Firestore.firestore()
    
    func uploadUserData(user: UserDTO) async throws {
        guard let userUid = Auth.auth().currentUser?.uid else {
            throw UserError.invalidate
        }
        do {
            let userEncode = try Firestore.Encoder().encode(user)
            try await db.collection("User").document(userUid).setData(userEncode)
        } catch {
            throw error
        }
    }
}

