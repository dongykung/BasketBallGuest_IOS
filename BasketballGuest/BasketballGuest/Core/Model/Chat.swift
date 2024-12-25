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
    var readCount: Int = 1 //읽은 사람 카운트 수
    var createAt: Date = Date()
}

let MAXREADCOUNT: Int = 2
