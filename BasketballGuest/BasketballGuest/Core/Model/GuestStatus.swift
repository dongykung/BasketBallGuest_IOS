//
//  GuestStatus.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import Foundation
import FirebaseFirestore

enum GuestStatus: String, Codable {
    case owner
    case guest
    case apply
    case rejected
    case none
}

struct UserStatus: Codable {
    @DocumentID var documentId: String?
    var status: GuestStatus
}
