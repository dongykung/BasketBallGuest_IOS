//
//  GuestAdminView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import SwiftUI

struct GuestAdminView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GuestAdminViewModel = GuestAdminViewModel()
    @State private var isEmissionAlert: Bool = false
    @State private var emissionName: String = ""
    @State private var emissionUserId: String = ""
    let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
    var body: some View {
        VStack {
            ApplyTopBar() {
                dismiss()
            }
            switch viewModel.loadState {
            case .none, .loading:
                LoadingView()
            case .completed:
                applyList
            case .failed:
                ErrorView {
                    viewModel.observeGuestAdmin(postId: postId)
                }
            }
        }
        .toastView(toast: $viewModel.toast)
        .onAppear {
            viewModel.observeGuestAdmin(postId: postId)
        }
        .alert(isPresented: $isEmissionAlert) {
            let cancelButton = Alert.Button.destructive(Text("방출하기")) {
                Task {
                    await viewModel.emissionApplyGuest(postId: postId, userId: emissionUserId, nickName: emissionName)
                }
            }
            let emissionButton = Alert.Button.cancel(Text("취소")) {
                //print("secondary button pressed")
            }
            return Alert(title: Text("게스트 방출"), message: Text("\(emissionName)님을 방출하겠습니까?"), primaryButton: cancelButton, secondaryButton: emissionButton)
        }
    }
    
    @ViewBuilder
    var applyList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.managementGuest, id: \.status.documentId) { applyStatus in
                    if applyStatus.status.status != .rejected {
                        ApplyItem(
                            viewModel: viewModel,
                            applyStatus: applyStatus,
                            postId: postId
                        ) {
                            emissionName = applyStatus.user.nickName
                            emissionUserId = applyStatus.user.id ?? ""
                            isEmissionAlert.toggle()
                        }
                    }
                }
            }
        }
        .animation(.smooth, value: viewModel.managementGuest.count)
    }
}

struct ApplyTopBar: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(action: action ) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundStyle(.basic)
                    .bold()
            }
            Spacer()
        }
        .overlay {
            Text("신청자 관리")
                .font(.semibold16)
        }
        .padding()
    }
}

struct ApplyItem: View {
    @ObservedObject var viewModel: GuestAdminViewModel
    let applyStatus: GuestApplyStatus
    let postId: String
    let action: () -> Void
    var body: some View {
        HStack {
            DefaultProfileView(profileUrl: applyStatus.user.profileImageUrl, frame: 60)
            Text(applyStatus.user.nickName)
            if applyStatus.status.status == .guest {
                Text("게스트")
                    .modifier(ChipModifier())
            }
            Spacer()
            switch applyStatus.status.status {
            case .apply, .none:
                confirmWithCancel
            case .guest:
                guestCancel
            default:
                EmptyView()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var confirmWithCancel: some View {
        HStack {
            Button {
                Task {
                    await viewModel.approveApplyGuest(postId: postId, userId: applyStatus.user.id ?? "", nickName: applyStatus.user.nickName)
                }
            } label: {
                Text("승인")
                    .foregroundStyle(.blue)
                    .padding(8)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.trailing, 4)
            
            Button {
                Task {
                    await viewModel.rejectApplyGuest(postId: postId, userId: applyStatus.user.id ?? "", nickName: applyStatus.user.nickName)
                }
            } label: {
                Text("거절")
                    .foregroundStyle(.red)
                    .padding(8)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(.rect(cornerRadius: 12))
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var guestCancel: some View {
        Button(action: action) {
            Text("방출")
                .foregroundStyle(.red)
                .padding(8)
                .background(Color(uiColor: .systemGray6))
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

#Preview {
    GuestAdminView(postId: "")
}
