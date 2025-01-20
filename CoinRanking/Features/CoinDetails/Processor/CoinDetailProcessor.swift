//
//  CoinDetailProcessor.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

/// A processor class that decodes raw `Data` into a `CoinDetailResponse` model.
///
/// This subclass of `BaseProcessor` is responsible for decoding raw `Data` into a `CoinDetailResponse` object using `JSONDecoder`.
/// In case of a decoding failure, it throws an `AppError.networkError` with the decoding error details.
///
/// - Inherits: `BaseProcessor<Data, CoinDetailResponse>`
class CoinDetailProcessor: BaseProcessor<Data, CoinDetailResponse> {

	/// Decodes raw `Data` into a `CoinDetailResponse` object.
	///
	/// This method attempts to decode the provided `Data` using `JSONDecoder`. If successful, it returns the decoded
	/// `CoinDetailResponse` object. If decoding fails, it throws an `AppError.networkError` with details of the error.
	///
	/// - Parameter data: The raw `Data` to be decoded into the response model.
	/// - Returns: The decoded `CoinDetailResponse` object.
	/// - Throws: `AppError.networkError` if the data can't be decoded properly.
	override func processData(_ data: Data) throws -> CoinDetailResponse {
		do {
			// Decoding the raw data into the expected response model
			let decodedData = try JSONDecoder().decode(CoinDetailResponse.self, from: data)
			return decodedData
		} catch {
			// Throwing a network error with the decoding error details
			throw AppError.networkError(.decodingError(error))
		}
	}
}
