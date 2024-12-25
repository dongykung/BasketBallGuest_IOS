//
//  generateChatRoomId.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import Foundation

func generateChatRoomId(uid1: String, uid2: String) -> String {
    return uid1 < uid2 ? "\(uid1)_\(uid2)" : "\(uid2)_\(uid1)"
}
