//
//  CoinPriceHistoryService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol defining the method for fetching coin price history details.
///
/// Classes conforming to this protocol must implement the `fetchCoinPriceHistory` method to fetch
/// and process coin price history data asynchronously.
///
/// - Method:
///   - `fetchCoinPriceHistory(request:)`: Fetches and processes coin price history data based on the provided request.
protocol CoinPriceHistoryServiceProvider {
	/// Fetches and processes coin price history data based on the provided request.
	///
	/// This method makes a network request, fetches the raw data, and processes it into a `CoinPriceHistoryResponse` object.
	/// If any step fails, an error is thrown.
	///
	/// - Parameter request: The `RequestProvider` used to generate the network request.
	/// - Returns: A `CoinPriceHistoryResponse` containing the processed data.
	/// - Throws: An error if the request creation, data fetching, or processing fails.
	func fetchCoinPriceHistory(request: RequestProvider) async throws -> CoinPriceHistoryResponse
}

/// A concrete implementation of `CoinPriceHistoryServiceProvider` that fetches and processes coin price history details.
///
/// This service fetches raw data using a `NetworkProvider` and processes it into a `CoinPriceHistoryResponse` using
/// a `CoinPriceHistoryProcessor`.
///
/// - Properties:
///   - `networkManager`: The `NetworkProvider` instance responsible for fetching raw data.
///   - `processor`: The `CoinPriceHistoryProcessor` used to process raw data into a `CoinPriceHistoryResponse` object.
class CoinPriceHistoryService: CoinPriceHistoryServiceProvider {

	// MARK: - Properties
	private let networkManager: NetworkProvider
	private let processor: CoinPriceHistoryProcessor

	// MARK: - Initialization
	/// Initializes the `CoinPriceHistoryService` with the specified network manager and processor.
	///
	/// - Parameters:
	///   - networkManager: The `NetworkProvider` for fetching data (default is `NetworkManager()`).
	///   - processor: The `CoinPriceHistoryProcessor` for processing data (default is a new instance of `CoinPriceHistoryProcessor`).
	init(
		networkManager: NetworkProvider = NetworkManager(),
		processor: CoinPriceHistoryProcessor = CoinPriceHistoryProcessor()
	) {
		self.networkManager = networkManager
		self.processor = processor
	}

	// MARK: - Methods
	/// Fetches and processes coin price history data based on the provided request.
	///
	/// This method fetches raw data using the provided `RequestProvider` and processes it into a
	/// `CoinPriceHistoryResponse` model. If any error occurs during fetching or processing, it is thrown.
	///
	/// - Parameter request: A `RequestProvider` that creates a `URLRequest`.
	/// - Returns: A processed `CoinPriceHistoryResponse` containing the coin price history data.
	/// - Throws: An error if there is an issue with the network request or processing.
	func fetchCoinPriceHistory(request: RequestProvider) async throws -> CoinPriceHistoryResponse {
		// Create the network request
		let request = try request.createRequest()

		// Fetch raw data from the network
		let rawData = try await networkManager.fetchData(for: request)

		// Process the raw data into the response model
		let coinPriceHistroyResponse = try processor.processData(rawData)

		// Return the processed response
		return coinPriceHistroyResponse
	}
}
