//
//  CoinDetailService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol defining methods for fetching coin details.
///
/// Classes conforming to `CoinDetailServiceProvider` should implement the `fetchCoinDetail` method to retrieve coin details.
protocol CoinDetailServiceProvider {
	/// Fetches coin details based on the provided request.
	///
	/// - Parameter request: A `RequestProvider` object used to generate the network request.
	/// - Returns: A `CoinDetailResponse` object representing the processed coin detail data.
	/// - Throws: An error if the request creation, data fetching, or processing fails.
	func fetchCoinDetail(request: RequestProvider) async throws -> CoinDetailResponse
}

/// A concrete implementation of `CoinDetailServiceProvider` that fetches and processes coin details.
///
/// `CoinDetailService` orchestrates the fetching and processing of coin details by combining a `NetworkProvider`
/// to fetch raw data and a `CoinDetailProcessor` to process the data into a `CoinDetailResponse` model.
class CoinDetailService: CoinDetailServiceProvider {

	// MARK: - Properties
	private let networkManager: NetworkProvider
	private let processor: CoinDetailProcessor

	// MARK: - Initialization
	/// Initializes a new instance of `CoinDetailService` with the provided `NetworkProvider` and an optional `CoinDetailProcessor`.
	///
	/// - Parameters:
	///   - networkManager: A `NetworkProvider` responsible for fetching raw data.
	///   - processor: A `CoinDetailProcessor` for processing the raw data into `CoinDetailResponse` (defaults to a new instance).
	init(
		networkManager: NetworkProvider = NetworkManager(),
		processor: CoinDetailProcessor = CoinDetailProcessor()
	) {
		self.networkManager = networkManager
		self.processor = processor
	}

	// MARK: - Methods
	/// Fetches coin details based on the provided request.
	///
	/// - Parameter request: A `RequestProvider` that creates a `URLRequest` for the network call.
	/// - Returns: A `CoinDetailResponse` object that represents the processed coin detail data.
	/// - Throws: An error if the network request fails, or if there is an issue in processing the data.
	func fetchCoinDetail(request: RequestProvider) async throws -> CoinDetailResponse {
		// Create the network request using the provided request provider
		let request = try request.createRequest()

		// Fetch raw data from the network
		let rawData = try await networkManager.fetchData(for: request)

		// Process the raw data into a `CoinDetailResponse` model
		let coinDetailResponse = try processor.processData(rawData)

		// Return the processed response
		return coinDetailResponse
	}
}
