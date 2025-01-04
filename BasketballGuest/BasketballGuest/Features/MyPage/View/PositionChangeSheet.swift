//
//  PositionChangeSheet.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/4/25.
//

import SwiftUI

struct PositionChangeSheet: View {
    @State private var selectedPosition: Set<Position> = []
    @Environment(\.dismiss) private var dismiss
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let position: [Position]
    let action: ([Position]) -> Void
    
    init(position: [Position], action: @escaping ([Position]) -> Void) {
        self.position = position
        self.action = action
    }
    
    var body: some View {
        VStack {
            topBar
            LazyVGrid(columns: columns) {
                ForEach(Position.allCases, id: \.id) { position in
                    PositionButton(
                        position: position.rawValue,
                        selected: selectedPosition.contains(position)) {
                            positionTapped(position)
                        }
                }
            }
            Spacer()
        }
        .padding()
        .animation(.smooth, value: selectedPosition.count)
        .onAppear {
            selectedPosition = Set(position)
        }
    }
    
    private func positionTapped(_ position: Position) {
        if selectedPosition.contains(position) {
            selectedPosition.remove(position)
        } else {
            if selectedPosition.count >= 3 {
                return
            }
            selectedPosition.insert(position)
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.basic)
                    .bold()
            }
            Spacer()
            Button {
                action(Array(selectedPosition))
                dismiss()
            } label: {
                Text("확인")
                    .bold()
                    .foregroundStyle(.basic)
                    .font(.regular16)
            }
            .disabled(selectedPosition.isEmpty)
        }
        .overlay {
            Text("포지션 변경")
        }
        .padding(.vertical)
    }
}

#Preview {
    PositionChangeSheet(position: [.center]) { _ in}
}
