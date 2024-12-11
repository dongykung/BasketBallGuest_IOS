//
//  GuestView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct GuestView: View {
    
    @StateObject private var viewModel: GuestViewModel = GuestViewModel()
    @State private var path: NavigationPath = NavigationPath()
    @State private var isCreateGuest: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                switch viewModel.loadState {
                case .none, .completed:
                    GuestListView(path: $path, viewModel: viewModel)
                case .loading:
                    LoadingView()
                case .failed:
                    ErrorView {
                        Task {
                            await viewModel.fetchGuestPost()
                        }
                    }
                }
            }
            .navigationTitle("게스트")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isCreateGuest) {
                CreateGuestContainerView()
            }
            .navigationDestination(for: GuestPost.self) { post in
                EmptyView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PlusButton {
                        isCreateGuest.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GuestView()
    }
}
