//
//  URLSessionProtocol.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the contract for a session provider to fetch data asynchronously.
///
/// `URLSessionProvider` is a protocol that abstracts the `URLSession` class, allowing the ability to mock or replace
/// the networking layer for testing or other purposes. It defines a single method for fetching data using a `URLRequest`.
///
/// - Method:
///   - `data(for:)`: Asynchronously fetches data for the provided `URLRequest` and returns the data along with the URL response.
protocol URLSessionProvider {
	/// Fetches data for a given URL request.
	///
	/// - Parameter request: A `URLRequest` that represents the request to be made.
	/// - Returns: A tuple containing the fetched `Data` and the corresponding `URLResponse`.
	/// - Throws: An error if the network request fails.
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

/// A default implementation of `URLSessionProvider` that uses `URLSession.shared` for networking.
extension URLSession: URLSessionProvider {}
