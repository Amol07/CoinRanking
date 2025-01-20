//
//  AppError.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// An enumeration that represents different types of errors that can occur during a network operation or request setup.
///
/// `AppError` is a wrapper enum that consolidates errors related to network operations (`NetworkError`) and errors
/// related to request setup (`RequestError`). This structure allows both types of errors to be handled uniformly while
/// maintaining clarity about the specific nature of the error.
///
/// `AppError` has two main categories:
/// 1. `NetworkError` for issues related to network operations such as connectivity, server errors, etc.
/// 2. `RequestError` for issues related to the setup or sending of the network request, such as invalid URLs, missing headers, etc.
enum AppError: Error {

	// MARK: - Network-related errors
	/// A network-related error that encapsulates different types of network failures.
	case networkError(NetworkError)

	// MARK: - Request-related errors
	/// A request-related error that captures issues during the setup or sending of the network request.
	case requestError(RequestError)

	// MARK: - Localized descriptions for user-facing messages

	/// A localized description for the error case, suitable for user-facing messages.
	///
	/// This property returns a localized error message depending on the type of error (`networkError` or `requestError`).
	/// The localized message is user-friendly and can be displayed in the UI or logged.
	var localizedDescription: String {
		switch self {
		case .networkError(let networkError):
			return networkError.localizedDescription
		case .requestError(let requestError):
			return requestError.localizedDescription
		}
	}

	/// An enumeration that represents different types of errors that can occur during a network operation.
	///
	/// `NetworkError` covers errors arising from network connectivity issues, server errors, timeout, unauthorized access,
	/// data decoding issues, invalid responses, and other unforeseen errors.
	/// Each case provides a localized error description for display in the UI or logs.
	enum NetworkError: Error {

		/// No internet connection is available.
		/// This error occurs when the device cannot connect to the internet.
		case noInternet

		/// The network request timed out.
		/// This error occurs when the request takes longer than the allowed timeout duration.
		case timeout

		/// The server returned an error response (e.g., 500 or 503).
		/// This error occurs when the server encounters an issue, such as a 500 or 503 status code.
		case serverError(statusCode: Int)

		/// The request was unauthorized (e.g., 401).
		/// This error occurs when the request is missing valid authentication credentials.
		case unauthorized

		/// The response data could not be decoded into the expected format.
		/// This error occurs when the server response is not in the expected format, often due to mismatched model structures.
		case decodingError(Error)

		/// The server's response was invalid or unexpected.
		/// This error occurs when the response from the server does not meet the expected structure.
		case invalidResponse

		/// An unknown error occurred, possibly due to an unforeseen condition.
		/// This is a generic error used when no other specific error type applies.
		case unknownError

		/// A localized description for the network-related error case.
		///
		/// This property returns a user-friendly error message tailored to the specific network error that occurred.
		/// The message is suitable for displaying to users or logging.
		var localizedDescription: String {
			switch self {
			case .noInternet:
				return NSLocalizedString("No internet connection.", comment: "Error message for no internet connection.")
			case .timeout:
				return NSLocalizedString("The request timed out. Please check your connection and try again.", comment: "Error message for request timeout.")
			case .serverError:
				return NSLocalizedString("The server encountered an error. Please try again later.", comment: "Error message for server error.")
			case .unauthorized:
				return NSLocalizedString("Unauthorized access. Please check your credentials.", comment: "Error message for unauthorized access.")
			case .decodingError:
				return NSLocalizedString("Failed to decode response data. Please try again later.", comment: "Error message for decoding failure.")
			case .invalidResponse:
				return NSLocalizedString("The server's response was invalid. Please try again.", comment: "Error message for invalid response from the server.")
			case .unknownError:
				return NSLocalizedString("An unknown error occurred. Please try again.", comment: "Error message for an unknown error.")
			}
		}
	}

	/// An enumeration that represents different types of errors that can occur during a network request.
	///
	/// `RequestError` covers errors that happen during the creation and setup of a network request, such as invalid URLs,
	/// invalid body content, and other issues related to preparing the request.
	/// Each case provides a localized error description for display in the UI or logs.
	enum RequestError: Error {

		/// The provided URL is invalid.
		/// This error occurs when the URL for the network request is malformed or cannot be resolved.
		case invalidURL(String)

		/// The body of the request is invalid.
		/// This error occurs when the body of the request (such as JSON or form data) is malformed or does not meet the expected format.
		case invalidBody(String)

		/// A localized description for the request-related error case.
		///
		/// This property returns a user-friendly error message tailored to the specific request error that occurred.
		/// The message is suitable for displaying to users or logging.
		var localizedDescription: String {
			switch self {
			case .invalidURL(let urlString):
				return NSLocalizedString("The URL is invalid: \(urlString). Please check the URL and try again.", comment: "Error message for invalid URL")
			case .invalidBody(let body):
				return NSLocalizedString("The body of the request is invalid: \(body). Please check the body and try again.", comment: "Error message for invalid body")
			}
		}
	}
}

extension AppError: Equatable {
	static func == (lhs: AppError, rhs: AppError) -> Bool {
		switch (lhs, rhs) {
		case (.networkError(let leftNetworkError), .networkError(let rightNetworkError)):
			return leftNetworkError == rightNetworkError
		case (.requestError(let leftRequestError), .requestError(let rightRequestError)):
			return leftRequestError == rightRequestError
		default:
			return false
		}
	}
}

extension AppError.NetworkError: Equatable {
	static func == (lhs: AppError.NetworkError, rhs: AppError.NetworkError) -> Bool {
		switch (lhs, rhs) {
		case (.noInternet, .noInternet),
			(.timeout, .timeout),
			(.unauthorized, .unauthorized),
			(.invalidResponse, .invalidResponse),
			(.unknownError, .unknownError):
			return true
		case (.serverError(let status1), .serverError(let status2)):
			return status1 == status2
		case (.decodingError(let leftError), .decodingError(let rightError)):
			return String(describing: leftError) == String(describing: rightError)
		default:
			return false
		}
	}
}

extension AppError.RequestError: Equatable {
	static func == (lhs: AppError.RequestError, rhs: AppError.RequestError) -> Bool {
		switch (lhs, rhs) {
		case (.invalidURL(let leftURL), .invalidURL(let rightURL)):
			return leftURL == rightURL
		case (.invalidBody(let leftBody), .invalidBody(let rightBody)):
			return leftBody == rightBody
		default:
			return false
		}
	}
}
