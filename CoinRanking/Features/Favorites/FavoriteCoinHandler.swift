//
//  FavoriteCoinHandler.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//

struct FavoriteCoinDBProvider {

    let favoriteCoinHandler: CoreDataFavoriteCoinProvider

    init(favoriteCoinHandler: CoreDataFavoriteCoinProvider = CoreDataManager.shared) {
        self.favoriteCoinHandler = favoriteCoinHandler
    }
}

final class FavoriteCoinHandler {

    static let shared = FavoriteCoinHandler()
    var dbProvider: FavoriteCoinDBProvider = FavoriteCoinDBProvider()

    private init() {}

    private(set) var favoriteCoins: Set<CoinEntity> = []

    func updateFavoriteCoins() {
        favoriteCoins.removeAll()
        self.dbProvider.favoriteCoinHandler.fetchFavoriteCoins()
            .compactMap{ $0 }
            .forEach {
            self.favoriteCoins.insert($0)
        }
    }

    func toggleFavoriteCoin(_ coin: Coin) {
        let isAlreadyFavorite = favoriteCoins.contains { $0.uuid == coin.uuid }
        if isAlreadyFavorite {
            self.dbProvider.favoriteCoinHandler.removeFavoriteCoin(withUUID: coin.uuid)
        } else {
            self.dbProvider.favoriteCoinHandler.saveFavoriteCoin(coin)
        }
        self.updateFavoriteCoins()
    }

    func removeFavoriteCoin(_ coin: CoinEntity) {
        self.dbProvider.favoriteCoinHandler.removeFavoriteCoin(withUUID: coin.uuid)
        self.updateFavoriteCoins()
    }
}
