//
//  CoinPriceHistoryResponse.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

// MARK: - PriceHistoryResponse
struct CoinPriceHistoryResponse: Codable {
	let status: String
	let data: PriceData
}

// MARK: - PriceData
struct PriceData: Codable {
	let change: String
	let history: [History]
}

// MARK: - History
struct History: Codable, Identifiable {
	var id = UUID()
	let price: String?
	let timestamp: Int

	enum CodingKeys: CodingKey {
		case price
		case timestamp
	}

	var formattedDate: String {
		let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
		let formatter = Date.formatter
		formatter.dateFormat = "MMM d, h:mm a"
		return formatter.string(from: date)
	}
}

extension Date {
	static let formatter = DateFormatter()
}
