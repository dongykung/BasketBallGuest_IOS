//
//  SignUpContainerView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

struct SignUpContainerView: View {
    
    @StateObject var viewModel: SignUpContainerViewModel
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    viewModel.goBack()
                } label: {
                    Image(systemName: viewModel.signUpStep == .nickName ? "xmark" : "chevron.left")
                        .tint(.basic)
                        .bold()
                }
                Spacer()
            }
            .overlay {
                Text("회원가입")
                    .font(.semibold16)
            }
            .padding(.bottom, 12)
            
            ProgressView(value: viewModel.signUpStep.rawValue, total: 1.0)
                .tint(.orange)
                .progressViewStyle(.linear)
                .padding(.bottom)
            
            switch viewModel.signUpStep {
            case .nickName:
                NickNameView(viewModel: viewModel.nickNameViewModel)
                    .transition(.opacity)
            case .bodyInfo:
                BodyInfoView(viewModel: viewModel.bodyInfoViewModel)
                    .transition(.opacity)
            case .positionInfo:
                PositionInfoView(
                    viewModel: viewModel.positionInfoViewModel,
                    loadState: $viewModel.loadState,
                    toast: $viewModel.toast
                )
                .transition(.opacity)
            }
            Spacer()
        }
        .padding()
        .animation(.smooth, value: viewModel.signUpStep)
    }
}

#Preview {
    NavigationStack {
        SignUpContainerView(viewModel: SignUpContainerViewModel(authStore: AuthStore()))
    }
}
