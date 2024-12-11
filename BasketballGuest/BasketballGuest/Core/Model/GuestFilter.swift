//
//  GuestFilter.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/8/24.
//

import Foundation
import CoreLocation

struct GuestFilter {
    var isNearBy: Bool = false
    var defaultLocation: CLLocationCoordinate2D?
    var radiusInMeters: Double = 10000 // 10km
    var selectedDate: Date?
    var selectedPosition: [Position] = []
    var limit: Int = 10
}
