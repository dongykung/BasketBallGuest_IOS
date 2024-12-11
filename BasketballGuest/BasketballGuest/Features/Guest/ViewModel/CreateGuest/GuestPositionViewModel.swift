//
//  GuestPositionViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import Foundation

class GuestPositionViewModel: ObservableObject {
    
    @Published var selectedPositions: Set<Position> = []
    @Published var memberCount: Int = 1
    
    func togglePositions(position: Position) {
        if position == .irrelevant {
            toggleIrrelevant()
            return
        }
        
        selectedPositions.remove(.irrelevant)
        
        if selectedPositions.contains(position) {
            selectedPositions.remove(position)
        } else {
            selectedPositions.insert(position)
        }
    }
    
    private func toggleIrrelevant() {
        if selectedPositions.contains(.irrelevant) {
            selectedPositions.remove(.irrelevant)
        } else {
            selectedPositions.removeAll()
            selectedPositions.insert(.irrelevant)
        }
    }
    
    func increaseMember() {
        memberCount += 1
    }
    
    func decreaseMember() {
        memberCount -= 1
    }
}
