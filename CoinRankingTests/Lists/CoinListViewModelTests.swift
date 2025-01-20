//
//  CoinListViewModelTests.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

@testable import CoinRanking
import Combine
import XCTest

final class CoinListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

	func testInitialState() throws {
		let service = MockCoinListService(results: .success(DummyData.coinsResponse))
		let viewModel = CoinListViewModel(service)
        XCTAssertFalse(viewModel.isFetching, "Initial fetching state should be false.")
        XCTAssertTrue(viewModel.coins.isEmpty, "Initial coins list should be empty.")
    }

    func testFetchCoins() async throws {
		let service = MockCoinListService(results: .success(DummyData.coinsResponse))
		let viewModel = CoinListViewModel(service)
        // Act
        await viewModel.fetchCoins()

        // Assert
        XCTAssertEqual(viewModel.coins.count, 20, "Coins list should contain the fetched coins.")
        XCTAssertEqual(viewModel.coins.first?.name, "Bitgert", "Fetched coin name should be 'Bitgert'.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch.")
    }

    func testFetchMoreCoins() async throws {
		let service = MockCoinListService(results: .success(DummyData.coinsResponse))
		let viewModel = CoinListViewModel(service)
        // Act
        await viewModel.fetchMoreCoins()

        // Assert
        XCTAssertEqual(viewModel.coins.count, 20, "Coins list should contain the fetched coins.")
        XCTAssertEqual(viewModel.coins.first?.name, "Bitgert", "Fetched coin name should be 'Bitgert'.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch.")
    }

	func testFetchCoinsFailure() async throws {
		let service = MockCoinListService(results: .failure(.networkError(.invalidResponse)))
		let viewModel = CoinListViewModel(service)
		// Act
        await viewModel.fetchCoins()

        // Assert
        XCTAssertTrue(viewModel.coins.isEmpty, "Coins list should remain empty on fetch failure.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch failure.")
    }

    func testBindFilterViewModel() async throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Should fetch coins when filter is applied.")
		let service = MockCoinListService(results: .success(DummyData.coinsResponse))
		let viewModel = CoinListViewModel(service)

        // Act
        viewModel.filterViewModel.applyFilterPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.filterViewModel.applyFilterPublisher.send()

        // Wait for async operation
        await fulfillment(of: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.coins.count, 20, "Coins list should be reset and contain new filtered data.")
        XCTAssertEqual(viewModel.coins.first?.name, "Bitgert", "Filtered coin name should be 'Bitgert'.")
    }
}

// MARK: - Mocks
final class MockCoinListService: SimpleMockService<CoinListResponse>, CoinListServiceProvider {
    func fetchCoinList(request: any RequestProvider) async throws -> CoinListResponse {
		try await self.asyncResults()
    }
}
