//
//  UserDTO.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import FirebaseFirestore
import Foundation

struct UserDTO: Codable {
    @DocumentID var documentId: String?
    var nickName: String
    var height: Int?
    var weight: Int?
    var positions: [String]
    var profileImageUrl: String?
}
