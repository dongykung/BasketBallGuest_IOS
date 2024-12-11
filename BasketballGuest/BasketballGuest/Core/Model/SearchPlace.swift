//
//  SearchPlace.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import Foundation

struct SearchPlace: Codable {
    let searchPoiInfo: SearchPoiInfo
}

struct SearchPoiInfo: Codable {
    let totalCount, count, page: String
    let pois: Pois
}

struct Pois: Codable {
    let poi: [Poi]
}

struct Poi: Codable {
    let id, pkey, name: String
    let noorLat, noorLon: String
    let upperAddrName, middleAddrName: String
    let roadName, firstBuildNo: String
    let parkFlag: String?
    
    var detailAddress: String {
        upperAddrName + " " + middleAddrName + " " + roadName + " " + firstBuildNo
    }
}
