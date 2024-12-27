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
                    
                }
                .transition(.opacity)
            case .completed:
                ChatListView(text: $viewModel.text, chatList: viewModel.chats) { msg in
                    Task {
                        await viewModel.sendMessage(chatUserUid: chatUser.id ?? "")
                        viewModel.text = ""
                    }
                }
                .transition(.opacity)
            }
        }
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
    let chatList: [Chat]
    let send: (String) -> Void
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatList, id: \.id) { chat in
                        Text(chat.message)
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
