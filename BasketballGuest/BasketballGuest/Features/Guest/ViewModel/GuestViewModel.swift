//
//  GuestViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import Factory
import FirebaseFirestore
import Foundation

class GuestViewModel: ObservableObject {
    @Injected(\.guestService) private var guestService
    @Published var guestPost: [GuestPost] = []
    @Published var guestFilter: GuestFilter = GuestFilter()
    @Published var canLoadMore: Bool = true
    @Published var toast: Toast?
    @Published var isPagination: Bool = false
    @Published var loadState: LoadState = .none
    @Published var pagingLoadState: LoadState = .none
    
    private var lastDocument: DocumentSnapshot? = nil
    private let limit = 10
    
    init() {
        Task {
            await fetchGuestPost()
        }
    }
    
    func fetchGuestPost() async {
        guard loadState != .loading && pagingLoadState != .loading && canLoadMore else {
            print("가드문탔음")
            return
        }
        
        DispatchQueue.main.async {
            self.setLoadState(state: .loading)
        }
        
        do {
            let result = try await guestService.getDefaultGuestPost(with: guestFilter, lastDocument: lastDocument)
            DispatchQueue.main.async {
                self.lastDocument = result.lastDocument
                self.canLoadMore = result.posts.count == self.limit
                self.guestPost += result.posts
                self.setLoadState(state: .completed)
            }
        } catch {
            DispatchQueue.main.async {
                print("실패함 \(error)")
                self.setLoadState(state: .failed)
            }
        }
    }
    
    func setLoadState(state: LoadState) {
        if isPagination {
            pagingLoadState = state
        } else {
            loadState = state
        }
    }
    
    func loadMoreIfNeeded(currentPost post: GuestPost) {
        guard let lastPost = guestPost.last else { return }
        guard canLoadMore else { return }
        guard pagingLoadState != .loading && pagingLoadState != .failed else { return }
        
        if lastPost.documentId == post.documentId {
            isPagination = true
            Task {
                print("paging")
                await fetchGuestPost()
            }
        }
    }
    
    func refresh() {
        resetPaging()
    }
    
    func resetPaging() {
        self.lastDocument = nil
        canLoadMore = true
        loadState = .none
        pagingLoadState = .none
        isPagination = false
        self.guestPost.removeAll()
    }
    
    func setfilterDate() {
        resetPaging()
        Task {
            await fetchGuestPost()
        }
    }
    
}
