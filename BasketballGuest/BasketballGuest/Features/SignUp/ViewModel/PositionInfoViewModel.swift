//
//  PositionInfoVIewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import Foundation

class PositionInfoViewModel: ObservableObject {
    
    @Published var positions: [Position] = []
    @Published var loadState: LoadState = .none
    let moveNextStep: () -> Void
    
    init(moveNextStep: @escaping () -> Void) {
        self.moveNextStep = moveNextStep
    }
    
    
    func positionTapped(position: Position) {
        if let index = positions.firstIndex(where: { $0 == position }) {
            positions.remove(at: index)
        } else {
            if positions.count >= 3 {
                return
            }
            positions.append(position)
        }
    }
    
    func nextStep() {
        moveNextStep()
    }
}
