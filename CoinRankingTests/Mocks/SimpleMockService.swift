//
//  SimpleMockService.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import Foundation
@testable import CoinRanking

class SimpleMockService<T> {

	let results: Result<T, AppError>

	init(results: Result<T, AppError>) {
		self.results = results
	}

	func asyncResults() async throws -> T {
		switch results {
			case let .success(value):
				return value
			case let .failure(error):
				throw error
		}
	}
}
