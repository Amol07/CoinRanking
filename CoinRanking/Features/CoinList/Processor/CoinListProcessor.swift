//
//  CoinListProcessor.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A class responsible for processing raw `Data` into a `CoinListResponse` object.
///
/// `CoinListProcessor` is a concrete subclass of `BaseProcessor` that specializes in decoding raw `Data`
/// into a `CoinListResponse` model. This class implements the `processData` method to decode the raw data
/// into a structured response model, handling any errors during decoding and throwing appropriate application-level errors.
///
/// - Inherits from: `BaseProcessor<Data, CoinListResponse>`
/// - Generic Parameters:
///   - `InputData`: `Data`, the raw input data to be processed.
///   - `ProcessedData`: `CoinListResponse`, the type of data returned after processing.
class CoinListProcessor: BaseProcessor<Data, CoinListResponse> {

	/// Decodes raw `Data` into a `CoinListResponse` object.
	///
	/// This method attempts to decode the provided `Data` using `JSONDecoder`. If decoding succeeds, it returns the
	/// decoded `CoinListResponse` object. If decoding fails, it throws an `AppError.networkError` with a `decodingError`
	/// to indicate the failure and provide the underlying error details.
	///
	/// - Parameter data: The raw `Data` that needs to be decoded into a `CoinListResponse` model.
	/// - Returns: A decoded `CoinListResponse` object.
	/// - Throws: An `AppError.networkError` with a `decodingError` if the data cannot be successfully decoded into a `CoinListResponse`.
	override func processData(_ data: Data) throws -> CoinListResponse {
		do {
			// Attempt to decode the raw data into the expected response model
			let decodedData = try JSONDecoder().decode(CoinListResponse.self, from: data)
			return decodedData
		} catch {
			// Handle any decoding errors and throw them as a network-related error
			throw AppError.networkError(.decodingError(error))
		}
	}
}
