//
//  RequestProvider.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A protocol that defines the structure and requirements for an HTTP request.
///
/// Types conforming to `RequestProvider` are responsible for specifying all the details
/// necessary to create and configure a network request, such as the base URL, HTTP method,
/// headers, query parameters, and body parameters. This protocol ensures that all network
/// requests are structured consistently and can be used to build `URLRequest` objects
/// for sending to a server.
///
/// The protocol also supports the configuration of request encoding, which defines how
/// the request data is formatted and transmitted to the server.
///
/// Conforming types are expected to implement the `createRequest()` method, which builds
/// the complete `URLRequest` using the specified properties.
protocol RequestProvider {

	/// The base URL to use for all requests.
	///
	/// This represents the root URL (e.g., `https://api.example.com`) to which
	/// paths, query parameters, and other details will be appended.
	var baseURL: URL { get }

	/// The specific path to append to the base URL.
	///
	/// This is usually the endpoint path that identifies the resource or action
	/// being requested (e.g., `/users`, `/posts/{id}`). The final URL will be a combination
	/// of the `baseURL` and this `path`.
	var path: String { get }

	/// The HTTP method to use for the request (e.g., `GET`, `POST`, `PUT`, `DELETE`).
	///
	/// This defines the type of operation to perform on the server, such as retrieving,
	/// creating, updating, or deleting data. The method is used when configuring the request.
	var method: HTTPMethod { get }

	/// The HTTP headers to include in the request. Default is `nil`
	///
	/// Headers provide additional information about the request, such as authentication
	/// credentials, content type, or any other metadata the server needs to process the request.
	var headers: [String: String]? { get }

	/// The query parameters to include in the URL for GET requests. Default is `nil`
	///
	/// Query parameters are key-value pairs that are appended to the URL (e.g., `?page=1&limit=10`).
	/// These parameters are typically used for filtering, pagination, or other search criteria.
	var queryParams: [String: String]? { get }

	/// The body parameters to include in the request (typically used with POST, PUT requests). Default is `nil`
	///
	/// These parameters are sent in the body of the request and often represent the data
	/// that is being created or updated on the server. The body parameters can be any
	/// valid data type, such as a dictionary, JSON, or multipart form data.
	var bodyParams: [String: Any]? { get }

	/// Function to create a fully configured `URLRequest` object based on the specified properties.
	///
	/// - Throws: An error if the URL cannot be constructed, or if there are issues with the encoding.
	/// - Returns: A fully configured `URLRequest` object, ready to be sent to the server.
	func createRequest() throws -> URLRequest
}

extension RequestProvider {

	var baseURL: URL {
		guard
			let url = URL(string: "https://api.coinranking.com/v2")
		else {
			fatalError("Base url cannot be constructed.")
		}
		return url
	}

	var headers: [String: String]? {
		["x-access-token": "coinrankingc6bda6b7df6395b714841bfdaffd64f993d9c16d98042125"]
	}
	
	var queryParams: [String: String]? { nil }
	var bodyParams: [String: Any]? { nil }

	func createRequest() throws -> URLRequest {
		// Build the base URL
		var url = baseURL.appendingPathComponent(path)

		// Append query parameters if available
		if let queryParams = queryParams, !queryParams.isEmpty {
			url = try addQueryParams(to: url, with: queryParams)
		}

		// Create the URLRequest object
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		// Set headers if available (headers can be empty)
		try setHeaders(for: &request)

		// Set the body depending on encoding type
		try setBody(for: &request)

		return request
	}

	// MARK: - Helper Methods

	// Appends query parameters to the URL, ensuring proper URL encoding
	private func addQueryParams(to url: URL, with params: [String: String]) throws -> URL {
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

		// Ensure query parameters are URL encoded
		let queryItems = params.compactMap { key, value -> URLQueryItem? in
			guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
				  let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
				return nil
			}
			return URLQueryItem(name: encodedKey, value: encodedValue)
		}

		components?.queryItems = queryItems

		guard let finalURL = components?.url else {
			throw AppError.requestError(.invalidURL("Failed to construct URL with query parameters."))
		}
		return finalURL
	}

	// Sets headers on the URLRequest
	private func setHeaders(for request: inout URLRequest) throws {
		// If headers are provided, set them. If headers is empty, no error is thrown.
		if let headers {
			for (key, value) in headers {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
	}

	// Sets the body for the URLRequest depending on the encoding type
	private func setBody(for request: inout URLRequest) throws {
		guard let bodyParams = bodyParams else { return }

		// Serialize bodyParams into JSON
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
			request.httpBody = jsonData
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		} catch {
			throw AppError.requestError(.invalidBody("Failed to serialize body parameters to JSON."))
		}
	}
}
