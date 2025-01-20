//
//  LargeNumberUnit.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

/// An enumeration representing large number units for formatting purposes.
///
/// `LargeNumberUnit` defines the units used to represent large numbers in a human-readable format.
/// Each case corresponds to a specific magnitude, with an associated raw value and a suffix for display.
enum LargeNumberUnit: Double {
	/// Represents one trillion (1,000,000,000,000) with the suffix "T".
	case trillion = 1_000_000_000_000

	/// Represents one billion (1,000,000,000) with the suffix "B".
	case billion = 1_000_000_000

	/// Represents one million (1,000,000) with the suffix "M".
	case million = 1_000_000

	/// Represents numbers smaller than a million, with no suffix.
	case none = 1 // For numbers smaller than a million

	/// A computed property that returns the appropriate suffix for the unit.
	///
	/// - Returns: A string representing the suffix for the unit.
	var suffix: String {
		switch self {
		case .trillion:
			return "T"
		case .billion:
			return "B"
		case .million:
			return "M"
		case .none:
			return ""
		}
	}
}
