//
//  NetworkProvider.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the contract for a network provider that fetches raw data.
///
/// `NetworkProvider` abstracts the network fetching process and allows the data to be retrieved as raw `Data` from a server.
/// Classes that conform to this protocol can provide their own implementation of how data is fetched, making it more testable and flexible.
///
/// - Method:
///   - `fetchData(for:)`: Fetches the raw `Data` for the provided `URLRequest` after performing necessary error handling.
protocol NetworkProvider {
	/// Fetches the raw data for the provided request.
	///
	/// - Parameter request: A `URLRequest` that defines the network request.
	/// - Returns: The raw `Data` fetched from the server.
	/// - Throws: An error if the network request fails or if the server returns an invalid response.
	func fetchData(for request: URLRequest) async throws -> Data
}

/// A concrete implementation of `NetworkProvider` that uses `URLSessionProvider` to fetch data.
///
/// `NetworkManager` is responsible for performing network requests using a `URLSessionProvider` to fetch data asynchronously.
/// It handles error checking related to HTTP responses, including checking for successful status codes and valid responses.
///
/// - Properties:
///   - `session`: An instance of `URLSessionProvider` used to fetch data. Defaults to `URLSession.shared` if not provided.
///
/// - Initialization:
///   - `init(session:)`: Initializes a new instance of `NetworkManager` with the provided `URLSessionProvider` or defaults to `URLSession.shared`.
///
/// - Methods:
///   - `fetchData(for:)`: Fetches data for the given `URLRequest` after performing error checks.
class NetworkManager: NetworkProvider {

	// MARK: - Properties
	private let session: URLSessionProvider

	// MARK: - Initialization
	/// Initializes a new `NetworkManager` instance with the provided session provider.
	///
	/// - Parameter session: An instance conforming to `URLSessionProvider` (default is `URLSession.shared`).
	init(session: URLSessionProvider = URLSession.shared) {
		self.session = session
	}

	// MARK: - Methods
	/// Fetches raw data from the network for a given URL request.
	///
	/// This method uses the `URLSessionProvider` (default is `URLSession.shared`) to fetch data for the provided `URLRequest`.
	/// It performs error handling to ensure the HTTP response status code is within the 2xx range and that the response is valid.
	///
	/// - Parameter request: A `URLRequest` that represents the request to be made.
	/// - Returns: The raw `Data` fetched from the server.
	/// - Throws: An `AppError.networkError` if the server response is invalid or if the status code indicates an error.
	func fetchData(for request: URLRequest) async throws -> Data {
		// Perform the network request using the session provider
		let (data, response) = try await session.data(for: request)

		// Check if the response is a valid HTTP URL response
		guard let httpResponse = response as? HTTPURLResponse else {
			throw AppError.networkError(.invalidResponse)
		}

		// Ensure the status code is in the range 200-299, indicating success
		guard (200...299).contains(httpResponse.statusCode) else {
			throw AppError.networkError(.serverError(statusCode: httpResponse.statusCode))
		}

		// Return the fetched raw data
		return data
	}
}
