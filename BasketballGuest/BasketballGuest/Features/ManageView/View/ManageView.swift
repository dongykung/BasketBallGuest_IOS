//
//  ManageView.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/4/25.
//

import SwiftUI

struct ManageView: View {
  
    @StateObject private var viewModel: ManageViewModel = ManageViewModel()
    @State private var path: NavigationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                topBar
                Divider()
                    .shadow(radius: 2)
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: sectionBar) {
                            switch viewModel.section {
                            case .myApply:
                                MyParticipantView(viewModel: viewModel, path: $path)
                            case .myPost:
                                MyPostView(viewModel: viewModel, path: $path)
                            }
                        }
                    }
                }
                .animation(.smooth, value: viewModel.section)
                .refreshable {
                    Task{
                        await viewModel.refresh()
                    }
                }
            }
            .toastView(toast: $viewModel.toast)
            .navigationDestination(for: GuestPost.self) { post in
                GuestDetailView(viewModel: .init(path: path, post: post)) {
                    Task {
                        await viewModel.fetchMyPost()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var topBar: some View {
        HStack {
            Text("관리")
                .font(.semibold16)
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private var sectionBar: some View {
        HStack {
            VStack {
                Button {
                    viewModel.section = .myApply
                } label: {
                    Text("내 신청내역")
                        .padding()
                        .foregroundStyle(viewModel.section == .myApply ? .accent : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .foregroundStyle(viewModel.section == .myApply ? .basic : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                
            }
            VStack {
                Button {
                    viewModel.section = .myPost
                } label: {
                    Text("내 작성글")
                        .padding()
                        .foregroundStyle(viewModel.section == .myPost ? .accent : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .foregroundStyle(viewModel.section == .myPost ? .basic : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                
            }
        }
        .background(.basicsecondary)
        .animation(.smooth, value: viewModel.section)
    }
}

#Preview {
    ManageView()
}
