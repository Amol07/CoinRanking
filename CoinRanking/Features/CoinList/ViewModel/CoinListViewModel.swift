//
//  CoinListViewModel.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 19/01/25.
//

import Combine
import Foundation

class CoinListViewModel {

    // MARK: - Private properties
    private var currentPageOffset: Int = 0
    private var subscribers: Set<AnyCancellable> = []
    private let service: CoinListServiceProvider
    private var timePeriod: TimePeriod = .oneDay

    let filterViewModel = FilterViewModel()

    @Published private(set) var isFetching: Bool = false
    @Published private(set) var coins: [Coin] = []

    init(_ service: CoinListServiceProvider = CoinListService()) {
        self.service = service
        self.bindFilterViewModel()
    }

    func fetchCoins() async {
        guard !isFetching else { return }
        isFetching = true

        let request = self.coinFetchRequest()
        do {
            let response = try await self.service.fetchCoinList(request: request)
            isFetching = false
            coins.append(contentsOf: response.data.coins)
            currentPageOffset += 1
        } catch {
            if currentPageOffset == 0 {
                self.coins = []
            }
        }
    }

    func bindFilterViewModel() {
        self.filterViewModel.applyFilterPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.currentPageOffset = 0
                self.coins = []
                Task {
                    await self.fetchCoins()
                }
            }
            .store(in: &subscribers)
    }

    func fetchMoreCoins() async {
        await fetchCoins()
    }

    func coinFetchRequest() -> CoinRequest {
        return CoinRequest.coinList(offset: offSet,
                                    limit: limit,
                                    timePeriod: self.timePeriod.rawValue,
                                    orderBy: self.filterViewModel.selectedFilter?.rawValue,
                                    orderDirection: self.filterViewModel.selectedOrder?.rawValue)
    }

    var offSet: Int {
        return currentPageOffset * limit
    }

    var limit: Int { 20 }

    func toggleFavorite(at index: Int) {
        let coin = coins[index]
        FavoriteCoinHandler.shared.toggleFavoriteCoin(coin)
    }

    func isFavourite(_ index: Int) -> Bool {
        let coin = coins[index]
        return FavoriteCoinHandler.shared.favoriteCoins.contains { $0.uuid == coin.uuid }
    }
}
