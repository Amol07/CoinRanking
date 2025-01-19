//
//  CoinListService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the methods for fetching coin lists.
///
/// `CoinListServiceProvider` is a protocol that provides the structure for any service class that fetches coin list.
/// It abstracts the process of making a network request and processing the returned data into a usable response.
/// Classes that conform to this protocol should implement the `fetchCoinList` method to retrieve coin list.
///
/// - Method:
///   - `fetchCoinList(request:)`: Fetches coin list asynchronously, takes a `RequestProvider` to generate the network request,
///     and returns the processed response as a `CoinListResponse`.
protocol CoinListServiceProvider {
	/// Fetches coin list based on the provided request.
	///
	/// This method creates the network request, fetches raw data from the network, and processes it into a
	/// `CoinListResponse` object. If the request or processing fails, an error is thrown.
	///
	/// - Parameter request: A `RequestProvider` object used to generate the network request.
	/// - Returns: A `CoinListResponse` object representing the processed coin list data.
	/// - Throws: An error if the request creation, data fetching, or processing fails.
	func fetchCoinList(request: RequestProvider) async throws -> CoinListResponse
}

/// A concrete implementation of `CoinListServiceProvider` that fetches coin list and processes them.
///
/// `CoinListService` is responsible for orchestrating the fetching and processing of coin list. It combines a `NetworkProvider`
/// to fetch raw data from the network, and a `CoinListProcessor` to process the raw data into a `CoinListResponse` model.
///
/// - Properties:
///   - `networkManager`: A `NetworkProvider` instance responsible for fetching raw data from the network.
///   - `processor`: A `CoinListProcessor` instance responsible for processing raw data into the `CoinListResponse`.
///
/// - Initialization:
///   - `init(networkManager:processor:)`: Initializes a new instance of `CoinListService` with the provided `NetworkProvider`
///     and an optional `CoinListProcessor` (defaults to a new instance of `CoinListProcessor`).
class CoinListService: CoinListServiceProvider {

	// MARK: - Properties
	private let networkManager: NetworkProvider
	private let processor: CoinListProcessor

	// MARK: - Initialization
	/// Initializes a new instance of `CoinListService` with the provided `NetworkProvider` and an optional `CoinListProcessor`.
	///
	/// - Parameters:
	///   - networkManager: A `NetworkProvider` responsible for fetching raw data.
	///   - processor: A `CoinListProcessor` for processing the raw data into `CoinListResponse` (defaults to a new instance).
	init(networkManager: NetworkProvider = NetworkManager(),
		 processor: CoinListProcessor = CoinListProcessor()) {
		self.networkManager = networkManager
		self.processor = processor
	}

	// MARK: - Methods
	/// Fetches coin list based on the provided request.
	///
	/// This method calls the `networkManager` to fetch the raw data for the coin list and passes that data to the
	/// `processor` to convert it into a `CoinListResponse` model.
	///
	/// - Parameter request: A `RequestProvider` that creates a `URLRequest` for the network call.
	/// - Returns: A `CoinListResponse` object that represents the processed coin list data.
	/// - Throws: An error if the network request fails, or if there is an issue in processing the data.
    func fetchCoinList(request: RequestProvider) async throws -> CoinListResponse {
        // Create the network request using the provided request provider
        let request = try request.createRequest()

        /*
         // Fetch raw data from the network
         let rawData = try await networkManager.fetchData(for: request)

         // Process the raw data into a `CoinListResponse` model
         let coinListResponse = try processor.processData(rawData)

         // Return the processed response
         return coinListResponse
         */

        try await Task.sleep(nanoseconds: 1_000_000_000)
        guard let fileURL = Bundle.main.url(forResource: "Coins", withExtension: "json") else {
            fatalError("Couldn't find Coins.json in main bundle.")
        }

        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(CoinListResponse.self, from: data)
        } catch {
            fatalError("Couldn't load Coins.json from main bundle:\n\(error)")
        }
    }
}
