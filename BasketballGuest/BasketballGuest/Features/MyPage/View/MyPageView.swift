//
//  MyPageView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI
import PhotosUI

struct MyPageView: View {
    @StateObject private var viewModel: MyPageViewModel = MyPageViewModel()
    @State private var selectedPhotos: PhotosPickerItem?
    @State private var heightChangeSheet: Bool = false
    @EnvironmentObject private var authStore: AuthStore
    var body: some View {
        NavigationStack {
            VStack {
                topBar
                
                Divider()
                    .shadow(radius: 2)
                    .padding(.bottom)
                
                switch viewModel.loadState {
                case .none, .loading:
                    LoadingView()
                case .completed:
                    if let user = viewModel.user {
                        MyInfoView(user: user)
                            .padding(.bottom)
                    }
                    profileEditButotn
                    heightChangeButton
                case .failed:
                    ErrorView {
                        Task {
                            await viewModel.fetchUser()
                        }
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $heightChangeSheet) {
                BodyInfoChangeSheet(
                    height: viewModel.user?.height,
                    weight: viewModel.user?.weight
                ) { height, weight in
                    Task {
                        await viewModel.updateBodyInfo(height: height, weight: weight)
                    }
                }
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.hidden)
                .padding(.horizontal)
            }
            .overlay {
                if viewModel.updateLoadState == .loading {
                    ProgressView()
                }
            }
            .toastView(toast: $viewModel.toast)
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            Text("내 프로필")
                .font(.semibold16)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "line.3.horizontal")
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var profileEditButotn: some View {
        PhotosPicker(selection: $selectedPhotos, matching: .images) {
            Text("프로필 사진 변경")
                .modifier(UserUpdateModifier())
        }
        .padding(.horizontal)
        .onChange(of: selectedPhotos) { newPhoto in
            if let photo = newPhoto {
                Task {
                    await viewModel.updateUserProfile(photo: photo)
                }
            }
        }
    }
    
    @ViewBuilder
    private var heightChangeButton: some View {
        Button {
            heightChangeSheet.toggle()
        } label: {
            Text("신장/체중 설정")
                .modifier(UserUpdateModifier())
                .padding(.horizontal)
        }
    }
}

fileprivate struct MyInfoView: View {
    let user: UserDTO
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 8) {
                DefaultProfileView(profileUrl: user.profileImageUrl, frame: 55)
                
                Text(user.nickName)
                    .font(.regular18)
                Spacer()
                VStack(alignment: .leading) {
                    if let height = user.height {
                        Text("신장: \(height)cm")
                            .font(.regular14)
                    }
                    if let weight = user.weight {
                        Text("체중: \(weight)kg ")
                            .font(.regular14)
                    }
                    
                }
            }
            FlowLayout {
                ForEach(user.positions, id: \.id) { position in
                    PostChip(position: position)
                        .padding(6)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MyPageView()
        .environmentObject(AuthStore())
}
