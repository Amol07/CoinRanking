//
//  CoinListViewModelTests.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//


import XCTest
import Combine
@testable import CoinRanking

final class CoinListViewModelTests: XCTestCase {
    private var viewModel: CoinListViewModel!
    private var mockService: MockCoinListService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockCoinListService()
        viewModel = CoinListViewModel(mockService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertFalse(viewModel.isFetching, "Initial fetching state should be false.")
        XCTAssertTrue(viewModel.coins.isEmpty, "Initial coins list should be empty.")
    }

    func testFetchCoins() async {
        // Arrange
        mockService.mockResponse = self.mockCoinListResponse

        // Act
        await viewModel.fetchCoins()

        // Assert
        XCTAssertEqual(viewModel.coins.count, 20, "Coins list should contain the fetched coins.")
        XCTAssertEqual(viewModel.coins.first?.name, "Bitgert", "Fetched coin name should be 'Bitgert'.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch.")
    }

    func testFetchMoreCoins() async {
        // Arrange
        mockService.mockResponse = self.mockCoinListResponse

        // Act
        await viewModel.fetchMoreCoins()

        // Assert
        XCTAssertEqual(viewModel.coins.count, 20, "Coins list should contain the fetched coins.")
        XCTAssertEqual(viewModel.coins.first?.name, "Bitgert", "Fetched coin name should be 'Bitgert'.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch.")
    }

    func testFetchCoinsFailure() async {
        // Arrange
        mockService.shouldFail = true

        // Act
        await viewModel.fetchCoins()

        // Assert
        XCTAssertTrue(viewModel.coins.isEmpty, "Coins list should remain empty on fetch failure.")
        XCTAssertEqual(viewModel.isFetching, false, "Fetching state should be false after fetch failure.")
    }

    func testBindFilterViewModel() async {
        // Arrange
        let expectation = XCTestExpectation(description: "Should fetch coins when filter is applied.")
        mockService.mockResponse = self.mockCoinListResponse

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

private extension CoinListViewModelTests {

    var mockCoinListResponse: CoinListResponse {
        guard let fileURL = Bundle.main.url(forResource: "Coins", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL) else {
            fatalError("Couldn't find Coins.json in main bundle.")
        }

        let decoder = JSONDecoder()
        return try! decoder.decode(CoinListResponse.self, from: data)

    }
}

// Mock service implementation for testing.
final class MockCoinListService: CoinListServiceProvider {
    func fetchCoinList(request: any CoinRanking.RequestProvider) async throws -> CoinRanking.CoinListResponse {
        if shouldFail {
            throw NSError(domain: "Mock Error", code: 1, userInfo: nil)
        }
        guard let response = mockResponse else {
            throw NSError(domain: "No Mock Response", code: 2, userInfo: nil)
        }
        return response
    }
    
    var shouldFail: Bool = false
    var mockResponse: CoinListResponse?
}
