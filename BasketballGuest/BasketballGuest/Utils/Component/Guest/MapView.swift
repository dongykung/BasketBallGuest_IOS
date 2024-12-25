//
//  MapView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/11/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region: MKCoordinateRegion
    @State private var annotationItems: [Location]
    init(center: CLLocationCoordinate2D, annotationItems: [Location]) {
        self.region = MKCoordinateRegion(center: center, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.annotationItems = annotationItems
    }
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotationItems, annotationContent: { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Image(systemName: "mappin.and.ellipse.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                    Text(location.name)
                        .font(.semibold16)
                }
            }
        })
    }
}

struct Location: Identifiable {
    var id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView(center: .init(latitude: 37.33875766, longitude: 126.9364757), annotationItems: [.init(name: "바스농구", coordinate: .init(latitude: 37.33875766, longitude: 126.9364757))])
}


