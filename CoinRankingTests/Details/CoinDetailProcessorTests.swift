//
//  CoinDetailProcessorTests.swift
//  CoinRanking
//
//  Created by Amol Prakash on 21/01/25.
//

@testable import CoinRanking
import XCTest

class CoinDetailProcessorTests: XCTestCase {

	func testProcessDataSuccess() throws {
		let dataProcessor = CoinDetailProcessor()
		let result = try dataProcessor.processData(DummyData.coinDetailResponseData)
		XCTAssertNotNil(result, "The result should be a valid CoinDetailResponse.")
		XCTAssertEqual(result.status, "success", "The status should be success.")
		XCTAssertNotNil(result.data.coin, "Coin details should be not nil.")
	}
	func testProcessDataFailureInvalidJSON() throws {
		let dataProcessor = CoinDetailProcessor()
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
