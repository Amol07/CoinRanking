//
//  CoinPriceHistoryProcessorTests.swift
//  CoinRanking
//
//  Created by Amol Prakash on 21/01/25.
//

@testable import CoinRanking
import XCTest

class CoinPriceHistoryProcessorTests: XCTestCase {

	func testProcessDataSuccess() throws {
		let dataProcessor = CoinPriceHistoryProcessor()
		let result = try dataProcessor.processData(DummyData.coinPriceHistoryResponseData)
		XCTAssertNotNil(result, "The result should be a valid CoinPriceHistoryResponse.")
		XCTAssertEqual(result.status, "success", "The status should be success.")
		XCTAssertNotNil(result.data.history, "Coin price history should be not nil.")
		XCTAssertEqual(result.data.history.count, 2, "There should be 2 price history object.")
	}
	func testProcessDataFailureInvalidJSON() throws {
		let dataProcessor = CoinPriceHistoryProcessor()
		do {
			_ = try dataProcessor.processData(DummyData.inValidData)
			XCTFail("Expected decoding error but got success")
		} catch let error as AppError {
			switch error {
			case let .networkError(networkError):
				XCTAssertNotNil(networkError)
			default:
				XCTFail("Unexpected error type: \(error)")
			}
		} catch {
			XCTFail("Unexpected error type: \(error)")
		}
	}
}
