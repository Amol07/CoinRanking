//
//  CoinDetailResponse.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

// MARK: - CoinDetailResponse
struct CoinDetailResponse: Codable {
    let status: String
    let data: CoinDetailData
}

// MARK: - CoinDetailData
struct CoinDetailData: Codable {
    let coin: CoinDetails?
}

// MARK: - CoinDetails
struct CoinDetails: Codable {
	let uuid: String
	let symbol, name, description: String?
    let color: String?
    let iconURL: String?
    let websiteURL: String?
    let links: [LinkDetail]?
    let supply: Supply?
    let the24HVolume, marketCap, fullyDilutedMarketCap, price: String?
    let btcPrice: String?
    let priceAt: Int?
    let change: String?
    let rank, numberOfMarkets, numberOfExchanges: Int?
    let sparkline: [String?]?
    let allTimeHigh: AllTimeHigh?
    let coinrankingURL: String?
    let listedAt: Int?
    let notices: [Notice]?
    let contractAddresses, tags: [String]?

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply
        case the24HVolume = "24hVolume"
        case marketCap, fullyDilutedMarketCap, price, btcPrice, priceAt, change, rank, numberOfMarkets, numberOfExchanges, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
        case listedAt, notices, contractAddresses, tags
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    let price: String?
    let timestamp: Int?
}

// MARK: - Link
struct LinkDetail: Codable {
    let name: String?
    let url: String?
    let type: String?
}

// MARK: - Notice
struct Notice: Codable {
    let type, value: String?
}

// MARK: - Supply
struct Supply: Codable {
    let supplyAt: Int?
    let circulating, total, max: String?
}
