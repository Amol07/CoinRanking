//
//  FavoriteCoinsViewModelTests.swift
//  CoinRankingTests
//
//  Created by Amol Prakash on 20/01/25.
//

import CoreData
import XCTest

@testable import CoinRanking

class FavoriteCoinsViewModelTests: XCTestCase {
    var viewModel: FavoriteCoinsViewModel!
    var mockFavoriteCoinHandler: FavoriteCoinProvider!

    override func setUp() {
        super.setUp()
        mockFavoriteCoinHandler = MockFavoriteCoinHandler()
        viewModel = FavoriteCoinsViewModel(handler: mockFavoriteCoinHandler)
    }

    override func tearDown() {
        viewModel = nil
        mockFavoriteCoinHandler = nil
        super.tearDown()
    }

    func testLoadFavoriteCoins() {
        // Arrange

        // Act
        viewModel.loadFavoriteCoins()

        // Assert
        XCTAssertTrue((mockFavoriteCoinHandler as? MockFavoriteCoinHandler)?.isUpdateFavouriteCoinsCalled ?? false)
    }
}

// Mock implementation of FavoriteCoinHandler
class MockFavoriteCoinHandler: FavoriteCoinProvider {

    var favCoins: Set<String> = []

    var isUpdateFavouriteCoinsCalled = false

    var favoriteCoins: Set<CoinRanking.CoinEntity> = []

    func toggleFavoriteCoin(_ coin: CoinRanking.Coin) {
        if self.favCoins.contains(coin.uuid) {
            self.favCoins.remove(coin.uuid)
        } else {
            self.favCoins.insert(coin.uuid)
        }
    }

    func updateFavoriteCoins() {
        isUpdateFavouriteCoinsCalled = true
    }

    func removeFavoriteCoin(_ coin: CoinEntity) {
        self.favCoins.remove(coin.uuid)
    }
}
