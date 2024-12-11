//
//  POIService.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import Combine
import Foundation

protocol POIService {
    func fetchPOIs(page: Int, count: Int, searchKeyword: String) -> AnyPublisher<[Poi], POIServiceError>
}

final class POIServiceImpl: POIService {
    
    private let session: URLSession
    private let apiVersion = "1"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPOIs(page: Int, count: Int, searchKeyword: String) -> AnyPublisher<[Poi], POIServiceError> {
        
        guard let baseUrl = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              let appKey = Bundle.main.infoDictionary?["TMAP_API_KEY"] as? String else {
            return Fail(error: POIServiceError.invalidConfig)
                .eraseToAnyPublisher()
        }
        
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = "/tmap/pois"
        components.queryItems = [
            URLQueryItem(name: "version", value: apiVersion),
            URLQueryItem(name: "searchKeyword", value: searchKeyword),
            URLQueryItem(name: "appKey", value: appKey),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "count", value: "\(count)")
        ]
        
        guard let url = components.url else {
            return Fail(error: POIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .mapError { _ in POIServiceError.networkError }
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw POIServiceError.unknown
                }
                print("\(response.statusCode)")
                return output.data
            }
            .mapError { error in
                error as? POIServiceError ?? POIServiceError.unknown
            }
            .decode(type: SearchPlace.self, decoder: JSONDecoder())
            .mapError { _ in POIServiceError.decodingFailed }
            .map { $0.searchPoiInfo.pois.poi }
            .eraseToAnyPublisher()
    }
    
}
