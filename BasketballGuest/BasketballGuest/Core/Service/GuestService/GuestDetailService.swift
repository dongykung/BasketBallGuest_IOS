//
//  GuestDetailService.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import Foundation
import FirebaseFirestore

protocol GuestDetailService {
    func getGuestPost(postId: String) async throws -> GuestPost
    func getGuestStatus(postId: String, userId: String) async throws -> GuestStatus
    func applyGuest(postId: String, userId: String) async throws
    func cancelApplyGuest(postId: String, userId: String) async throws
    func approveApplyGuest(postId: String, userId: String) async throws
    func rejectApplyGuest(postId: String, userId: String) async throws
    func emissionApplyGuest(postId: String, userId: String) async throws
}

class GuestDetailServiceImpl: GuestDetailService {
    
    private let db = Firestore.firestore()
    
    func getGuestPost(postId: String) async throws -> GuestPost {
        do {
            let document = try await db.collection("Guest").document(postId).getDocument()
            return try document.data(as: GuestPost.self)
        } catch {
            throw error
        }
    }
    
    func getGuestStatus(postId: String, userId: String) async throws -> GuestStatus {
        do {
            let userDocument = try await db.collection("Guest").document(postId).collection("GuestStatus").document(userId).getDocument()
            if !userDocument.exists {
                return .none
            }
            let userStatus = try userDocument.data(as: UserStatus.self)
            return userStatus.status
        } catch {
            throw error
        }
    }
    
    func applyGuest(postId: String, userId: String) async throws {
        do {
            let applyData = UserStatus(status: .apply)
            let applyEncode = try Firestore.Encoder().encode(applyData)
            try await db.collection("Guest").document(postId).collection("GuestStatus").document(userId).setData(applyEncode)
            try await db.collection("User").document(userId).collection("participant").document(postId).setData([:])
        } catch {
            throw error
        }
    }
    
    func cancelApplyGuest(postId: String, userId: String) async throws {
        do {
            try await db.collection("Guest").document(postId).collection("GuestStatus")
                .document(userId).delete()
            try await db.collection("User").document(userId).collection("participant").document(postId).delete()
        } catch {
            throw error
        }
    }
    
    func approveApplyGuest(postId: String, userId: String) async throws {
        do {
            try await db.collection("Guest").document(postId).collection("GuestStatus")
                .document(userId).updateData(["status": GuestStatus.guest.rawValue])
            try await db.collection("Guest").document(postId).updateData(["currentMemberCount": FieldValue.increment(Int64(1))])
        } catch {
            throw error
        }
    }
    
    func rejectApplyGuest(postId: String, userId: String) async throws {
        do {
            try await db.collection("Guest").document(postId).collection("GuestStatus")
                .document(userId).updateData(["status": GuestStatus.rejected.rawValue])
        } catch {
            throw error
        }
    }
    
    func emissionApplyGuest(postId: String, userId: String) async throws {
        do {
            try await db.collection("Guest").document(postId).collection("GuestStatus")
                .document(userId).delete()
            try await db.collection("Guest").document(postId).updateData(["currentMemberCount": FieldValue.increment(Int64(-1))])
        } catch {
            throw error
        }
    }
}
