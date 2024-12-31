//
//  GuestDetailViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/11/24.
//

import Factory
import SwiftUI
import FirebaseAuth

class GuestDetailViewModel: ObservableObject {
    
    @Injected(\.userService) private var userService
    @Injected(\.guestDetailService) private var guestDetailService
    @Published var post: GuestPost
    @Published var guestUser: UserDTO?
    @Published var userLoadState: LoadState = .none
    
    @Published var userState: GuestStatus = .none
    @Published var userStatusState: LoadState = .none
    
    @Published var toast: Toast?
    private var path: NavigationPath
    
    init(path: NavigationPath, post: GuestPost) {
        self.path = path
        self.post = post
    }
    
    func fetchUserInfo(userId: String) async {
        DispatchQueue.main.async {
            self.userLoadState = .loading
        }
        
        do {
            let userDTO = try await userService.fetchUserData(userId: userId)
            await updateUserInfo(uesrDTO: userDTO)
            DispatchQueue.main.async {
                self.userLoadState = .completed
            }
        } catch let error as UserError {
            DispatchQueue.main.async {
                print(error.localizedDescription)
                self.toast = Toast(style: .warning, message: "유저 정보를 찾을 수 없습니다.")
                self.path.removeLast()
            }
        } catch {
            DispatchQueue.main.async {
                self.userLoadState = .failed
                self.toast = Toast(style: .warning, message: "유저 정보를 가져오지 못했습니다, 다시 시도해 주세요.")
            }
        }
    }
    
    func fetchUserStatus(postId: String, userId: String) async {
        guard let myUid = getMyUid() else { return }
        if Auth.auth().currentUser?.uid == userId {
            await updateUserStatusLoadState(state: .completed)
            await updateUserState(state: .owner)
            return
        }
        await updateUserStatusLoadState(state: .loading)
        do {
            let status = try await guestDetailService.getGuestStatus(postId: postId, userId: myUid)
            await updateUserState(state: status)
            await updateUserStatusLoadState(state: .completed)
        } catch {
            await showToast(msg: "신청 상태를 가져오는데 실패했습니다.")
            await updateUserStatusLoadState(state: .failed)
        }
    }
    
    func setApplyUserStatus(postId: String) {
        guard let myUid = getMyUid() else { return }
        userStatusState = .loading
        Task {
            do {
                try await guestDetailService.applyGuest(postId: postId, userId: myUid)
                await updateUserState(state: .apply)
                await updateUserStatusLoadState(state: .completed)
                await showToast(msg: "신청을 완료했습니다.", style: .success)
            } catch {
                await showToast(msg: "신청에 실패했습니다 다시 시도해 주세요.")
                await updateUserStatusLoadState(state: .completed)
            }
        }
    }
    
    func setApplyCnacelUserStatus(postId: String) {
        guard let myUid = getMyUid() else { return }
        userStatusState = .loading
        Task {
            do {
                try await guestDetailService.cancelApplyGuest(postId: postId, userId: myUid)
                await updateUserState(state: .none)
                await updateUserStatusLoadState(state: .completed)
                await showToast(msg: "신청을 취소하였습니다.", style: .success)
            } catch {
                await showToast(msg: "신청취소에 실패했습니다. 다시 시도해 주세요.")
                await updateUserStatusLoadState(state: .completed)
            }
        }
    }
    
    func refreshPostData() async {
        do {
            let newPost = try await guestDetailService.getGuestPost(postId: post.documentId ?? "")
            await updatePost(newPost: newPost)
            async let _ = fetchUserInfo(userId: post.writerUid)
            async let _ = fetchUserStatus(postId: post.documentId ?? "", userId: post.writerUid)
        } catch {
            await showToast(msg: "새로고침에 실패했습니다 다시 시도해 주세요.", style: .error)
        }
    }
    
    @MainActor
    func updateUserState(state: GuestStatus) {
        userState = state
    }
    
    @MainActor
    func updateUserStatusLoadState(state: LoadState) {
        userStatusState = state
    }
    
    @MainActor
    func updateUserInfo(uesrDTO: UserDTO) {
        guestUser = uesrDTO
    }
    
    @MainActor
    func showToast(msg: String, style: ToastStyle = .warning) {
        toast = Toast(style: style, message: msg)
    }
    
    @MainActor
    func updatePost(newPost: GuestPost) {
        post = newPost
    }
}
