//
//  GuestAdminViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import Factory
import Foundation
import FirebaseFirestore

class GuestAdminViewModel: ObservableObject {
    
    @Injected(\.userService) private var userService
    @Injected(\.guestDetailService) private var guestDetailService
    
    @Published var managementGuest: [GuestApplyStatus] = []
    @Published var loadState: LoadState = .none
    @Published var toast: Toast?
    private let db = Firestore.firestore()
    
    func observeGuestAdmin(postId: String) {
        loadState = .loading
        db.collection("Guest").document(postId).collection("GuestStatus").addSnapshotListener { [weak self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                DispatchQueue.main.async {
                    self?.loadState = .completed
                }
                return
            }
            if let _ = error {
                DispatchQueue.main.async {
                    self?.loadState = .failed
                }
            }
            DispatchQueue.main.async {
                self?.loadState = .completed
            }
            snapshot.documentChanges.forEach { diff in
                do {
                    let userStatus = try diff.document.data(as: UserStatus.self)
                    switch diff.type {
                    case .added:
                        self?.addHandleGuest(userStatus: userStatus)
                    case .modified:
                        self?.updateHandleGuest(userStatus: userStatus)
                    case .removed:
                        self?.removeHandleGuest(userStatus: userStatus)
                    }
                } catch {
                    
                }
            }
        }
    }
    
    private func addHandleGuest(userStatus: UserStatus) {
        guard let userUid = userStatus.documentId else { return }
        Task {
            do {
                let userData = try await userService.fetchUserData(userId: userUid)
                let data = GuestApplyStatus(user: userData, status: userStatus)
                await addManagementData(data)
            } catch {
                
            }
        }
    }
    
    private func updateHandleGuest(userStatus: UserStatus) {
        if let index = managementGuest.firstIndex(where: { $0.status.documentId == userStatus.documentId}) {
            var newItem = managementGuest[index]
            newItem.status = userStatus
            managementGuest[index] = newItem
        }
    }
    
    private func removeHandleGuest(userStatus: UserStatus) {
        if let index = managementGuest.firstIndex(where: { $0.status.documentId == userStatus.documentId }) {
            toast = Toast(style: .warning, message: "\(managementGuest[index].user.nickName)님이 게스트 신청을 취소했습니다.")
            managementGuest.remove(at: index)
        }
    }
    
    func approveApplyGuest(postId: String, userId: String, nickName: String) async {
        do {
            try await guestDetailService.approveApplyGuest(postId: postId, userId: userId)
            await showToast(msg: "\(nickName)님을 게스트로 승인했습니다.", style: .success)
        } catch {
            await showToast(msg: "승인에 실패했습니다 다시 시도해 주세요.", style: .warning)
        }
    }
    
    func rejectApplyGuest(postId: String, userId: String, nickName: String) async {
        do {
            try await guestDetailService.rejectApplyGuest(postId: postId, userId: userId)
            await showToast(msg: "\(nickName)님을 거절했습니다.", style: .success)
        } catch {
            await showToast(msg: "거절에 실패했습니다 다시 시도해 주세요.", style: .warning)
        }
    }
    
    func emissionApplyGuest(postId: String, userId: String, nickName: String) async {
        do {
            try await guestDetailService.emissionApplyGuest(postId: postId, userId: userId)
            await showToast(msg: "\(nickName)님을 방출했습니다.", style: .success)
        } catch{
            await showToast(msg: "방출에 실패했습니다 디시 시도해 주세요.")
        }
    }
    
    @MainActor
    func addManagementData(_ data: GuestApplyStatus) {
        managementGuest.append(data)
    }
    
    @MainActor
    func showToast(msg: String, style: ToastStyle = .warning) {
        toast = Toast(style: style, message: msg)
    }
}


struct GuestApplyStatus {
    var user: UserDTO
    var status: UserStatus
}
