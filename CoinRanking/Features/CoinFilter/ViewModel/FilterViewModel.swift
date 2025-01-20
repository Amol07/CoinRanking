//
//  FilterViewModel.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import Combine
import Foundation

/// An enumeration representing the order options for sorting.
enum OrderOption: String {
    case ascending = "asc"   // Represents ascending order
    case descending = "desc" // Represents descending order

    /// A computed property that returns a user-friendly text representation of the order option.
    var textValue: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        }
    }
}

/// An enumeration representing the filter options available.
enum FilterOption: String {
    case price = "price"                // Represents filtering by price
    case oneDayPerformance = "change"   // Represents filtering by 24-hour performance

    /// A computed property that returns a user-friendly text representation of the filter option.
    var textValue: String {
        switch self {
        case .price:
            return "Price"
        case .oneDayPerformance:
            return "24-hour Performance"
        }
    }
}

/// A view model class that manages the filter and order options for a list of items.
class FilterViewModel {

    // MARK: - Public properties

    /// The currently selected filter option, if any.
    private(set) var selectedFilter: FilterOption?

    /// The currently selected order option, if any.
    private(set) var selectedOrder: OrderOption?

    /// A publisher that emits an event when the filter is applied.
    private(set) var applyFilterPublisher = PassthroughSubject<Void, Never>()

    /// An array of available filter options.
    let filterOptions: [FilterOption] = [.price, .oneDayPerformance]

    /// An array of available order options.
    let orderOptions: [OrderOption] = [OrderOption.ascending, OrderOption.descending]
    
    // MARK: - Public methods

    /// Resets the selected filter and order options to nil and notifies subscribers.
    func reset() {
        self.selectedFilter = nil
        self.selectedOrder = nil
        self.applyFilterPublisher.send() // Notify subscribers that the filter has been reset
    }

    /// Saves the selected filter and order options and notifies subscribers.
    ///
    /// - Parameters:
    ///   - selectedFilter: The filter option selected by the user, if any.
    ///   - selectedOrder: The order option selected by the user, if any.
    func save(selectedFilter: FilterOption?, selectedOrder: OrderOption?) {
        self.selectedFilter = selectedFilter
        self.selectedOrder = selectedOrder
        self.applyFilterPublisher.send() // Notify subscribers that the filter has been applied
    }
}
