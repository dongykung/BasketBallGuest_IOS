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
    var isExistChatRoom: Bool = true
    var chatRoom: ChatRoom?
    
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
                print("채팅방 옵저버")
                await getChatRoomInfo(chatRoomId: chatRoomId)
                await updateUnReadMessageAsRead(chatRoomId: chatRoomId, myUid: myUid)
                observeChatRoom(chatRoomId, myUid: myUid)
            } else {
                print("채팅방이 없네요 ㅎ")
                await updateisExistChatRoom(false)
            }
            await updateLoadState(state: .completed)
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
    
    func observeChatRoom(_ chatRoomId: String, myUid: String) {
        self.listener = self.db.collection("Chat").document(chatRoomId).collection("Message").order(by: "createAt", descending: false).addSnapshotListener { [weak self] querySnapshot, error in
            if let _ = error {
                Task { @MainActor in
                    self?.updateLoadState(state: .failed)
                }
            }
            
            guard let snapshot = querySnapshot else { return }
            
            snapshot.documentChanges.forEach { diff in
                do {
                    let chat = try diff.document.data(as: Chat.self)
                    switch diff.type {
                    case .added:
                        self?.addChatData(chat: chat, chatRoomId: chatRoomId, myUid: myUid)
                    case .modified:
                        self?.updateChatData(chat: chat)
                    case .removed:
                        self?.removeChatData(chat: chat)
                    }
                } catch {
                    
                }
            }
        }
    }
    
    func addChatData(chat: Chat, chatRoomId: String, myUid: String) {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        
        self.chats.append(chat)
        
        if chat.sender != myUid && !chat.readBy.contains(where: { $0 == myUid }) {
            self.db.collection("Chat").document(chatRoomId).collection("Message").document(chat.id ?? "").updateData(["readBy": FieldValue.arrayUnion([myUid])])
            self.db.collection("Chat").document(chatRoomId).updateData(["readStatus.\(myUid)": Date()])
        }
    }
    
    func updateChatData(chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index] = chat
        }
    }
    
    func removeChatData(chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats.remove(at: index)
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
    
    @MainActor
    func clearText() {
        text = ""
    }
    
    func sendMessage(chatUserUid: String) async {
        guard let myUid = Auth.auth().currentUser?.uid else {
            await showToastMessage(msg: "로그인 정보를 잃었습니다. 다시 로그인 해주세요")
            return
        }
        let date = Date()
        do {
            if isExistChatRoom {
                //TODO: 채팅방 있으므로 바로 메시지 업로드
                print("채팅방 있으므로 바로 메시지 업로드")
                try await uploadMessage(myUid: myUid, chatUserUid: chatUserUid)
                await updateChatRoomData(myUid: myUid, chatUserUid: chatUserUid, date: date)
                await clearText()
            } else {
                //TODO: 채티방 생성 후 메시지 업로드
                print("채팅방 생성 후 메시지 업로드")
                try await createChatRoom(myUid: myUid, chatUserUid: chatUserUid, msg: text)
                await updateisExistChatRoom(true)
                try await uploadMessage(myUid: myUid, chatUserUid: chatUserUid)
                observeChatRoom(generateChatRoomId(uid1: myUid, uid2: chatUserUid), myUid: myUid)
                await clearText()
            }
        } catch {
            await showToastMessage(msg: "메시지 전송에 실패했습니다 다시 시도해 주세요.")
        }
    }
    
    func uploadMessage(myUid: String, chatUserUid: String) async throws {
        let chatRoomId = generateChatRoomId(uid1: myUid, uid2: chatUserUid)
        let chat = Chat(message: text, sender: myUid, readBy: [myUid], createAt: Date())
        do {
            let chatEncode = try Firestore.Encoder().encode(chat)
            try await db.collection("Chat").document(chatRoomId).collection("Message").addDocument(data: chatEncode)
        } catch {
            throw error
        }
    }
    
    func updateChatRoomData(myUid: String, chatUserUid: String, date: Date) async {
        let batch = db.batch()
        let chatRoomId = generateChatRoomId(uid1: myUid, uid2: chatUserUid)
        let chatRoomRef = self.db.collection("Chat").document(chatRoomId)
        
        batch.updateData(["readStatus.\(myUid)": date], forDocument: chatRoomRef)
        batch.updateData(["lastMessage": text], forDocument: chatRoomRef)
        batch.updateData(["lastMessageAt": date], forDocument: chatRoomRef)
        
        try? await batch.commit()
    }
    
    func createChatRoom(myUid: String, chatUserUid: String, msg: String) async throws {
        let chatRoomId = generateChatRoomId(uid1: myUid, uid2: chatUserUid)
        let chatRoom = ChatRoom(id: chatRoomId, participant: [myUid, chatUserUid], lastMessage: msg, lastMessageAt: Date(), readStatus: [myUid: Date(), chatUserUid: Date()])
        do {
            let chatRoomEncode = try Firestore.Encoder().encode(chatRoom)
            try await db.collection("Chat").document(chatRoomId).setData(chatRoomEncode, merge: true)
            self.chatRoom = chatRoom
        } catch {
            throw error
        }
    }
    
    func getChatRoomInfo(chatRoomId: String) async {
        self.chatRoom = try? await self.db.collection("Chat").document(chatRoomId).getDocument(as: ChatRoom.self)
    }
    
    func updateUnReadMessageAsRead(chatRoomId: String, myUid: String) async {
        guard let chatRoomInfo = self.chatRoom, let myLastReadStatus = chatRoomInfo.readStatus[myUid] else {
            await showToastMessage(msg: "채팅 읽음 처리에 실패했습니다.")
            return
        }
        do {
            let lastMessageDocs = try await self.db.collection("Chat").document(chatRoomId).collection("Message")
                .whereField("createAt", isGreaterThan: myLastReadStatus).getDocuments().documents
            
            let unReadMessages = lastMessageDocs.filter {
                guard let chat = try? $0.data(as: Chat.self) else { return false }
                return chat.sender != myUid && !chat.readBy.contains(where: { $0 == myUid })
            }
            
            guard !unReadMessages.isEmpty else {
                print("읽지 않은 메시지가 없습니다.")
                return
            }
            
            let batch = self.db.batch()
            unReadMessages.forEach { document in
                let messageRef = self.db.collection("Chat").document(chatRoomId).collection("Message").document(document.documentID)
                batch.updateData(["readBy": FieldValue.arrayUnion([myUid])], forDocument: messageRef)
            }
            let chatRoomRef = self.db.collection("Chat").document(chatRoomId)
            async let _ = chatRoomRef.updateData(["readStatus.\(myUid)": Date()])
            async let _ = batch.commit()
        } catch {
            
        }
    }
    
    deinit {
        print("ChatDetailViewModel deinit")
        listener?.remove()
    }
    
    
}
