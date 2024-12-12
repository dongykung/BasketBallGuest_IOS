//
//  GuestPost.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import FirebaseFirestore
import Foundation
import CoreLocation

struct GuestPost: Codable, Hashable {
    @DocumentID var documentId: String?
    let writerUid: String
    let title: String
    let description: String
    let date: Date
    let startDate: Date
    let endDate: Date
    let memberCount: Int
    let positions: [Position]
    let lat: Double
    let lng: Double
    let placeName: String
    let placeAddress: String
    let parkFlag: String?
    let currentMemberCount: Int?
    
    var location: CLLocationCoordinate2D {
        .init(latitude: lat, longitude: lng)
    }
}
