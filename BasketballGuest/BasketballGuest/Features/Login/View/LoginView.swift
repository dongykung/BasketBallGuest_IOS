//
//  LoginViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                VStack(spacing: 12) {
                    
                    Spacer()
                        .frame(maxHeight: proxy.size.height * 0.65)
                    
                    
                    SocialButton(socialType: .kakao) {
                        viewModel.kakaoLogin()
                    }
                    
                    SocialButton(socialType: .google) {
                        Task {
                            await viewModel.googleLogin()
                        }
                    }
                    
                    SocialButton(socialType: .apple) {
                        
                    }
                }
                .padding(.top)
                .toastView(toast: $viewModel.toast)
            }
            .overlay(alignment: .center) {
                if viewModel.loadState == .loading {
                    ProgressView()
                        .tint(Color(uiColor: .systemGray3))
                        .scaleEffect(1.5)
                }
            }

            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(authStore: AuthStore()))
}
