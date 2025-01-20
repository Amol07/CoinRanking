//
//  DummyData.swift
//  CoinRanking
//
//  Created by Amol Prakash on 21/01/25.
//

@testable import CoinRanking
import Foundation

enum DummyData {
	static var coinsResponse: CoinListResponse {
		guard let object: CoinListResponse = JSONFunctions.getDummyType("Coins") else {
			fatalError("Couldn't find Coins.json in the bundle.")
		}
		return object
	}

	static var coinDetailResponse: CoinDetailResponse {
		guard let object: CoinDetailResponse = JSONFunctions.getDummyType("CoinDetails") else {
			fatalError("Couldn't find CoinDetails.json in the bundle.")
		}
		return object
	}

	static var coinPriceHistoryResponse: CoinPriceHistoryResponse {
		guard let object: CoinPriceHistoryResponse = JSONFunctions.getDummyType("PriceHistory") else {
			fatalError("Couldn't find PriceHistory.json in the bundle.")
		}
		return object
	}

	static var coinsResponseData: Data {
		guard let object = JSONFunctions.getDummyType("Coins") else {
			fatalError("Couldn't find Coins.json in the bundle.")
		}
		return object
	}

	static var coinDetailResponseData: Data {
		guard let object = JSONFunctions.getDummyType("CoinDetails") else {
			fatalError("Couldn't find CoinDetails.json in the bundle.")
		}
		return object
	}

	static var coinPriceHistoryResponseData: Data {
		guard let object = JSONFunctions.getDummyType("PriceHistory") else {
			fatalError("Couldn't find PriceHistory.json in the bundle.")
		}
		return object
	}

	static var inValidData: Data {
		guard let object = JSONFunctions.getDummyType("InvalidResponse") else {
			fatalError("Couldn't find InvalidResponse.json in the bundle.")
		}
		return object
	}
}
