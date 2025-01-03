//
//  MyPageViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/31/24.
//

import Factory
import FirebaseStorage
import FirebaseAuth
import Foundation
import _PhotosUI_SwiftUI

class MyPageViewModel: ObservableObject {
    
    private let storageRef = Storage.storage().reference()
    
    @Injected(\.userService) private var userService
    @Published var user: UserDTO?
    @Published var loadState: LoadState = .none
    @Published var updateLoadState: LoadState = .none
    @Published var toast: Toast?
    
    init() {
        Task{
            await fetchUser()
        }
    }
    
    func fetchUser() async {
        print("fetchUser")
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        await updateLoadState(state: .loading)
        do {
            let userDTO = try await userService.fetchUserData(userId: myUid)
            await updateUser(userDTO: userDTO)
            await updateLoadState(state: .completed)
        } catch {
            await updateLoadState(state: .failed)
        }
    }
    
    func updateUserProfile(photo: PhotosPickerItem) async {
        guard let myUid = Auth.auth().currentUser?.uid else {
            toast = Toast(style: .warning, message: "로그인 정보를 잃었습니다 재로그인 후 시도해 주세요.")
            return
        }
        await updateUpdateLoadState(state: .loading)
        do {
            let uiImage = try await convertPickerItemToUIImage(photo: photo)
            
            let imageData = try convertUIImageToData(image: uiImage)
            
            let userProfileUrl = try await uploadImageToFireStorage(data: imageData, myUid: myUid)
            try await userService.updateProfileImage(urlString: userProfileUrl, myUid: myUid)
            DispatchQueue.main.async {
                self.user?.profileImageUrl = userProfileUrl
                self.updateLoadState = .completed
            }
        } catch {
            await handleError(error: error)
            await updateUpdateLoadState(state: .failed)
        }
    }
    
    private func convertPickerItemToUIImage(photo: PhotosPickerItem) async throws -> UIImage {
        guard let imageData = try await photo.loadTransferable(type: Data.self),
              let image = UIImage(data: imageData) else {
            throw PhotoError.convertError
        }
        return image
    }
    
    // UIImage를 JPEG Data로 변환
    private func convertUIImageToData(image: UIImage) throws -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            throw PhotoError.convertError
        }
        return imageData
    }
    
    private func uploadImageToFireStorage(data: Data, myUid: String) async throws -> String {
        do {
            let ref = storageRef.child("User").child(myUid).child(myUid)
            let _ = try await ref.putDataAsync(data)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            throw PhotoError.uploadError
        }
    }
    
    func updateBodyInfo(height: Int?, weight: Int?) async {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        guard let height = height, let weight else { return }
        do {
            await updateUpdateLoadState(state: .loading)
            try await userService.updateBodyInfo(height: height, weight: weight, myUid: myUid)
            DispatchQueue.main.async {
                self.updateLoadState = .completed
                self.user?.height = height
                self.user?.weight = weight
            }
        } catch {
            await updateUpdateLoadState(state: .failed)
            await showToast(msg: "수정에 실패했습니다 다시 시도해 주세요.")
        }
    }
    
    @MainActor
    func updateUser(userDTO: UserDTO) {
        user = userDTO
    }
    
    @MainActor
    func updateLoadState(state: LoadState) {
        loadState = state
    }
    
    @MainActor
    func updateUpdateLoadState(state: LoadState) {
        updateLoadState = state
    }
    
    @MainActor
    func showToast(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
    
    @MainActor
    func handleError(error: Error) {
        if let photoError = error as? PhotoError {
            showToast(msg: photoError.errorMessage)
        }
        print(error.localizedDescription)
    }
    
}

enum PhotoError: Error {
    case convertError
    case uploadError
    
    var errorMessage: String {
        switch self {
        case .convertError:
            "지원하지 않는 이미지 형식입니다."
        case .uploadError:
            "이미지 업로드에 실패했습니다 다시 시도해 주세요."
        }
    }
}
