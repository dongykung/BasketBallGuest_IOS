//
//  LocationStore.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/10/24.
//

import Foundation
import CoreLocation

class LocationStore: NSObject, ObservableObject {
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var rejectAlert: Bool = false
    @Published var authChange: Bool = false
    @Published var toast: Toast?
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if [.authorizedWhenInUse, .authorizedAlways].contains(where: { $0 == self.authorizationStatus }) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.rejectAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
}

extension LocationStore: CLLocationManagerDelegate {
    
    // 권한 상태가 변경되었을 때 호출
      func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
          DispatchQueue.main.async {
              self.authorizationStatus = manager.authorizationStatus
              switch self.authorizationStatus {
              case .restricted, .denied:
                  self.toast = Toast(style: .warning, message: "위치 권한 허용이 필요합니다.")
              case .authorizedAlways, .authorizedWhenInUse:
                  self.locationManager.startUpdatingLocation()
              case .notDetermined:
                  break
              @unknown default:
                  break
              }
          }
      }
    
    // 위치가 업데이트되었을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.userLocation = locations.last?.coordinate
        }
    }
}
