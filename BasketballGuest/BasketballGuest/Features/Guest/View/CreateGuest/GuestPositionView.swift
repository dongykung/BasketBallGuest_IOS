//
//  GuestPositionView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct GuestPositionView: View {
    
    @ObservedObject private var viewModel: GuestPositionViewModel
    let action: () -> Void
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(viewModel: GuestPositionViewModel, action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("모집 포지션")
                .font(.semibold18)
            
            LazyVGrid(columns: columns) {
                ForEach(Position.allCases, id: \.id) { position in
                    PositionButton(
                        position: position.rawValue,
                        selected: viewModel.selectedPositions.contains(position)) {
                            viewModel.togglePositions(position: position)
                        }
                }
            }
            .animation(.spring, value: viewModel.selectedPositions)
            .padding(.bottom)
            
            Text("모집 인원")
                .font(.semibold18)
            
            HStack {
                Text("인원 수")
                Spacer()
                Text("\(viewModel.memberCount)명")
                Stepper("", value: $viewModel.memberCount, in: 0...10)
                    .labelsHidden()
            }
            
            BasicButton(
                buttonText: .next,
                disabled: viewModel.selectedPositions.isEmpty || viewModel.memberCount == 0
            ) {
                action()
            }
            Spacer()
        }
    }
}

#Preview {
    GuestPositionView(viewModel: .init()) {}
        .padding()
}
