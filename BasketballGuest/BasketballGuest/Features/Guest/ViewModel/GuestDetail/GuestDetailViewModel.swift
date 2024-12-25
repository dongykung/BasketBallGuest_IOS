//
//  GuestDetailViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/11/24.
//

import Factory
import SwiftUI

class GuestDetailViewModel: ObservableObject {
    
    @Injected(\.userService) private var userService
    @Published var guestUser: UserDTO?
    @Published var toast: Toast?
    @Published var userLoadState: LoadState = .none
    private var path: NavigationPath
    
    init(path: NavigationPath) {
        self.path = path
    }
    
    func fetchUserInfo(userId: String) {
        
        self.userLoadState = .loading
        
        Task {
            do {
                let userDTO = try await userService.fetchUserData(userId: userId)
                await updateUserInfo(uesrDTO: userDTO)
                DispatchQueue.main.async {
                    self.userLoadState = .completed
                }
            } catch let error as UserError {
                print(error.errorDescription ?? "")
                toast = Toast(style: .warning, message: "유저 정보를 찾을 수 없습니다.")
                path.removeLast()
            } catch {
                DispatchQueue.main.async {
                    self.userLoadState = .failed
                    self.toast = Toast(style: .warning, message: "유저 정보를 가져오지 못했습니다, 다시 시도해 주세요.")
                }
            }
        }
    }
    
    @MainActor
    func updateUserInfo(uesrDTO: UserDTO) {
        guestUser = uesrDTO
    }
}
