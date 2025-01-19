//
//  LargeNumberUnit.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

enum LargeNumberUnit: Double {
    case trillion = 1_000_000_000_000
    case billion = 1_000_000_000
    case million = 1_000_000
    case none = 1 // For numbers smaller than a million

    var suffix: String {
        switch self {
        case .trillion: return "T"
        case .billion: return "B"
        case .million: return "M"
        case .none: return ""
        }
    }
}
