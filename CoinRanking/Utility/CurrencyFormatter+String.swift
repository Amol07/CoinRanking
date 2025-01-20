//
//  CurrencyFormatter.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

/// A utility for formatting currency values into human-readable strings.
///
/// `CurrencyFormatter` provides methods to format large currency values into strings with appropriate units
/// (e.g., "million", "billion", "trillion") and to format string representations of currency values into
/// their corresponding formatted strings.
///
/// - Methods:
///   - `formatLargeCurrency(_:)`: Formats a large `Double` value into a string with the appropriate currency unit.
///   - `formattedValue(_:)`: Formats a string representation of a currency value into a formatted string.
enum CurrencyFormatter {

    /// Formats a large `Double` value into a string with the appropriate currency unit.
    ///
    /// This method takes a `Double` value and formats it into a string with a dollar sign, two decimal places,
    /// and an appropriate unit suffix (e.g., "M" for million, "B" for billion, "T" for trillion). If the value
    /// is less than 1.0, it is formatted with eight decimal places.
    ///
    /// - Parameter value: The `Double` value to format.
    /// - Returns: A string representing the formatted currency value.
    static func formatLargeNumber(_ value: Double) -> String {

        if value < 1.0 {
            // Handle small values as standard dollars
            return String(format: "$ %.8f", value)
        }

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
        return String(format: "$ %.2f%@", formattedValue, unit.suffix)
    }

	/// Formats a string representation of a currency value into a formatted string.
	///
	/// This method attempts to convert a string to a `Double` and then formats it using the `formatLargeCurrency(_:)`
	/// method. If the string cannot be converted to a `Double`, it returns "N/A".
	///
	/// - Parameter stringValue: The string representation of the currency value to format.
	/// - Returns: A string representing the formatted currency value, or "N/A" if the string cannot be converted.
	static func formattedValue(_ stringValue: String?) -> String {
		guard let stringValue = stringValue, let value = Double(stringValue) else { return "N/A" }
		return formatLargeNumber(value)
	}
}
