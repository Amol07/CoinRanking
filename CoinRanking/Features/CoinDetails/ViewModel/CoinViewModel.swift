//
//  CoinViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

class CoinViewModel {
    private let coin: CoinDetails

	init(coin: CoinDetails) {
        self.coin = coin
    }

	// Computed properties for formatted values
	var uuid: String { coin.uuid }
	var iconURL: String { coin.iconURL }
	var name: String { coin.name }
	var symbol: String { coin.symbol }
	var formattedPrice: String {
		guard let price = Double(coin.price) else { return "N/A" }
		return String(format: "%.2f", price)
	}
	var change: String { coin.change }

	var formattedMarketCap: String { CurrencyFormatter.formattedValue(coin.marketCap) }
	var formatted24HourVolume: String { CurrencyFormatter.formattedValue(coin.the24HVolume) }
	var formattedAllTimeHigh: String { CurrencyFormatter.formattedValue(coin.allTimeHigh.price) }
	var rank: String { "\(coin.rank)" }

	var formattedCirculatingSupply: String { CurrencyFormatter.formattedValue(coin.supply.circulating) }
	var formattedTotalSupply: String { CurrencyFormatter.formattedValue(coin.supply.total) }
	var formattedMaxSupply: String { CurrencyFormatter.formattedValue(coin.supply.max) }

	var description: String { coin.description }
	var webUrl: String { coin.websiteURL }
	var sparkline: [String] { coin.sparkline.compactMap { $0 } }
}
