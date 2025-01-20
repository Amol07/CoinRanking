//
//  FavoriteCoinsViewModel.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//

import Foundation

class FavoriteCoinsViewModel {
    
    @Published private(set) var favoriteCoins: [CoinEntity] = []
    
    func loadFavoriteCoins() {
        FavoriteCoinHandler.shared.updateFavoriteCoins()
        self.favoriteCoins = FavoriteCoinHandler.shared.favoriteCoins.map { $0 }
    }
    
    func removeFavoriteCoin(at index: Int) {
        let favoriteCoin = self.favoriteCoins[index]
        FavoriteCoinHandler.shared.removeFavoriteCoin(favoriteCoin)
        self.favoriteCoins.remove(at: index)
    }
}
