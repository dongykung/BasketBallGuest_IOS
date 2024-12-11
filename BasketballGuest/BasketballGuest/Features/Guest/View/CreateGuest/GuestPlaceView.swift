//
//  GuestPlaceView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct GuestPlaceView: View {
    @State private var isSearchSheet: Bool = false
    @ObservedObject private var viewModel: GuestPlaceViewModel
    @Binding private var toast: Toast?
    @Binding private var loadState: LoadState
    private let action: () -> Void
    
    init(
        viewModel: GuestPlaceViewModel,
        toast: Binding<Toast?>,
        loadState: Binding<LoadState>,
        action: @escaping () -> Void
    )
    {
        self.viewModel = viewModel
        self._toast = toast
        self._loadState = loadState
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("장소 선택")
                .font(.semibold18)
            Button {
                isSearchSheet.toggle()
            } label: {
                Text(viewModel.placeName)
                    .foregroundStyle(.basic)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 1)
                    }
                    .overlay(alignment: .leading) {
                        if viewModel.placeName.isEmpty {
                            Text("장소를 입력해 주세요.")
                                .offset(x: 12)
                                .foregroundStyle(.gray)
                        }
                    }
            }
            .padding(.bottom)
            
            BasicButton(
                buttonText: .complete,
                loading: loadState == .loading,
                disabled: viewModel.placeName.isEmpty || loadState == .loading
            ) {
                action()
            }
            Spacer()
        }
        .sheet(isPresented: $isSearchSheet) {
            SearchPoiView { poi in
                viewModel.setPoiInfo(poi: poi)
            }
            .interactiveDismissDisabled()
            .presentationDetents([.large])
        }
        .toastView(toast: $toast)
    }
}

#Preview {
    GuestPlaceView(viewModel: .init(), toast: .constant(nil), loadState: .constant(.loading)) {
        
    }
}
