//
//  CoinListService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the methods for fetching coin lists.
///
/// The `CoinListServiceProvider` protocol outlines the structure for any service class that fetches a list of coins.
/// Conforming classes should implement the `fetchCoinList` method to handle the fetching of coin list data from the network
/// and processing it into a usable response model.
///
/// - Method:
///   - `fetchCoinList(request:)`: This method fetches the coin list asynchronously, generates a network request using
///     a `RequestProvider`, and returns the processed response as a `CoinListResponse`.
protocol CoinListServiceProvider {
	/// Fetches the coin list based on the provided request.
	///
	/// This method constructs the network request, fetches raw data from the network, and processes it into a `CoinListResponse` model.
	/// If the request creation, data fetching, or processing fails, it throws an error.
	///
	/// - Parameter request: A `RequestProvider` used to generate the network request.
	/// - Returns: A `CoinListResponse` object containing the processed coin list data.
	/// - Throws: An error if there is an issue in creating the request, fetching data, or processing the response.
	func fetchCoinList(request: RequestProvider) async throws -> CoinListResponse
}

/// A concrete implementation of `CoinListServiceProvider` that fetches and processes the coin list data.
///
/// The `CoinListService` class is responsible for orchestrating the fetching and processing of the coin list data.
/// It leverages a `NetworkProvider` to retrieve the raw data from the network and a `CoinListProcessor` to process this data into
/// a structured `CoinListResponse` model.
///
/// - Properties:
///   - `networkManager`: A `NetworkProvider` instance that is responsible for performing network requests and fetching raw data.
///   - `processor`: A `CoinListProcessor` instance that processes the raw data into a `CoinListResponse` model.
///
/// - Initialization:
///   - `init(networkManager:processor:)`: Initializes the `CoinListService` with a given `NetworkProvider` and an optional `CoinListProcessor`.
///     If no processor is provided, a default instance of `CoinListProcessor` is used.
class CoinListService: CoinListServiceProvider {

	// MARK: - Properties
	private let networkManager: NetworkProvider
	private let processor: CoinListProcessor

	// MARK: - Initialization

	/// Initializes a new instance of `CoinListService` with the provided `NetworkProvider` and an optional `CoinListProcessor`.
	///
	/// The `networkManager` is responsible for fetching the raw data, and the `processor` processes the data into a usable `CoinListResponse`.
	///
	/// - Parameters:
	///   - networkManager: A `NetworkProvider` that fetches raw data from the network. Defaults to a new instance of `NetworkManager`.
	///   - processor: A `CoinListProcessor` used to process the raw data into a `CoinListResponse` model. Defaults to a new instance of `CoinListProcessor`.
	init(
		networkManager: NetworkProvider = NetworkManager(),
		processor: CoinListProcessor = CoinListProcessor()
	) {
		self.networkManager = networkManager
		self.processor = processor
	}

	// MARK: - Methods

	/// Fetches the coin list based on the provided request.
	///
	/// This method uses the provided `RequestProvider` to create a network request, fetches raw data from the network using the
	/// `networkManager`, and processes the data into a `CoinListResponse` using the `processor`.
	///
	/// If any part of the process (network request, data fetching, or data processing) fails, an error is thrown.
	///
	/// - Parameter request: A `RequestProvider` that creates a `URLRequest` to be used for the network call.
	/// - Returns: A `CoinListResponse` object containing the processed data.
	/// - Throws: An error if the network request fails, or if there is an issue during data processing.
	func fetchCoinList(request: RequestProvider) async throws -> CoinListResponse {
		// Create the network request using the provided request provider
		let request = try request.createRequest()

         // Fetch raw data from the network
         let rawData = try await networkManager.fetchData(for: request)

         // Process the raw data into a `CoinListResponse` model
         let coinListResponse = try processor.processData(rawData)

         // Return the processed response
         return coinListResponse
    }
}
