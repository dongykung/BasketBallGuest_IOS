//
//  NickNameView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

struct NickNameView: View {
    
    @ObservedObject private var viewModel: NickNameViewModel
    @State private var validateMessage: String = ""
    
    init(viewModel: NickNameViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("닉네임 입력")
                .font(.semibold28)
                
            
            Text("앱 내에서 사용하실 닉네임을\n입력해 주세요.")
                .font(.regular18)
                .foregroundStyle(.secondary)
            
            BasicTextField(
                text: $viewModel.nickName,
                placeholder: "닉네임을 입력해 주세요."
            )
            
            if !validateMessage.isEmpty {
                Text(validateMessage)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            BasicButton(
                buttonText: .next,
                loading: viewModel.loadState == .loading,
                disabled: viewModel.nickName.count < 2
            ) {
                if !viewModel.validateNickName() {
                    validateMessage = "닉네임은 2글자 이상이여야 합니다."
                    return
                }
                Task {
                    validateMessage = ""
                    await viewModel.isNicknameAvailable()
                }
            }
            Spacer()
        }
        .toastView(toast: $viewModel.toast)
    }
}


#Preview {
    SignUpContainerView(viewModel: SignUpContainerViewModel(authStore: AuthStore()))
}
