//
//  calculateCoordinateBounds.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/8/24.
//

import Foundation
import CoreLocation

struct CoordinateBounds {
    let minLatitude: Double
    let maxLatitude: Double
    let minLongitude: Double
    let maxLongitude: Double
}


func calculateCoordinateBounds(center: CLLocationCoordinate2D, radiusInMeters: Double) -> CoordinateBounds {
    let earthRadius = 6371.0 // Earth's radius in kilometers
    let radiusInKm = radiusInMeters / 1000.0
    
    let deltaLatitude = (radiusInKm / earthRadius) * (180.0 / .pi)
    let deltaLongitude = (radiusInKm / earthRadius) * (180.0 / .pi) / cos(center.latitude * .pi / 180)
    
    let minLat = center.latitude - deltaLatitude
    let maxLat = center.latitude + deltaLatitude
    let minLng = center.longitude - deltaLongitude
    let maxLng = center.longitude + deltaLongitude
    
    return CoordinateBounds(minLatitude: minLat, maxLatitude: maxLat, minLongitude: minLng, maxLongitude: maxLng)
}
