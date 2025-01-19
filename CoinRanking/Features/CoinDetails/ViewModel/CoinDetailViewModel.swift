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

	/// An enumeration representing the possible states of the view.
	/// This helps control the UI by indicating whether the data is loading, loaded, empty, or if there was an error.
	enum ViewState: Equatable {
		case loading
		case loaded(CoinViewModel)
		case empty
		case error

		/// Compares two `ViewState` values for equality.
		/// This helps in determining whether the view state has changed.
		static func ==(lhs: ViewState, rhs: ViewState) -> Bool {
			switch (lhs, rhs) {
				case (.loading, .loading):
					return true
				case (.empty, .empty):
					return true
				case (.error, .error):
					return true
				case (.loaded(let lhsRaces), .loaded(let rhsRaces)):
					return lhsRaces.uuid == rhsRaces.uuid
				default:
					return false
			}
		}
	}

	/// The current state of the view, such as loading, loaded with data, empty, or error.
	@Published var state: ViewState

    @Published var selectedChartFilter: ChartFilter = .oneDay

	private let service: CoinDetailServiceProvider
	private let coinID: String

	init(coinID: String,
		 service: CoinDetailServiceProvider = CoinDetailService(),
		 state: ViewState = .loading) {
		self.coinID = coinID
		self.state = state
		self.service = service
	}

    // Simulated API call to fetch coin details
	@MainActor
	func fetchCoinDetails(timePeriod: String) async {
        // Replace with your actual API call
		do {
			let request = CoinRequest.coinDetails(uuid: coinID, timePeriod: timePeriod)
			let response = try await service.fetchCoinDetail(request: request)
			let coinViewModel = CoinViewModel(coin: response.data.coin)
			self.state = .loaded(coinViewModel)
		} catch {
			// handle errors here
		}

    }

    func getFilteredChartData() -> [Double] {
		guard case let .loaded(coinViewModel) = state else { return [] }
		let sparkline = coinViewModel.sparkline
        switch selectedChartFilter {
        case .oneDay: return Array(sparkline.prefix(24)).compactMap { Double($0) }
        case .sevenDays: return Array(sparkline.prefix(7 * 24)).compactMap { Double($0) }
        case .oneMonth: return sparkline.compactMap { Double($0) }
        }
    }
}

enum ChartFilter: String, CaseIterable, Identifiable {
    case oneDay = "1D"
    case sevenDays = "7D"
    case oneMonth = "1M"

    var id: String { self.rawValue }
}
