//
//  PositionPicker.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct PositionPicker: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var positions: Set<Position> = Set<Position>(Position.allCases)
    @Binding var selectedPositions: [Position]
    let action: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            TobBarSection(title: "포지션 선택") {
                dismiss()
            } action: {
                selectedPositions = Array(positions)
                action()
                dismiss()
            }
            .padding(.vertical)

            Rectangle()
                .fill(Color(uiColor: .systemGray6))
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            List(Position.positionData) { position in
                PositionSelectedView(selected: positions.contains(position), position: position) {
                    positionTapped(position)
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            positions = Set<Position>(selectedPositions)
        }
    }
    
    private func positionTapped(_ position: Position) {
        if positions.contains(position) {
            positions.remove(position)
        } else {
            positions.insert(position)
        }
    }
}

struct PositionSelectedView: View {
    
    let selected: Bool
    let position: Position
    let action: () -> Void
    
    var body: some View {
        Button(action:action) {
            HStack {
                Text(position.rawValue)
                    .foregroundStyle(.basic)
                    .font(.regular20)
                Spacer()
                Image(systemName: selected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.accent)
                    .padding()
            }
        }
    }
}

#Preview {
    PositionPicker(selectedPositions: .constant([.center, .pointGuard])) {}
}
