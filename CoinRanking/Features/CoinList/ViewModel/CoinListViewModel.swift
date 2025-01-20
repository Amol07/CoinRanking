//
//  CoinListViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Combine
import Foundation

class CoinListViewModel {

    // MARK: - Private properties

    /// The current page offset used for pagination.
    private var currentPageOffset: Int = 0

    /// A set of AnyCancellable instances to manage Combine subscriptions.
    private var subscribers: Set<AnyCancellable> = []

    /// Service provider for fetching the coin list data.
    private let service: CoinListServiceProvider

    /// The selected time period for filtering the coin list.
	private var timePeriod: String = "24h"

    // MARK: - Public properties

    /// ViewModel for managing filtering options.
    let filterViewModel = FilterViewModel()

    /// A published property indicating whether a fetch operation is ongoing.
    @Published private(set) var isFetching: Bool = false

    /// A published property holding the list of coins fetched.
    @Published private(set) var coins: [Coin] = []

    // MARK: - Initializer

    /// Initializes the view model with an optional service provider.
    /// - Parameter service: A `CoinListServiceProvider` instance. Defaults to `CoinListService`.
    init(_ service: CoinListServiceProvider = CoinListService()) {
        self.service = service
        self.bindFilterViewModel()
    }

	/// Indicates whether more records should be fetched based on the current count of coins being less than 100.
	var shouldFetchMoreRecords: Bool {
		coins.count < 100
	}

    // MARK: - Public methods

    /// Fetches the list of coins asynchronously.
    /// If a fetch is already in progress, this method does nothing.
    func fetchCoins() async {
        guard !isFetching else { return }
        isFetching = true

        let request = self.coinFetchRequest()
        do {
            let response = try await self.service.fetchCoinList(request: request)
            coins.append(contentsOf: response.data.coins)
            currentPageOffset += 1
        } catch {
            // Clear the coins list if the fetch fails on the first page.
            if currentPageOffset == 0 {
                self.coins = []
            }
        }
        isFetching = false
    }

    /// Binds the filter view model's filter application publisher to a callback.
    /// Resets the coin list and page offset, and fetches coins based on the applied filters.
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

    /// Fetches the next page of coins asynchronously.
    func fetchMoreCoins() async {
        await fetchCoins()
    }

    /// Creates and returns a `CoinRequest` object for fetching coins.
    /// - Returns: A `CoinRequest` object configured with the current offset, limit, time period, and filters.
    func coinFetchRequest() -> CoinRequest {
        return CoinRequest.coinList(
            offset: offSet,
            limit: limit,
            timePeriod: self.timePeriod,
            orderBy: self.filterViewModel.selectedFilter?.rawValue,
            orderDirection: self.filterViewModel.selectedOrder?.rawValue
        )
    }

    /// Toggles the favorite status of a coin at the given index.
    /// - Parameter index: The index of the coin in the list.
    func toggleFavorite(at index: Int) {
        let coin = coins[index]
        FavoriteCoinHandler.shared.toggleFavoriteCoin(coin)
    }

    /// Checks whether the coin at the given index is marked as a favorite.
    /// - Parameter index: The index of the coin in the list.
    /// - Returns: A Boolean indicating whether the coin is a favorite.
    func isFavourite(_ index: Int) -> Bool {
        let coin = coins[index]
        return FavoriteCoinHandler.shared.favoriteCoins.contains { $0.uuid == coin.uuid }
    }
}

private extension CoinListViewModel {
    /// Computes the current offset for pagination based on the page offset and limit.
    var offSet: Int {
        return currentPageOffset * limit
    }

    /// The maximum number of coins to fetch per page.
    var limit: Int { 20 }
}
