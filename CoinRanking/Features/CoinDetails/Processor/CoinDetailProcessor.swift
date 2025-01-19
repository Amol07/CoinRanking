//
//  CoinDetailProcessor.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A class responsible for processing raw `Data` into a `CoinDetailResponse` object.
///
/// `CoinDetailProcessor` is a concrete subclass of `BaseProcessor` that specializes in decoding raw `Data`
/// into a `CoinDetailResponse` model. This class implements the `processData` method to decode the raw data
/// into a structured response model, handling any errors during decoding and throwing appropriate application-level errors.
///
/// - Inherits from: `BaseProcessor<Data, CoinDetailResponse>`
/// - Generic Parameters:
///   - `InputData`: `Data`, the raw input data to be processed.
///   - `ProcessedData`: `CoinDetailResponse`, the type of data returned after processing.
class CoinDetailProcessor: BaseProcessor<Data, CoinDetailResponse> {

	/// Decodes raw `Data` into a `CoinDetailResponse` object.
	///
	/// This method attempts to decode the provided `Data` using `JSONDecoder`. If decoding succeeds, it returns the
	/// decoded `CoinDetailResponse` object. If decoding fails, it throws an `AppError.networkError` with a `decodingError`
	/// to indicate the failure and provide the underlying error details.
	///
	/// - Parameter data: The raw `Data` that needs to be decoded into a `CoinDetailResponse` model.
	/// - Returns: A decoded `CoinDetailResponse` object.
	/// - Throws: An `AppError.networkError` with a `decodingError` if the data cannot be successfully decoded into a `CoinDetailResponse`.
	override func processData(_ data: Data) throws -> CoinDetailResponse {
		do {
			// Attempt to decode the raw data into the expected response model
			let decodedData = try JSONDecoder().decode(CoinDetailResponse.self, from: data)
			return decodedData
		} catch {
			// Handle any decoding errors and throw them as a network-related error
			throw AppError.networkError(.decodingError(error))
		}
	}
}
