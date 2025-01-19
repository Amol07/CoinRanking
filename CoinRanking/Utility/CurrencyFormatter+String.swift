//
//  CurrencyFormatter.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

enum CurrencyFormatter {
	static func formatLargeNumber(_ value: Double) -> String {
		let unit: LargeNumberUnit

		switch value {
			case LargeNumberUnit.trillion.rawValue...:
				unit = .trillion
			case LargeNumberUnit.billion.rawValue...:
				unit = .billion
			case LargeNumberUnit.million.rawValue...:
				unit = .million
			default:
				unit = .none
		}
		let formattedValue = value / unit.rawValue
		return String(format: "%.2f%@", formattedValue, unit.suffix)
	}

	static func formattedValue(_ stringValue: String?) -> String {
		guard let stringValue = stringValue, let value = Double(stringValue) else { return "N/A" }
		return formatLargeNumber(value)
	}
}
