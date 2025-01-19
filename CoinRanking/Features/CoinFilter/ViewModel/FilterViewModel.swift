//
//  FilterViewModel.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//

import Combine
import Foundation

enum OrderOption: String {
    case ascending = "asc"
    case descending = "desc"

    var textValue: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        }
    }
}

enum FilterOption: String {
    case price = "price"
    case oneDayPerformance = "change"

    var textValue: String {
        switch self {
        case .price:
            return "Price"
        case .oneDayPerformance:
            return "24-hour Performance"
        }
    }
}

class FilterViewModel {

    private(set) var selectedFilter: FilterOption?
    private(set) var selectedOrder: OrderOption?

    private(set) var applyFilterPublisher = PassthroughSubject<Void, Never>()

    let filterOptions: [FilterOption] = [.price, .oneDayPerformance]
    let orderOptions: [OrderOption] = [OrderOption.ascending, OrderOption.descending]

    func reset() {
        self.selectedFilter = nil
        self.selectedOrder = nil
        self.applyFilterPublisher.send()
    }

    func save(selectedFilter: FilterOption?, selectedOrder: OrderOption?) {
        self.selectedFilter = selectedFilter
        self.selectedOrder = selectedOrder
        self.applyFilterPublisher.send()
    }
}
