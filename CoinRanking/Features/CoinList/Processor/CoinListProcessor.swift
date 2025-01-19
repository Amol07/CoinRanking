//
//  CoinListProcessor.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A class responsible for processing raw `Data` into a `CoinListResponse` object.
///
/// The `CoinListProcessor` class is a concrete subclass of `BaseProcessor` that specializes in decoding raw `Data`
/// into a structured `CoinListResponse` model. This class implements the `processData` method, which attempts to decode
/// the raw data into a strongly-typed response model. If the decoding fails, the error is captured and rethrown as a
/// network-related error for consistent error handling in the application.
///
/// - Inherits from: `BaseProcessor<Data, CoinListResponse>`
/// - Generic Parameters:
///   - `InputData`: `Data`, which represents the raw input data to be processed.
///   - `ProcessedData`: `CoinListResponse`, which represents the decoded model returned after processing.
class CoinListProcessor: BaseProcessor<Data, CoinListResponse> {

	// MARK: - Method

	/// Decodes the raw `Data` into a `CoinListResponse` object.
	///
	/// This method utilizes `JSONDecoder` to decode the raw data into a `CoinListResponse` object. If the decoding process
	/// succeeds, the decoded `CoinListResponse` is returned. If an error occurs during decoding, an `AppError.networkError`
	/// is thrown with a `decodingError` that includes the details of the error. This ensures that all decoding errors are
	/// uniformly handled and provides meaningful error messages for troubleshooting.
	///
	/// - Parameter data: The raw `Data` object that is to be decoded into a `CoinListResponse`.
	/// - Returns: A decoded `CoinListResponse` object containing the parsed data.
	/// - Throws: An `AppError.networkError` with a `decodingError` if decoding fails, along with the underlying error details.
	override func processData(_ data: Data) throws -> CoinListResponse {
		do {
			// Attempt to decode the raw data into the expected `CoinListResponse` model
			let decodedData = try JSONDecoder().decode(CoinListResponse.self, from: data)
			return decodedData
		} catch {
			// If decoding fails, throw a network-related error with the decoding error
			throw AppError.networkError(.decodingError(error))
		}
	}
}
