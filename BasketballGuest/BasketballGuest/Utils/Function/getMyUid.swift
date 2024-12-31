//
//  getMyUid.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import Foundation
import FirebaseAuth

func getMyUid() -> String? {
    return Auth.auth().currentUser?.uid
}
