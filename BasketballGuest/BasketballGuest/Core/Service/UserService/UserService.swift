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
    func fetchUserData(userId: String) async throws -> UserDTO
    func updateProfileImage(urlString: String, myUid: String) async throws
    func updateBodyInfo(height: Int, weight: Int, myUid: String) async throws
    func deleteBodyInfo(myUid: String) async throws
    func updatePosition(position: [String], myUid: String) async throws
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
    
    func fetchUserData(userId: String) async throws -> UserDTO {
        do {
            let document =  try await db.collection("User").document(userId).getDocument()
            
            guard document.exists else {
                throw UserError.userNotFound
            }
            
            return try document.data(as: UserDTO.self)
        } catch let error {
            throw error
        }
    }
    
    func updateProfileImage(urlString: String, myUid: String) async throws {
        do {
            try await db.collection("User").document(myUid).updateData(["profileImageUrl": urlString])
        } catch {
            throw  PhotoError.uploadError
        }
    }
    
    func updateBodyInfo(height: Int, weight: Int, myUid: String) async throws {
        do {
            try await db.collection("User").document(myUid).updateData(["height": height, "weight": weight])
        } catch {
            throw error
        }
    }
    
    func deleteBodyInfo(myUid: String) async throws {
        do {
            try await db.collection("User").document(myUid).updateData(["height": FieldValue.delete(), "weight": FieldValue.delete()])
        } catch {
            throw error
        }
    }
    
    func updatePosition(position: [String], myUid: String) async throws {
        do {
            try await db.collection("User").document(myUid).updateData(["positions": position])
        } catch {
            throw error
        }
    }
}

