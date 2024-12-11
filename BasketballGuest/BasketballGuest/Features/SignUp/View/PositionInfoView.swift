//
//  PositionInfoView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct PositionInfoView: View {
    
    @ObservedObject private var viewModel: PositionInfoViewModel
    @Binding private var loadState: LoadState
    @Binding private var toast: Toast?
    let positions = ["슈팅 가드", "포인트 가드", "스몰 포워드", "파워 포워드", "센터"]
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(
        viewModel: PositionInfoViewModel,
        loadState: Binding<LoadState>,
        toast: Binding<Toast?>
    ) {
        self.viewModel = viewModel
        self._loadState = loadState
        self._toast = toast
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("포지션 선택")
                .font(.semibold28)
            
            Text("선호하는 포지션을 선택해 주세요.\n최대 3개까지 선택 가능합니다.")
                .font(.regular18)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns) {
                ForEach(positions, id: \.self) { position in
                    PositionButton(
                        position: position,
                        selected: viewModel.positions.contains(where: { $0 == position })
                    ) {
                        viewModel.positionTapped(position: position)
                    }
                }
            }
            .padding(.bottom)
            
            BasicButton(
                buttonText: .complete,
                loading: loadState == .loading,
                disabled: viewModel.positions.isEmpty
            ) {
                viewModel.nextStep()
            }
            Spacer()
        }
        .toastView(toast: $toast)
    }
}
