//
//  CreateGuestViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import Factory
import FirebaseAuth
import Foundation

class CreateGuestViewModel: ObservableObject {
    
    @Injected(\.guestService) private var guestService
    @Published var createStep: CreateGuestStep = .description
    @Published var loadState: LoadState = .none
    @Published var toast: Toast?
    
    lazy var guestDescriptionViewModel: GuestDescriptionViewModel = {
        GuestDescriptionViewModel()
    }()
    
    lazy var guestDateViewModel: GuestDateViewModel = {
        GuestDateViewModel()
    }()
    
    lazy var guestPositionViewModel: GuestPositionViewModel = {
        GuestPositionViewModel()
    }()
    
    lazy var guestPlaceViewModel: GuestPlaceViewModel = {
        GuestPlaceViewModel()
    }()
    
    func goBack() {
        switch createStep {
        case .description:
            return
        case .date:
            moveToDescription()
        case .position:
            moveToDate()
        case .address:
            moveToPosition()
        }
    }
    
    func moveToDescription() {
        createStep = .description
    }
    
    func moveToDate() {
        createStep = .date
    }
    
    func moveToPosition() {
        createStep = .position
    }
    
    func moveToAddress() {
        createStep = .address
    }
    
    func uploadGuestPost() async {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let guestPost = createGuestPost(userUid: userUid)
        DispatchQueue.main.async {
            self.loadState = .loading
        }
        do {
            try await guestService.uploadGuestPost(guestPost: guestPost)
            DispatchQueue.main.async {
                self.loadState = .completed
                print("success")
            }
        } catch {
            print("실패함")
            DispatchQueue.main.async {
                self.loadState =  .failed
                self.toast = Toast(style: .warning, message: "게시글 등록에 실패했습니다. 다시 시도해 주세요.")
            }
        }
    }
    
    func createGuestPost(userUid: String) -> GuestPost {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: guestDateViewModel.startTime)
        return GuestPost(
            writerUid: userUid,
            title: guestDescriptionViewModel.title,
            description: guestDescriptionViewModel.description,
            date: date,
            startDate: guestDateViewModel.startTime,
            endDate: guestDateViewModel.endTime,
            memberCount: guestPositionViewModel.memberCount,
            positions: Array(guestPositionViewModel.selectedPositions),
            lat: guestPlaceViewModel.location.latitude,
            lng: guestPlaceViewModel.location.longitude,
            placeName: guestPlaceViewModel.placeName,
            placeAddress: guestPlaceViewModel.placeAddress,
            parkFlag: guestPlaceViewModel.parkFlag,
            currentMemberCount: nil
        )
    }
}
