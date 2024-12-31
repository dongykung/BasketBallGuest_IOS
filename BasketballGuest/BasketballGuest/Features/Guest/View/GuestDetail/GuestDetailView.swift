//
//  GuestDetailView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/11/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct GuestDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var chatUser: UserDTO? = nil
    @StateObject var viewModel: GuestDetailViewModel
    @State private var isManagementPage: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text(viewModel.post.title)
                        .font(.semibold24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    switch viewModel.userLoadState {
                    case .loading, .none:
                        UserInfoLoadingView()
                            .transition(.opacity)
                    case .completed:
                        UserInfoSection(userData: viewModel.guestUser) { user in
                            chatUser = user
                        }
                        .transition(.opacity)
                    case .failed:
                        UserInfoErrorView() {
                            Task {
                                await viewModel.fetchUserInfo(userId: viewModel.post.writerUid)
                            }
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.smooth, value: viewModel.userLoadState)
                MapView(center: viewModel.post.location, annotationItems: [.init(name: viewModel.post.placeName, coordinate: viewModel.post.location)])
                    .frame(height: 200)
                
                GuestDetailInfoView(post: viewModel.post) {
                    viewModel.toast = Toast(style: .success, message: "주소를 복사했습니다.")
                }
                Spacer()
                    .frame(height: 50)
            }
            .refreshable {
                Task {
                    await viewModel.refreshPostData()
                }
            }
            .overlay(alignment: .bottom) {
                PostApplyButton(
                    loadState: viewModel.userStatusState,
                    guestStatus: viewModel.userState
                ) {
                    Task {
                        await viewModel.fetchUserStatus(postId: viewModel.post.documentId ?? "", userId: viewModel.post.writerUid)
                    }
                } action: { status in
                    switch status {
                    case .owner: // TODO: 신청자 관리
                        isManagementPage.toggle()
                    case .guest: // TODO: 게스트 취소 얼럿
                        return
                    case .apply: // TODO: 신청취소
                        viewModel.setApplyCnacelUserStatus(postId: viewModel.post.documentId ?? "")
                    case .rejected, .none: // TODO: 신청하기
                        viewModel.setApplyUserStatus(postId: viewModel.post.documentId ?? "")
                    }
                }
            }
            .fullScreenCover(item: $chatUser) { user in
                ChatDetailView(chatUser: user)
            }
            .fullScreenCover(isPresented: $isManagementPage) {
                GuestAdminView(postId: viewModel.post.documentId ?? "")
            }
            .toastView(toast: $viewModel.toast)
            .navigationTitle("모집 상세")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.basic)
                            .bold()
                    }
                }
            }
            .task {
                async let _ = viewModel.fetchUserInfo(userId: viewModel.post.writerUid)
                async let _ = viewModel.fetchUserStatus(postId: viewModel.post.documentId ?? "", userId: viewModel.post.writerUid)
            }
            
        }
    }
}

fileprivate struct UserInfoLoadingView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 50, height: 50)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 100, height: 30)
            Spacer()
        }
        .padding(.horizontal)
    }
}

fileprivate struct UserInfoErrorView: View {
    let action: () -> Void
    var body: some View {
        HStack {
            Text("유저 정보를 불러오는데 실패했습니다 다시 시도해 주세요.")
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: "arrow.clockwise.circle")
            }
        }
        .padding(.horizontal)
    }
}

struct UserInfoSection: View {
    
    let userData: UserDTO?
    let action: (UserDTO) -> Void
    
    var body: some View {
        HStack {
            DefaultProfileView(profileUrl: userData?.profileImageUrl)
            Text(userData?.nickName ?? "")
            Spacer()
            Button {
                if let userDTO = userData {
                    action(userDTO)
                }
            } label: {
                if userData == nil {
                    ProgressView()
                } else {
                    if (Auth.auth().currentUser?.uid != userData?.id) {
                        Text("채팅")
                            .foregroundStyle(.blue)
                            .padding(.horizontal,8)
                            .padding(.vertical,6)
                            .background(Color(uiColor: .systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .disabled(userData == nil || Auth.auth().currentUser?.uid == userData?.id)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        GuestDetailView(viewModel: .init(path: .init(), post: dummyPost))
    }
}
