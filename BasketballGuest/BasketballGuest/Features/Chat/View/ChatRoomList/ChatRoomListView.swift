//
//  ChatRoomView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct ChatRoomListView: View {
    @EnvironmentObject private var chatRoomStore: ChatRoomStore
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                Divider()
                    .shadow(radius: 2)
                ScrollView {
                    switch chatRoomStore.loadState {
                    case .loading:
                        LoadingView()
                    case .completed:
                        LazyVStack {
                            ForEach(chatRoomStore.chatRooms, id: \.chatRoom.id) { chatRoomWithUser in
                                ChatListItemView(chatRoomWithUser: chatRoomWithUser)
                                    .padding(.vertical, 12)
                            }
                        }
                    case .none, .failed:
                        ErrorView {
                            chatRoomStore.observeChatRoomList()
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    var topBar: some View {
        HStack {
            Text("채팅")
                .font(.semibold16)
            Spacer()
        }
        .padding()
    }
}

fileprivate struct ChatListItemView: View {
    
    let chatRoomWithUser: ChatRoomWithUser
    
    var body: some View {
        NavigationLink {
            ChatDetailView(chatUser: chatRoomWithUser.user)
        } label: {
            HStack {
                DefaultProfileView(profileUrl: chatRoomWithUser.user.profileImageUrl, frame: 55)
                    .padding(.trailing, 6)
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(chatRoomWithUser.user.nickName)
                            .foregroundStyle(.basic)
                            .font(.semibold16)
                        Spacer()
                        Text(chatRoomWithUser.chatRoom.lastMessageAt.formattedTimeAgo)
                            .foregroundStyle(.gray)
                            .font(.regular14)
                    }
                    HStack {
                        Text(chatRoomWithUser.chatRoom.lastMessage)
                            .foregroundStyle(.gray)
                            .font(.regular14)
                        Spacer()
                        if chatRoomWithUser.unReadCount > 0 {
                            Text("\(chatRoomWithUser.unReadCount)")
                                .bold()
                                .font(.caption)
                                .padding(6)
                                .foregroundStyle(.white)
                                .background(.red)
                                .clipShape(.circle)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChatRoomListView()
        .environmentObject(ChatRoomStore())
}
