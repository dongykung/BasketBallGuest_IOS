//
//  ManageVIewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/4/25.
//

import Factory
import Foundation
import FirebaseAuth

class ManageViewModel: ObservableObject {
    @Injected(\.userService) private var userService
    @Injected(\.guestService) private var guestService
    @Injected(\.guestDetailService) private var guestDetailService
    @Published var myParticipantLoadState: LoadState = .none
    @Published var myParticipantStatus: [MyParticipantStatus] = []
    @Published var myPostLoadState: LoadState = .none
    @Published var myPost: [GuestPost] = []
    @Published var toast: Toast?
    @Published var section: ManageSection = .myApply
    
    init() {
        Task {
            async let _ =  fetchMyPost()
            async let _ = fetchMyParticipant()
        }
    }
    
    func fetchMyPost() async {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        do {
            let myPosts = try await guestService.getMyPost(myUid: myUid)
            await updateMyPost(myPosts: myPosts)
            await updateMyPostLoadState(state: .completed)
        } catch {
            await showToast(msg: "내가 작성한 구인 목록을 가져오는데 실패했습니다.")
            await updateMyPostLoadState(state: .failed)
        }
    }
    
    func fetchMyParticipant() async {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        await updateMyParticipantLoadState(state: .loading)
        do {
            let myParticipantPost = try await userService.fetchMyParticipant(myUid: myUid)
            print(myParticipantPost)
            let results = try await withThrowingTaskGroup(of: MyParticipantStatus.self) { group  in
                for postId in myParticipantPost {
                    group.addTask {
                        async let post = self.fetchParticipantPost(postId: postId)
                        async let status = self.fetchParticipantState(postId: postId, myUid: myUid)
                        return try await MyParticipantStatus(post: post, status: status)
                    }
                }
                var collectedStatuses: [MyParticipantStatus] = []
                for try await data in group {
                    collectedStatuses.append(data)
                }
                return collectedStatuses
            }
            await updateMyParticipantStatus(status: results)
            await updateMyParticipantLoadState(state: .completed)
        } catch {
            await showToast(msg: "글 목록을 가져오는데 실패했습니다 다시 시도해 주세요.")
            await updateMyParticipantLoadState(state: .failed)
        }
    }
    
    func fetchParticipantPost(postId: String) async throws -> GuestPost {
        return try await guestDetailService.getGuestPost(postId: postId)
    }
    
    func fetchParticipantState(postId: String, myUid: String) async throws -> GuestStatus{
        return try await guestDetailService.getGuestStatus(postId: postId, userId: myUid)
    }
    
    func refresh() async {
        switch section {
        case .myApply:
            await fetchMyParticipant()
        case .myPost:
            await fetchMyPost()
        }
    }
    
    @MainActor
    func updateMyPostLoadState(state: LoadState) {
        myPostLoadState = state
    }
    
    @MainActor
    func updateMyPost(myPosts: [GuestPost]) {
        myPost = myPosts.sorted(by: { $0.date > $1.date})
    }
    
    @MainActor
    func updateMyParticipantLoadState(state: LoadState) {
        myParticipantLoadState = state
    }
    
    @MainActor
    func updateMyParticipantStatus(status: [MyParticipantStatus]) {
        myParticipantStatus = status
    }
    
    @MainActor
    func showToast(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
}


enum ManageSection {
    case myApply
    case myPost
}
