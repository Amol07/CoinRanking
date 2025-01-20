//
//  CoinDetailViewModelTests.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//


import XCTest
@testable import CoinRanking

final class CoinDetailViewModelTests: XCTestCase {

    private var viewModel: CoinDetailViewModel!
    private let mockCoinID = "Qwsogvtv82FCd"

    override func setUp() {
        super.setUp()
        viewModel = CoinDetailViewModel(coinID: mockCoinID)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(viewModel.state, .loading, "Initial state should be .loading.")
        XCTAssertNil(viewModel.history, "Initial history should be nil.")
        XCTAssertEqual(viewModel.selectedChartFilter, .twentyFourHours, "Default chart filter should be .twentyFourHours.")
    }

    func testFetchCoinDetailsSuccess() async {
        let mockService = MockCoinDetailServiceProvider(success: true)
        await viewModel.fetchCoinDetails(timePeriod: "24h", service: mockService)

        guard case .loaded(let coinViewModel) = viewModel.state else {
            return XCTFail("State should be .loaded after successful fetch.")
        }

        XCTAssertEqual(coinViewModel.uuid, mockCoinID, "Loaded coin ID should match mock data.")
    }

    func testFetchCoinDetailsFailure() async {
        let mockService = MockCoinDetailServiceProvider(success: false)
        await viewModel.fetchCoinDetails(timePeriod: "24h", service: mockService)

        XCTAssertEqual(viewModel.state, .error, "State should be .error after failed fetch.")
    }

    func testFetchPriceHistorySuccess() async {
        let mockService = MockCoinPriceHistoryServiceProvider(success: true)
        await viewModel.fetchPriceHistory(timePeriod: "24h", service: mockService)

        XCTAssertNotNil(viewModel.history, "History should not be nil after successful fetch.")
        XCTAssertEqual(viewModel.history?.count, 2, "History should contain the correct number of entries.")
    }

    func testFetchPriceHistoryFailure() async {
        let mockService = MockCoinPriceHistoryServiceProvider(success: false)
        await viewModel.fetchPriceHistory(timePeriod: "24h", service: mockService)

        XCTAssertNil(viewModel.history, "History should be nil after failed fetch.")
    }

    func testGetFilteredChartData() {
        viewModel.state = .loaded(CoinViewModel(coin: CoinRanking.CoinDetailResponse.mockData.data.coin))
        viewModel.history = CoinRanking.CoinPriceHistoryResponse.mockData.data.history

        let filteredData = viewModel.getFilteredChartData()

        XCTAssertEqual(filteredData.count, 2, "Filtered data should match history count.")
    }

    func testGetFilteredChartDataEmptyState() {
        viewModel.state = .empty
        viewModel.history = nil

        let filteredData = viewModel.getFilteredChartData()

        XCTAssertTrue(filteredData.isEmpty, "Filtered data should be empty when state is not .loaded.")
    }
}

// MARK: - Mocks

class MockCoinDetailServiceProvider: CoinDetailServiceProvider {
    
    private let success: Bool

    init(success: Bool) {
        self.success = success
    }

    func fetchCoinDetail(request: any CoinRanking.RequestProvider) async throws -> CoinRanking.CoinDetailResponse {
        if success {
            return CoinRanking.CoinDetailResponse.mockData
        } else {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
    }
}

class MockCoinPriceHistoryServiceProvider: CoinPriceHistoryServiceProvider {
    
    private let success: Bool

    init(success: Bool) {
        self.success = success
    }

    func fetchCoinPriceHistory(request: any CoinRanking.RequestProvider) async throws -> CoinRanking.CoinPriceHistoryResponse {
        if success {
            return CoinRanking.CoinPriceHistoryResponse.mockData
        } else {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
    }
}
