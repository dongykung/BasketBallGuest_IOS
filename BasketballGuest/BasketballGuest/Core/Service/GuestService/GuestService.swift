//
//  GuestService.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import FirebaseFirestore
import Foundation

protocol GuestService {
    func uploadGuestPost(guestPost: GuestPost) async throws
    func getDefaultGuestPost(with filter: GuestFilter, lastDocument: DocumentSnapshot?) async throws -> (posts: [GuestPost], lastDocument: DocumentSnapshot?)
}

final class GuestServiceImpl: GuestService {
    
    private let db = Firestore.firestore()
    
    func uploadGuestPost(guestPost: GuestPost) async throws {
        do {
            let guestPostEncode = try Firestore.Encoder().encode(guestPost)
            try await db.collection("Guest").addDocument(data: guestPostEncode)
        } catch {
            throw error
        }
    }
    
    func getDefaultGuestPost(with filter: GuestFilter, lastDocument: DocumentSnapshot?) async throws -> (posts: [GuestPost], lastDocument: DocumentSnapshot?) {
        do {
            print("가져오기")
            let query: Query = buildQuery(with: filter, lastDocument: lastDocument)
            let documentSnapshot = try await query.getDocuments().documents
            let posts = try documentSnapshot.compactMap { try $0.data(as: GuestPost.self) }
            let lastDoc = documentSnapshot.last
            return (posts, lastDoc)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func buildQuery(with filter: GuestFilter, lastDocument: DocumentSnapshot?) -> Query {
        var query: Query = db.collection("Guest")
            .order(by: "startDate", descending: false)
            .limit(to: filter.limit)
        
        if filter.isNearBy, let center = filter.defaultLocation {
            print("현재 내위치 = \(center.latitude), \(center.longitude)")
            let bounds = calculateCoordinateBounds(center: center, radiusInMeters: filter.radiusInMeters)
            print("maxLatitude = \(bounds.maxLatitude)")
            print("minLatitude = \(bounds.minLatitude)")
            print("maxLongitude = \(bounds.maxLongitude)")
            print("minLongitude = \(bounds.minLongitude)")
            query = query
                .whereField("lng", isGreaterThanOrEqualTo: bounds.minLongitude)
                .whereField("lng", isLessThanOrEqualTo: bounds.maxLongitude)
                .whereField("lat", isGreaterThanOrEqualTo: bounds.minLatitude)
                .whereField("lat", isLessThanOrEqualTo: bounds.maxLatitude)
        }
        
        if let date = filter.selectedDate {
            print("날짜필터 추가")
            let calendar = Calendar.current
            let date = calendar.startOfDay(for: date)
            query = query
                .whereField("date", isEqualTo: date)
        } else {
            query = query.whereField("startDate", isGreaterThan: Date())
        }
        
        if !filter.selectedPosition.isEmpty {
            var filterData = filter.selectedPosition.map { $0.rawValue }
            filterData.append(Position.irrelevant.rawValue)
            query = query.whereField("positions", arrayContainsAny: filterData)
        }
        
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        return query
    }
    
}
