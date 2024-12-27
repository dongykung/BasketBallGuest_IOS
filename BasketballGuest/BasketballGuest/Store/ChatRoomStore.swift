//
//  ChatRoomListStore.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatRoomStore: ObservableObject {
    
    private let db = Firestore.firestore()
    @Published var toast: Toast?
    @Published var chatRooms: [ChatRoomWithUser] = []
    @Published var loadState: LoadState = .loading
    
    var sortedChatRooms: [ChatRoomWithUser] {
        chatRooms.sorted(by: { $0.chatRoom.lastMessage > $1.chatRoom.lastMessage })
    }
    
    var totalUnreadCount: Int {
        sortedChatRooms.reduce(0) { $0 + $1.unReadCount }
    }
    
    init() {
        observeChatRoomList()
    }
    
    func observeChatRoomList() {
        guard let myUid = Auth.auth().currentUser?.uid else {
            updateLoadState(.failed)
            showToastMessage("로그인 정보를 잃었습니다 다시 로그인 해주세요.")
            return
        }
        
        self.db.collection("Chat").whereField("participant", arrayContains: myUid).addSnapshotListener { [weak self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                return
            }
            
            if let _ = error {
                self?.updateLoadState(.failed)
            }
            self?.updateLoadState(.completed)
            snapshot.documentChanges.forEach { diff in
                do {
                    let chatRoom = try diff.document.data(as: ChatRoom.self)
                    switch diff.type {
                    case .added:
                        Task {
                            await self?.handleAddChatRoom(chatRoom, myUid: myUid)
                        }
                    case .modified:
                        Task {
                            await self?.handleUpdateChatRoom(chatRoom, myUid: myUid)
                        }
                    case .removed:
                        self?.handleRemove(chatRoom)
                    }
                } catch {
                    self?.showToastMessage("로드에 실패한 채팅방이 있습니다.")
                }
            }
        }
    }
    
    func updateLoadState(_ state: LoadState) {
        loadState = state
    }
    
    func showToastMessage(_ msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
    
    private func handleAddChatRoom(_ chatRoom: ChatRoom, myUid: String) async {
        do {
            async let chatUserInfo = fetchChatUserData(chatRoom: chatRoom, myUid: myUid)
            async let unReadCount = calculateUnReadCount(chatRoom: chatRoom, myUid: myUid)
            let chatRoomWithUser = try ChatRoomWithUser(chatRoom: chatRoom, user: await chatUserInfo, unReadCount: await unReadCount)
            await addChatRoomWithUser(chatRoomWithUser)
        } catch {
            Task { @MainActor in
                showToastMessage("로드에 실패한 채팅방이 있습니다.")
            }
        }
    }
    
    private func handleUpdateChatRoom(_ chatRoom: ChatRoom, myUid: String) async {
        do {
            async let chatUserInfo = fetchChatUserData(chatRoom: chatRoom, myUid: myUid)
            async let unReadCount = calculateUnReadCount(chatRoom: chatRoom, myUid: myUid)
            let chatRoomWithUser = try ChatRoomWithUser(chatRoom: chatRoom, user: await chatUserInfo, unReadCount: await unReadCount)
            await updateChatRoomWithUser(chatRoomWithUser)
        } catch {
            Task { @MainActor in
                showToastMessage("로드에 실패한 채팅방이 있습니다.")
            }
        }
    }
    
    @MainActor
    func addChatRoomWithUser(_ data: ChatRoomWithUser) {
        chatRooms.append(data)
    }
    
    @MainActor
    func updateChatRoomWithUser(_ data: ChatRoomWithUser) {
        if let index = chatRooms.firstIndex(where: { $0.chatRoom.id == data.chatRoom.id }) {
            chatRooms[index] = data
        }
    }
    
    private func handleRemove(_ chatRoom: ChatRoom) {
        if let index = self.chatRooms.firstIndex(where: { $0.chatRoom.id == chatRoom.id }) {
            self.chatRooms.remove(at: index)
        }
    }
    
    private func fetchChatUserData(chatRoom: ChatRoom, myUid: String) async throws -> UserDTO {
        guard let chatUserUid = chatRoom.participant.filter( { $0 != myUid }).first else {
            throw ChatRoomError.unKownChatUser
        }
        do {
            return try await self.db.collection("User").document(chatUserUid).getDocument(as: UserDTO.self)
        } catch {
            throw error
        }
    }
    
    private func calculateUnReadCount(chatRoom: ChatRoom, myUid: String) async -> Int {
        guard let lastReadDate = chatRoom.readStatus[myUid], let chatRoomId = chatRoom.id else {
            return 0
        }
        do {
            let messageDocs = try await self.db.collection("Chat").document(chatRoomId).collection("Message")
                .whereField("createAt", isGreaterThan: lastReadDate).getDocuments().documents
            
            if messageDocs.isEmpty {
                return 0
            }
            
            let unReadCount = try messageDocs.compactMap( { try $0.data(as: Chat.self)} )
                .filter({ $0.sender != myUid && !$0.readBy.contains(myUid)}).count
            
            return unReadCount
        } catch {
            return 0
        }
    }
}


enum ChatRoomError: Error {
    case unKownChatUser
}
