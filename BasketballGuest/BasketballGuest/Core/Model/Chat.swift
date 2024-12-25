//
//  Chat.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//

import Foundation
import FirebaseFirestore

struct Chat: Codable {
    @DocumentID var id: String?
    var message: String
    var sender: String //보낸 사람의 uid
    var readBy: [String] //읽은 사람 uid
    var createAt: Date = Date()
}

let MAXREADCOUNT: Int = 2
