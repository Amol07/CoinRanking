//
//  CoinListResponse.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

// MARK: - CoinListResponse
struct CoinListResponse: Codable {
	let status: String
	let data: CoinData
}

// MARK: - CoinData
struct CoinData: Codable {
	let stats: Stats
	let coins: [Coin]
}

// MARK: - Coin
struct Coin: Codable {
	let uuid, symbol, name: String
	let color: String?
	let iconURL: String
	let marketCap, price: String
	let listedAt, tier: Int
	let change: String?
	let rank: Int
	let sparkline: [String?]
	let lowVolume: Bool
	let coinrankingURL: String
	let the24HVolume, btcPrice: String
	let contractAddresses: [String]

	enum CodingKeys: String, CodingKey {
		case uuid, symbol, name, color
		case iconURL = "iconUrl"
		case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
		case coinrankingURL = "coinrankingUrl"
		case the24HVolume = "24hVolume"
		case btcPrice, contractAddresses
	}
}

// MARK: - Stats
struct Stats: Codable {
	let total, totalCoins, totalMarkets, totalExchanges: Int
	let totalMarketCap, total24HVolume: String

	enum CodingKeys: String, CodingKey {
		case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
		case total24HVolume = "total24hVolume"
	}
}
