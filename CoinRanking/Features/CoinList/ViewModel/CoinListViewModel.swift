//
//  CoinListViewModel.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 19/01/25.
//

import Foundation

class CoinListViewModel {

    private var currentPageOffset: Int = 0
    private let service: CoinListServiceProvider
    var timePeriod: TimePeriod = .oneDay

    private var favoriteIndices: Set<Int> = []

    @Published private(set) var isFetching: Bool = false
    @Published private(set) var coins: [Coin] = []

    init(_ service: CoinListServiceProvider = CoinListService()) {
        self.service = service
    }

    func fetchCoins() async throws {
        guard !isFetching else { return }
        isFetching = true

        let request = self.coinFetchRequest()
        let response = try await self.service.fetchCoinList(request: request)
        isFetching = false
        coins.append(contentsOf: response.data.coins)
        currentPageOffset += 1
    }

    func fetchMoreCoins() async throws {
        try await fetchCoins()
    }

    func coinFetchRequest() -> CoinRequest {
        return CoinRequest.coinList(offset: offSet,
                                    limit: limit,
                                    timePeriod: self.timePeriod.rawValue,
                                    orderBy: "price",
                                    orderDirection: "desc")
    }

    var offSet: Int {
        return currentPageOffset * limit
    }

    var limit: Int { 20 }

    func toggleFavorite(at index: Int) {
            if favoriteIndices.contains(index) {
                favoriteIndices.remove(index)
            } else {
                favoriteIndices.insert(index)
            }
            print("Favorite coins: \(favoriteIndices)")
        }

    func isFavourite(_ index: Int) -> Bool {
        favoriteIndices.contains(index)
    }
}
