//
//  NickNameViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import Factory
import Foundation

class NickNameViewModel: ObservableObject {
    
    @Injected(\.authService) private var authService
    @Published var nickName: String = ""
    @Published var toast: Toast?
    @Published var loadState: LoadState = .none
    let moveNextStep: () -> Void
    
    init( moveNextStep: @escaping () -> Void) {
        self.moveNextStep = moveNextStep
    }
    
    func validateNickName() -> Bool {
        nickName.count >= 2
    }
    
    @MainActor
    func isNicknameAvailable() async {
        self.loadState = .loading
        
        do {
            if try await authService.isNicknameAvailable(nickName: nickName) {
                loadState = .completed
                moveNextStep()
            } else {
                loadState = .none
                showToastMessage(msg: "이미 존재하는 닉네임 입니다.")
            }
        } catch {
            loadState = .failed
            showToastMessage(msg: "닉네임 중복 체크에 실패했습니다. 다시 시도해 주세요.")
        }
    }
    
    func showToastMessage(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
}
