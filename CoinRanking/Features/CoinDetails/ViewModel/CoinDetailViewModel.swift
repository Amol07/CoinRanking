//
//  CoinDetailViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import SwiftUI

// MARK: - ViewModel
class CoinDetailViewModel: ObservableObject {

	// MARK: - Nested Types

	/// Enum representing the possible states of the view.
	/// Helps control UI state by indicating whether data is loading, loaded, empty, or if there was an error.
	enum ViewState: Equatable {
		case loading
		case loaded(CoinViewModel)
		case empty
		case error

		/// Compares two `ViewState` values for equality.
		/// Determines whether the view state has changed.
		static func == (lhs: ViewState, rhs: ViewState) -> Bool {
			switch (lhs, rhs) {
			case (.loading, .loading), (.empty, .empty), (.error, .error):
				return true
			case (.loaded(let lhsCoins), .loaded(let rhsCoins)):
				return lhsCoins.uuid == rhsCoins.uuid
			default:
				return false
			}
		}
	}

	// MARK: - Properties
	/// The current state of the view, such as loading, loaded with data, empty, or error.
	@Published var state: ViewState
	/// A list of historical price data for the coin.
	@Published var history: [History]?
	/// The selected chart filter for time periods (e.g., 24 hours, 1 hour).
	@Published var selectedChartFilter: ChartFilter = .twentyFourHours

	private let coinID: String

	// MARK: - Initialization
	/// Initializes the `CoinDetailViewModel` with the provided coin ID and initial state.
	///
	/// - Parameters:
	///   - coinID: The unique identifier for the coin.
	///   - state: The initial state of the view (defaults to `.loading`).
	init(coinID: String, state: ViewState = .loading) {
		self.coinID = coinID
		self.state = state
	}

	// MARK: - Methods

	/// Fetches the coin details for a specific time period.
	///
	/// This method makes an asynchronous request to fetch the coin details and updates the state with the result.
	/// If successful, it updates the view state to `.loaded` with the `CoinViewModel`. If an error occurs, it updates
	/// the state to `.error` and prints the error.
	///
	/// - Parameter timePeriod: The time period for which the coin details are requested (e.g., "24h", "7d").
	/// - Parameter service: The service responsible for fetching the coin details (defaults to `CoinDetailService`).
	@MainActor
	func fetchCoinDetails(
		timePeriod: String,
		service: CoinDetailServiceProvider = CoinDetailService()
	) async {
		state = .loading
		do {
			let request = CoinRequest.coinDetails(uuid: coinID, timePeriod: timePeriod)
			let response = try await service.fetchCoinDetail(request: request)
			if let coin = response.data.coin {
				let coinViewModel = CoinViewModel(coin: coin)
				self.state = .loaded(coinViewModel)
			} else {
				self.state = .empty
			}
		} catch {
			// Handle errors and update state to error
			print("Error fetching coin details: \(error.localizedDescription)")
			state = .error
		}
	}

	/// Fetches the price history for the coin for a specific time period.
	///
	/// This method fetches the coin's price history and updates the `history` property. If an error occurs, it sets
	/// `history` to `nil` and prints the error.
	///
	/// - Parameter timePeriod: The time period for which the price history is requested (e.g., "24h", "1y").
	/// - Parameter service: The service responsible for fetching the price history (defaults to `CoinPriceHistoryService`).
	@MainActor
	func fetchPriceHistory(
		timePeriod: String,
		service: CoinPriceHistoryServiceProvider = CoinPriceHistoryService()
	) async {
		do {
			let request = CoinRequest.coinPriceHistory(uuid: coinID, timePeriod: timePeriod)
			let response = try await service.fetchCoinPriceHistory(request: request)
			self.history = response.data.history.filter { $0.price != nil }.reversed()
		} catch {
			// Handle errors and set history to nil
			self.history = nil
			print("Error fetching price history: \(error.localizedDescription)")
		}
	}

	/// Retrieves the filtered chart data based on the selected chart filter.
	///
	/// - Returns: The filtered history data or an empty array if the state is not `.loaded` or the history is nil.
	func getFilteredChartData() -> [History] {
		guard case .loaded = state, let history = history else { return [] }
		return history
	}
}

/// Enum representing the different chart filters for time periods.
enum ChartFilter: String, CaseIterable, Identifiable {
	case oneHour = "1h"
	case twentyFourHours = "24h"
	case sevenDays = "7d"
	case thirtyDays = "30d"
	case threeMonths = "3m"
	case oneYear = "1y"

	var id: String { self.rawValue }
}
