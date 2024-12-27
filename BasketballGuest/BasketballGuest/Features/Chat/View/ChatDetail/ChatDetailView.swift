//
//  ChatDetailView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import SwiftUI

struct ChatDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ChatDetailViewModel = .init()
    private let chatUser: UserDTO
    
    init(chatUser: UserDTO) {
        self.chatUser = chatUser
    }
    
    var body: some View {
        VStack {
            ChatTopBar(user: chatUser) {
                dismiss()
            }
            Divider()
            switch viewModel.loadState {
            case .none, .loading:
                LoadingView()
                    .transition(.opacity)
            case .failed:
                ErrorView {
                    Task {
                        await viewModel.initChatRoom(chatUserUid: chatUser.id ?? "")
                    }
                }
                .transition(.opacity)
            case .completed:
                ChatListView(text: $viewModel.text, chatUser: chatUser, chatList: viewModel.groupedChatsByDate) { msg in
                    Task {
                        await viewModel.sendMessage(chatUserUid: chatUser.id ?? "")
                        viewModel.text = ""
                    }
                }
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.initChatRoom(chatUserUid: chatUser.id ?? "")
        }
        .toastView(toast: $viewModel.toast)
        .animation(.smooth, value: viewModel.loadState)
    }
}

fileprivate struct ChatListView: View {
    
    @State var height: CGFloat = 0
    @Binding var text: String
    let chatUser: UserDTO
    let chatList: [ChatSection]
    let send: (String) -> Void
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatList) { section in
                            Text(section.date.chatSectionFormatted)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                            
                            ForEach(section.chats, id: \.id) { chat in
                                ChatItemView(chat: chat, chatUser: chatUser)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .id(chat.id)
                            }
                        }
                    }
                }
            }
            Spacer()
            Divider()
            HStack(alignment: .bottom) {
                ResizableTextField(text: $text, height: $height)
                    .frame(height: height < 80 ? height : 80)
                    .modifier(TextFieldModifier())
                    .overlay(alignment: .leading) {
                        if text.isEmpty {
                            Text("메시지를 입력해 주세요.")
                                .transition(.opacity)
                                .offset(x: 8)
                                .foregroundStyle(.secondary)
                        }
                    }
                
                Spacer()
                Button {
                    if text.isEmpty {
                        return
                    }
                    send(text)
                } label: {
                    ZStack {
                        Circle()
                            .fill(.accent)
                            .frame(width: 30, height: 30)
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.basicsecondary)
                    }
                }
            }
            .animation(.smooth, value: text)
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

fileprivate struct ChatItemView: View {
    
    let chat: Chat
    let chatUser: UserDTO
    
    var body: some View {
        if chat.sender == chatUser.id {
            OtherChat(chat: chat)
        } else {
            MyChat(chat: chat, chatUser: chatUser)
        }
    }
}

fileprivate struct MyChat: View {
    
    let chat: Chat
    let chatUser: UserDTO
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                if !chat.readBy.contains(where: { $0 == chatUser.id }) {
                    Text("1")
                        .transition(.opacity)
                        .font(.caption)
                        .foregroundStyle(.accent)

                }
                Text(chat.createAt.chatTimeFormatted)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .animation(.smooth, value: chat.readBy)
            Text(chat.message)
                .foregroundStyle(.basic)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.accent.opacity(0.7))
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

fileprivate struct OtherChat: View {
    
    let chat: Chat
    
    var body: some View {
        HStack {
            Text(chat.message)
                .foregroundStyle(.basic)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(uiColor: .systemGray6))
                .clipShape(.rect(cornerRadius: 12))
            VStack(alignment: .leading) {
                Spacer()
                Text(chat.createAt.chatTimeFormatted)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
}

fileprivate struct ChatTopBar: View {
    let user: UserDTO
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundStyle(.basic)
                    .bold()
            }
            Spacer()
            DefaultProfileView(profileUrl: user.profileImageUrl)
            Text(user.nickName)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatDetailView(chatUser: .init(nickName: "Dongkyung", positions: []))
}
