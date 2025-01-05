//
//  MyPostView.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/4/25.
//

import SwiftUI

struct MyPostView: View {
    @ObservedObject var viewModel: ManageViewModel
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            switch viewModel.myPostLoadState {
            case .none, .loading:
                LoadingView()
            case .completed:
                MyPostListView
            case .failed:
                ErrorView {
                    Task {
                        await viewModel.fetchMyPost()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var MyPostListView: some View {
        ForEach(viewModel.myPost, id: \.documentId) { post in
            GuestListItemView(post: post) {
                path.append(post)
            }
            .padding(8)
        }
    }
}


#Preview {
    MyPostView(viewModel: .init(), path: .constant(.init()))
}
