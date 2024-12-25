//
//  ChatDetailViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ChatDetailViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    var listener: ListenerRegistration?
    var isExistChatRoom: Bool = false
    
    @Published var text: String = ""
    @Published var chats: [Chat] = []
    @Published var loadState: LoadState = .completed
    @Published var toast: Toast?
    
    init() {
        print("ChatDetailViewModel init")
    }
    
    func initChatRoom(chatUserUid: String) async {
        guard let myUid = Auth.auth().currentUser?.uid else {
            await showToastMessage(msg: "로그인 정보를 잃었습니다 다시 로그인 해주세요.")
            return
        }
        
        let chatRoomId = generateChatRoomId(uid1: myUid, uid2: chatUserUid)
        await updateLoadState(state: .loading)
        
        do {
            //채팅방이 존재하면 채팅방의 Message를 Observe, 없다면 채팅방 생성
            if try await isChatRoomExist(chatRoomId: chatRoomId) {
                observeChatRoom(chatRoomId)
            } else {
                await updateisExistChatRoom(false)
            }
        } catch{
            await updateLoadState(state: .failed)
            await showToastMessage(msg: "채팅방 정보를 가져오는데 실패했습니다.")
        }
    }
    
    func isChatRoomExist(chatRoomId: String) async throws -> Bool {
        do {
            return try await db.collection("Chat").document(chatRoomId).getDocument().exists
        } catch {
            throw error
        }
    }
    
    func observeChatRoom(_ chatRoomId: String) {
        self.listener = self.db.collection("Chat").document(chatRoomId).collection("Message").addSnapshotListener { [weak self] querySnapshot, error in
            if let _ = error {
                Task { @MainActor in
                    self?.updateLoadState(state: .failed)
                }
            }
            
            guard let snapshot = querySnapshot else { return }
            var newChats: [Chat] = []
            
            snapshot.documentChanges.forEach { diff in
                do {
                    let chat = try diff.document.data(as: Chat.self)
                    newChats.append(chat)
                } catch {
                    
                }
            }
            self?.addChatData(chat: newChats, chatRoomId: chatRoomId)
        }
    }
    
    func addChatData(chat: [Chat], chatRoomId: String) {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        
        self.chats.append(contentsOf: chat)
        
        let _ = chat.filter { $0.sender != myUid && $0.readCount < MAXREADCOUNT}.map { chat in
            self.db.collection("Chat").document(chatRoomId).collection("Message").document(chat.id ?? "").updateData(["readCount": FieldValue.increment(Int64(1))])
        }
    }
    
    @MainActor
    func updateLoadState(state: LoadState) {
        loadState = state
    }
    
    @MainActor
    func updateisExistChatRoom(_ exist: Bool) {
        isExistChatRoom = exist
    }
    
    @MainActor
    func showToastMessage(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
    
    
    deinit {
        print("ChatDetailViewModel deinit")
        listener?.remove()
    }
    
    
}
