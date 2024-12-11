//
//  GuestPlaceViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import CoreLocation
import Foundation

class GuestPlaceViewModel: ObservableObject {
    @Published var placeName: String = ""
    private(set) var placeAddress: String = ""
    private(set) var parkFlag: String?
    private(set) var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    func setPoiInfo(poi: Poi) {
        placeName = poi.name
        placeAddress = poi.detailAddress
        parkFlag = poi.parkFlag
        location.latitude = Double(poi.noorLat) ?? 0.0
        location.longitude = Double(poi.noorLon) ?? 0.0
    }
}
