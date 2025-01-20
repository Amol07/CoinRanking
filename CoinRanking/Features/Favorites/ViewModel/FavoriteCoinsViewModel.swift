//
//  FavoriteCoinsViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import Foundation

/// A view model that manages a list of favorite coins.
class FavoriteCoinsViewModel {

    private let favoriteCoinHandler: FavoriteCoinProvider

    /// The list of favorite coins, updated automatically when changes occur.
    @Published private(set) var favoriteCoins: [CoinEntity] = []

    /// Initializes the view model with a given favorite coin handler.
    /// - Parameter handler: The handler responsible for managing favorite coins. Defaults to `FavoriteCoinHandler.shared`.
    init(handler: FavoriteCoinProvider = FavoriteCoinHandler.shared) {
        self.favoriteCoinHandler = handler
    }

    /// Loads the favorite coins from the handler and updates the `favoriteCoins` property.
    func loadFavoriteCoins() {
        favoriteCoinHandler.updateFavoriteCoins()
        self.favoriteCoins = favoriteCoinHandler.favoriteCoins.map { $0 }
    }

    /// Removes a favorite coin at a specified index.
    /// - Parameter index: The index of the coin to remove from the favorites list.
    func removeFavoriteCoin(at index: Int) {
        guard index < self.favoriteCoins.count else { return }
        let favoriteCoin = self.favoriteCoins[index]
        favoriteCoinHandler.removeFavoriteCoin(favoriteCoin)
        self.favoriteCoins.remove(at: index)
    }
}
