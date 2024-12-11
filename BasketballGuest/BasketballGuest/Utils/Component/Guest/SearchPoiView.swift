//
//  SearchPoiSheet.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import SwiftUI

struct SearchPoiView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SearchPoiViewModel = SearchPoiViewModel()
    let action: (Poi) -> Void
    
    var body: some View {
        VStack {
            SearchSheetTobBar {
                dismiss()
            }
            
            SearchTextField(placeHolder: "장소명 또는 주소 검색", query: $viewModel.searchKeyword)
                .padding(.horizontal)
                .padding(.bottom)
            
            Rectangle()
                .fill(Color(uiColor: .systemGray6))
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            switch viewModel.searchState {
            case .none, .completed:
                SearchListView
                    .transition(.opacity)
            case .empty:
                SearchEmptyView()
                    .transition(.opacity)
            case .loading:
                LoadingView()
                    .transition(.opacity)
            case .failed:
                ErrorView {
                    viewModel.retrySearch()
                }
                .transition(.opacity)
            }
            Spacer()
        }
        .animation(.smooth, value: viewModel.searchState)
    }
    
    @ViewBuilder
    private var SearchListView: some View {
        List {
            ForEach(viewModel.pois, id: \.pkey) { poi in
                SearchCellView(poi: poi) {
                    action(poi)
                    dismiss()
                }
                .onAppear {
                    viewModel.loadMoreIfNeeded(currentPoi: poi)
                }
            }
            switch viewModel.isPagingLoading {
            case .none, .completed:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            case .failed:
                Button {
                    viewModel.retrySearch()
                } label: {
                    Text("재시도")
                        .font(.regular16)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .animation(.smooth, value: viewModel.isPagingLoading)
        .listStyle(.plain)
    }
}

struct SearchSheetTobBar: View {
    
    let action:() -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "xmark")
                    .tint(.basic)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .overlay {
            Text("장소 검색")
                .font(.semibold20)
        }
    }
}


struct SearchCellView: View {
    
    let poi: Poi
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(poi.name)
                        .lineLimit(1)
                        .font(.regular20)
                    Spacer()
                    if let park = poi.parkFlag {
                        if park == "1" {
                            Image(systemName: "parkingsign.circle")
                                .foregroundStyle(.blue)
                            
                        }
                    }
                }
                
                Text(poi.detailAddress)
                    .font(.regular16)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 6)
        }
    }
}


#Preview {
    SearchPoiView() { poi in }
}
