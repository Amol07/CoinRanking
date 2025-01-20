//
//  FavoriteCoinHandler.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

/// A database provider for managing favorite coins.
struct FavoriteCoinDBProvider {

    /// A handler for core data operations related to favorite coins.
    let favoriteCoinHandler: CoreDataFavoriteCoinProvider

    /// Initializes a new instance of `FavoriteCoinDBProvider` with the specified core data handler.
    /// - Parameter favoriteCoinHandler: A core data handler. Defaults to `CoreDataManager.shared`.
    init(favoriteCoinHandler: CoreDataFavoriteCoinProvider = CoreDataManager.shared) {
        self.favoriteCoinHandler = favoriteCoinHandler
    }
}

/// A protocol that defines methods and properties for managing favorite coins.
protocol FavoriteCoinProvider {

    /// A set of favorite coins stored in memory.
    var favoriteCoins: Set<CoinEntity> { get }

    /// Updates the in-memory list of favorite coins by fetching the latest data from the database.
    func updateFavoriteCoins()

    /// Toggles the favorite status of a given coin.
    /// - Parameter coin: The coin to toggle as favorite.
    func toggleFavoriteCoin(_ coin: Coin)

    /// Removes a specified favorite coin.
    /// - Parameter coin: The coin entity to remove.
    func removeFavoriteCoin(_ coin: CoinEntity)
}

/// A concrete implementation of `FavoriteCoinProvider` for managing favorite coins.
final class FavoriteCoinHandler: FavoriteCoinProvider {

    /// A shared singleton instance of `FavoriteCoinHandler`.
    static let shared = FavoriteCoinHandler()

    /// A provider for database operations related to favorite coins.
    var dbProvider = FavoriteCoinDBProvider()

    /// Private initializer to enforce singleton usage.
    private init() {}

    /// A set of favorite coins stored in memory.
    private(set) var favoriteCoins: Set<CoinEntity> = []

    /// Updates the in-memory list of favorite coins by fetching the latest data from the database.
    func updateFavoriteCoins() {
        favoriteCoins.removeAll()
        self.dbProvider.favoriteCoinHandler.fetchFavoriteCoins()
            .compactMap { $0 }
            .forEach {
                self.favoriteCoins.insert($0)
            }
    }

    /// Toggles the favorite status of a given coin.
    /// If the coin is already a favorite, it is removed; otherwise, it is added to the favorites.
    /// - Parameter coin: The coin to toggle as favorite.
    func toggleFavoriteCoin(_ coin: Coin) {
        let isAlreadyFavorite = favoriteCoins.contains { $0.uuid == coin.uuid }
        if isAlreadyFavorite {
            self.dbProvider.favoriteCoinHandler.removeFavoriteCoin(withUUID: coin.uuid)
        } else {
            self.dbProvider.favoriteCoinHandler.saveFavoriteCoin(coin)
        }
        self.updateFavoriteCoins()
    }

    /// Removes a specified favorite coin.
    /// - Parameter coin: The coin entity to remove.
    func removeFavoriteCoin(_ coin: CoinEntity) {
        self.dbProvider.favoriteCoinHandler.removeFavoriteCoin(withUUID: coin.uuid)
        self.updateFavoriteCoins()
    }
}
