//
//  CoinRequest.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

/// An enumeration representing different types of coin-related network requests.
///
/// `CoinRequest` defines the various endpoints available in the CoinRanking API. Each case corresponds to a specific
/// API endpoint, with associated values to provide necessary parameters for the request.
enum CoinRequest {
	/// Fetches a list of coins with pagination and sorting options.
	///
	/// - Parameters:
	///   - offset: The starting point for the list of coins to fetch.
	///   - limit: The maximum number of coins to fetch.
	///   - timePeriod: The time period for which to fetch data (e.g., "24h", "7d").
	///   - orderBy: The field by which to order the coins (e.g., "marketCap").
	///   - orderDirection: The direction of the sort (e.g., "desc" for descending).
	case coinList(offset: Int,
				  limit: Int,
				  timePeriod: String,
				  orderBy: String?,
				  orderDirection: String?)

	/// Fetches detailed information about a specific coin.
	///
	/// - Parameters:
	///   - uuid: The unique identifier of the coin.
	///   - timePeriod: The time period for which to fetch data (e.g., "24h", "7d").
	case coinDetails(uuid: String,
					 timePeriod: String)

	/// Fetches the price history of a specific coin.
	///
	/// - Parameters:
	///   - uuid: The unique identifier of the coin.
	///   - timePeriod: The time period for which to fetch data (e.g., "24h", "7d").
	case coinPriceHistory(uuid: String,
						  timePeriod: String)
}

extension CoinRequest: RequestProvider {
	/// The path component of the URL for the request.
	///
	/// - Returns: A string representing the path component of the URL.
	var path: String {
		switch self {
		case .coinList:
			return "/coins"
		case let .coinDetails(uuid, _):
			return "/coin/\(uuid)"
		case let .coinPriceHistory(uuid, _):
			return "/coin/\(uuid)/history"
		}
	}

	/// The HTTP method for the request.
	///
	/// - Returns: The HTTP method to be used for the request.
	var method: HTTPMethod { .GET }

    /// The query parameters for the request.
    ///
    /// - Returns: A dictionary of query parameters to be included in the request.
	var queryParams: [String: String]? {
		switch self {
		case let .coinList(offset, limit, timePeriod, orderBy, orderDirection):
			var params: [String: String] = [
				"offset": "\(offset)",
				"limit": "\(limit)",
				"timePeriod": timePeriod
			]
			if let orderBy {
				params["orderBy"] = orderBy
			}
			if let orderDirection {
				params["orderDirection"] = orderDirection
			}
			return params

		case let .coinDetails(_, timePeriod), let .coinPriceHistory(_, timePeriod):
			return [
				"timePeriod": timePeriod
			]
		}
	}
}
