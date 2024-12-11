//
//  CreateGuestContainerView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct CreateGuestContainerView: View {
    
    @StateObject private var viewModel: CreateGuestViewModel = CreateGuestViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                CreateGuestTopBar(type: viewModel.createStep) {
                    if viewModel.createStep == .description {
                        dismiss()
                        return
                    }
                    viewModel.goBack()
                }
                .padding(.bottom, 12)
                
                ProgressView(value: viewModel.createStep.rawValue, total: 1.0)
                    .progressViewStyle(.linear)
                    .tint(.orange)
                    .padding(.bottom)
                
                switch viewModel.createStep {
                case .description:
                    GuestDescriptionView(viewModel: viewModel.guestDescriptionViewModel) {
                        viewModel.moveToDate()
                    }
                    .transition(.opacity)
                case .date:
                    GuestDateView(viewModel: viewModel.guestDateViewModel) {
                        viewModel.moveToPosition()
                    }
                    .transition(.opacity)
                case .position:
                    GuestPositionView(viewModel: viewModel.guestPositionViewModel) {
                        viewModel.moveToAddress()
                    }
                    .transition(.opacity)
                case .address:
                    GuestPlaceView(viewModel: viewModel.guestPlaceViewModel,
                                   toast: $viewModel.toast,
                                   loadState: $viewModel.loadState
                    ) {
                        Task {
                            await viewModel.uploadGuestPost()
                        }
                    }
                    .transition(.opacity)
                }
                
            }
            .onChange(of: viewModel.loadState) { loadState in
                if loadState == .completed {
                    dismiss()
                }
            }
            .animation(.smooth, value: viewModel.createStep)
            .padding()
        }
    }
}

fileprivate struct CreateGuestTopBar: View {
    
    let type: CreateGuestStep
    let action: () -> Void
    
    init(type: CreateGuestStep, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: type == .description ? "xmark" : "chevron.left")
                    .tint(.basic)
                    .bold()
            }
            Spacer()
        }
        .overlay {
            Text("구인 작성")
                .font(.semibold16)
        }
    }
}

#Preview {
    CreateGuestContainerView()
}
