//
//  LocationStore.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/10/24.
//

import Foundation
import CoreLocation

class LocationStore: ObservableObject {
    
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager: CLLocationManager = CLLocationManager()
}
