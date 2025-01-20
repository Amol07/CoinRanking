//
//  CoinDetailViewModelTests.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

@testable import CoinRanking
import XCTest

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

	func testFetchCoinDetailsSuccess() async throws {
		let mockService = MockCoinDetailServiceProvider(results: .success(DummyData.coinDetailResponse))
        await viewModel.fetchCoinDetails(timePeriod: "24h", service: mockService)

        guard case .loaded(let coinViewModel) = viewModel.state else {
            return XCTFail("State should be .loaded after successful fetch.")
        }

        XCTAssertEqual(coinViewModel.uuid, mockCoinID, "Loaded coin ID should match mock data.")
    }

    func testFetchCoinDetailsFailure() async {
		let mockService = MockCoinDetailServiceProvider(results: .failure(.networkError(.invalidResponse)))
        await viewModel.fetchCoinDetails(timePeriod: "24h", service: mockService)

        XCTAssertEqual(viewModel.state, .error, "State should be .error after failed fetch.")
    }

    func testFetchPriceHistorySuccess() async throws {
		let mockService = MockCoinPriceHistoryServiceProvider(results: .success(DummyData.coinPriceHistoryResponse))
        await viewModel.fetchPriceHistory(timePeriod: "24h", service: mockService)

        XCTAssertNotNil(viewModel.history, "History should not be nil after successful fetch.")
        XCTAssertEqual(viewModel.history?.count, 2, "History should contain the correct number of entries.")
    }

    func testFetchPriceHistoryFailure() async {
		let mockService = MockCoinPriceHistoryServiceProvider(results: .failure(.networkError(.invalidResponse)))
        await viewModel.fetchPriceHistory(timePeriod: "24h", service: mockService)

        XCTAssertNil(viewModel.history, "History should be nil after failed fetch.")
    }

    func testGetFilteredChartData() {
		viewModel.state = .loaded(CoinViewModel(coin: DummyData.coinDetailResponse.data.coin!))
		viewModel.history = DummyData.coinPriceHistoryResponse.data.history

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

class MockCoinDetailServiceProvider: SimpleMockService<CoinDetailResponse>, CoinDetailServiceProvider {
    func fetchCoinDetail(request: any CoinRanking.RequestProvider) async throws -> CoinDetailResponse {
		try await asyncResults()
    }
}

class MockCoinPriceHistoryServiceProvider: SimpleMockService<CoinPriceHistoryResponse>, CoinPriceHistoryServiceProvider {
    func fetchCoinPriceHistory(request: any CoinRanking.RequestProvider) async throws -> CoinPriceHistoryResponse {
		try await asyncResults()
    }
}
