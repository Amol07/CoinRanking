//
//  CoinDetailService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the methods for fetching coin details.
///
/// `CoinDetailServiceProvider` is a protocol that provides the structure for any service class that fetches coin detail.
/// It abstracts the process of making a network request and processing the returned data into a usable response.
/// Classes that conform to this protocol should implement the `fetchCoinDetail` method to retrieve coin detail.
///
/// - Method:
///   - `fetchCoinDetail(request:)`: Fetches coin detail asynchronously, takes a `RequestProvider` to generate the network request,
///     and returns the processed response as a `CoinDetailResponse`.
protocol CoinDetailServiceProvider {
	/// Fetches coin detail based on the provided request.
	///
	/// This method creates the network request, fetches raw data from the network, and processes it into a
	/// `CoinDetailResponse` object. If the request or processing fails, an error is thrown.
	///
	/// - Parameter request: A `RequestProvider` object used to generate the network request.
	/// - Returns: A `CoinDetailResponse` object representing the processed coin detail data.
	/// - Throws: An error if the request creation, data fetching, or processing fails.
	func fetchCoinDetail(request: RequestProvider) async throws -> CoinDetailResponse
}

/// A concrete implementation of `CoinDetailServiceProvider` that fetches coin detail and processes them.
///
/// `CoinDetailService` is responsible for orchestrating the fetching and processing of coin detail. It combines a `NetworkProvider`
/// to fetch raw data from the network, and a `CoinDetailProcessor` to process the raw data into a `CoinDetailResponse` model.
///
/// - Properties:
///   - `networkManager`: A `NetworkProvider` instance responsible for fetching raw data from the network.
///   - `processor`: A `CoinDetailProcessor` instance responsible for processing raw data into the `CoinDetailResponse`.
///
/// - Initialization:
///   - `init(networkManager:processor:)`: Initializes a new instance of `CoinDetailService` with the provided `NetworkProvider`
///     and an optional `CoinDetailProcessor` (defaults to a new instance of `CoinDetailProcessor`).
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
	init(networkManager: NetworkProvider = NetworkManager(),
		 processor: CoinDetailProcessor = CoinDetailProcessor()) {
		self.networkManager = networkManager
		self.processor = processor
	}

	// MARK: - Methods
	/// Fetches coin detail based on the provided request.
	///
	/// This method calls the `networkManager` to fetch the raw data for the coin detail and passes that data to the
	/// `processor` to convert it into a `CoinDetailResponse` model.
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
