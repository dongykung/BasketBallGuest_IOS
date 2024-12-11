//
//  SignUpContainerViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import Factory
import Foundation

class SignUpContainerViewModel: ObservableObject {
    
    @Injected(\.userService) private var userService
    @Published var signUpStep: SignUpStep = .nickName
    @Published var toast: Toast?
    @Published var loadState: LoadState = .none
    
    private var authStore: AuthStore
    
    lazy var nickNameViewModel: NickNameViewModel = {
        let viewModel = NickNameViewModel() { [weak self] in
            self?.moveToBodyInfo()
        }
        return viewModel
    }()
    
    lazy var bodyInfoViewModel: BodyInfoViewModel = {
        let viewModel = BodyInfoViewModel() {
            self.moveToPositionInfo()
        }
        return viewModel
    }()
    
    lazy var positionInfoViewModel: PositionInfoViewModel = {
        let viewModel = PositionInfoViewModel() {
            Task {
                await self.uploadUserData()
            }
        }
        return viewModel
    }()
    
    init(
        authStore: AuthStore
    ) {
        self.authStore = authStore
    }
    
    func goBack() {
        switch signUpStep {
        case .nickName:
            moveToLogin()
        case .bodyInfo:
            moveToNickName()
        case .positionInfo:
            moveToBodyInfo()
        }
    }
    
    func moveToLogin() {
        authStore.authState = .unAuthenticated
    }
    
    func moveToNickName() {
        signUpStep = .nickName
    }
    
    func moveToBodyInfo() {
        signUpStep = .bodyInfo
    }
    
    func moveToPositionInfo() {
        signUpStep = .positionInfo
    }
    
    func createUserDTO() -> UserDTO {
        return UserDTO(
            nickName: nickNameViewModel.nickName,
            height: bodyInfoViewModel.height,
            weight: bodyInfoViewModel.weight,
            positions: positionInfoViewModel.positions
        )
    }
    
    @MainActor
    func uploadUserData() async {
        loadState = .loading
        let user = createUserDTO()
        do {
            _ = try await userService.uploadUserData(user: user)
            loadState = .completed
            authStore.authState = .authenticated
        } catch {
            loadState = .failed
            toast = Toast(style: .warning, message: "회원가입에 실패했습니다. 다시 시도해 주세요.")
        }
    }
    
    deinit {
        print("SignUpContainerVIewModel deinit")
    }
}
