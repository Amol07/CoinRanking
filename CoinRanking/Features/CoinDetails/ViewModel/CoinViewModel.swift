//
//  CoinViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

// MARK: - Coin ViewModel
/// A ViewModel that represents the details of a coin.
/// It exposes formatted values for the coin's attributes, such as price, market cap, and supply.
class CoinViewModel {
	private let coin: CoinDetails

	// MARK: - Initialization
	/// Initializes a `CoinViewModel` with the provided coin details.
	///
	/// - Parameter coin: The `CoinDetails` object containing the raw data for the coin.
	init(coin: CoinDetails) {
		self.coin = coin
	}

	// MARK: - Computed Properties

	/// The unique identifier for the coin.
	var uuid: String { coin.uuid }

	/// The URL of the coin's icon image.
	var iconURL: String { coin.iconURL }

	/// The name of the coin.
	var name: String { coin.name }

	/// The symbol of the coin (e.g., BTC for Bitcoin).
	var symbol: String { coin.symbol }

	/// The price of the coin, formatted as a currency string (e.g., "$ 12.34").
	var formattedPrice: String {
		guard let price = Double(coin.price) else { return "N/A" }
		return String(format: "$ %.2f", price)
	}

	/// The change in the coin's price, formatted with an arrow symbol (e.g., "▲ 5.23%").
	var changeText: String {
		let symbol = isNegativeChange ? "▼" : "▲"
		return "\(symbol) \(coin.change) %"
	}

	/// A boolean value indicating whether the coin's price change is negative.
	var isNegativeChange: Bool { coin.change.starts(with: "-") }

	/// The market capitalization of the coin, formatted as a currency string.
	var formattedMarketCap: String { CurrencyFormatter.formattedValue(coin.marketCap) }

	/// The 24-hour volume of the coin, formatted as a currency string.
	var formatted24HourVolume: String { CurrencyFormatter.formattedValue(coin.the24HVolume) }

	/// The all-time high price of the coin, formatted as a currency string.
	var formattedAllTimeHigh: String { CurrencyFormatter.formattedValue(coin.allTimeHigh.price) }

	/// The rank of the coin in the market (e.g., "1").
	var rank: String { "\(coin.rank)" }

	/// The circulating supply of the coin, formatted as a currency string.
	var formattedCirculatingSupply: String { CurrencyFormatter.formattedValue(coin.supply.circulating) }

	/// The total supply of the coin, formatted as a currency string.
	var formattedTotalSupply: String { CurrencyFormatter.formattedValue(coin.supply.total) }

	/// The maximum supply of the coin, formatted as a currency string.
	var formattedMaxSupply: String { CurrencyFormatter.formattedValue(coin.supply.max) }

	/// A description of the coin.
	var description: String { coin.description }

	/// The URL of the coin's official website.
	var webUrl: String { coin.websiteURL }
}
