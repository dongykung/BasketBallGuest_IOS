//
//  Position.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import Foundation

enum Position: String, CaseIterable, Identifiable, Codable {
    case pointGuard = "포인트 가드"
    case shootingGuard = "슈팅 가드"
    case smallForward = "스몰 포워드"
    case powerForward = "파워 포워드"
    case center = "센터"
    case irrelevant = "무관"
    
    var id: String { self.rawValue }
    
    static let positionData: [Position] = [.pointGuard, .shootingGuard, .smallForward, .powerForward, .center]
    
    var englishName: String {
        switch self {
        case .pointGuard:
            "PG"
        case .shootingGuard:
            "SG"
        case .smallForward:
            "SF"
        case .powerForward:
            "PF"
        case .center:
            "C"
        case .irrelevant:
            "irrelevant"
        }
    }
}
