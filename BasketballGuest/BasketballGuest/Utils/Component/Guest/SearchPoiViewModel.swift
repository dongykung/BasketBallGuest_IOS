//
//  SearchPoiViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import Combine
import Factory
import Foundation

class SearchPoiViewModel: ObservableObject {
    
    @Injected(\.poiService) private var poiService
    @Published var searchKeyword: String = ""
    @Published var pois: [Poi] = []
    @Published var searchState: SearchState = .none
    @Published var isPagingLoading: LoadState = .none
    private var page: Int = 1
    private var count: Int = 20
    private var isPagination: Bool = false
    private var canLoadMore: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setUpSearchKeywordDebounce()
    }
    
    func setUpSearchKeywordDebounce() {
        $searchKeyword
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] keyword in
                guard let self = self else { return }
                resetSearch()
                if keyword.isEmpty {
                    return
                }
                searchPoi(page: page, keyword: keyword)
            }
            .store(in: &cancellables)
    }
    
    func resetSearch() {
        print("reset")
        page = 1
        canLoadMore = true
        searchState = .none
        isPagingLoading = .none
        isPagination = false
        pois.removeAll()
    }
    
    func searchPoi(page: Int, keyword: String) {
        
        setLoadingState()
        
        poiService.fetchPOIs(page: page, count: count, searchKeyword: keyword)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case .decodingFailed:
                        self.searchState = .empty
                    default:
                        self.setSearchErrorState(msg: error.errorDescription)
                    }
                }
            } receiveValue: { [weak self] pois in
                guard let self = self else { return }
                self.canLoadMore = pois.count == self.count
                setSearchSuccess(pois: pois)
            }
            .store(in: &cancellables)
    }
    
    func setLoadingState() {
        if isPagination {
            isPagingLoading = .loading
        } else {
            searchState = .loading
        }
    }
    
    func setSearchErrorState(msg: String) {
        if isPagination {
            isPagingLoading = .failed
        } else {
            searchState = .failed
        }
    }
    
    func setSearchSuccess(pois: [Poi]) {
        if isPagination {
            isPagingLoading = .completed
            self.pois += pois
        } else {
            searchState = .completed
            self.pois = pois
        }
    }
    
    func retrySearch() {
        searchPoi(page: page, keyword: searchKeyword)
    }
    
    func loadMoreIfNeeded(currentPoi poi: Poi) {
        guard let lastPoi = pois.last else { return }
        guard canLoadMore else { return }
        guard isPagingLoading != .loading && isPagingLoading != .failed else { return }
        if lastPoi.id == poi.id {
            print("paging")
            self.page += 1
            self.isPagination = true
            retrySearch()
        }
    }
}
