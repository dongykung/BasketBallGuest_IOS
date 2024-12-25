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
    let post: GuestPost
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text(post.title)
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
                            viewModel.fetchUserInfo(userId: post.writerUid)
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.smooth, value: viewModel.userLoadState)
                MapView(center: post.location, annotationItems: [.init(name: post.placeName, coordinate: post.location)])
                    .frame(height: 200)
                
                GuestDetailInfoView(post: post) {
                    viewModel.toast = Toast(style: .success, message: "주소를 복사했습니다.")
                }
            }
            .fullScreenCover(item: $chatUser) { user in
                ChatDetailView(chatUser: user)
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
                            .bold()
                    }
                }
            }
            .onAppear {
                viewModel.fetchUserInfo(userId: post.writerUid)
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
                    Text("채팅")
                        .foregroundStyle(.blue)
                        .padding(.horizontal,8)
                        .padding(.vertical,6)
                        .background(Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .disabled(userData == nil || Auth.auth().currentUser?.uid == userData?.id)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        GuestDetailView(viewModel: .init(path: .init()), post: dummyPost)
    }
}
