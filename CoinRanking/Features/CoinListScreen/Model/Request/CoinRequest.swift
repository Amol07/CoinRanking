//
//  CoinRequest.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import Foundation

enum CoinRequest {
	case coinList(offset: Int,
				  limit: Int,
				  timePeriod: String,
				  orderBy: String, orderDirection: String)
}

extension CoinRequest: RequestProvider {
	var path: String { "/coins" }
	var method: HTTPMethod { .GET }
	var queryParams: [String : String]? {
		switch self {
		case let .coinList(offset, limit, timePeriod, orderBy, orderDirection):
			return [
				"offset": "\(offset)",
				"limit": "\(limit)",
				"timePeriod": timePeriod,
				"orderBy": orderBy,
				"orderDirection": orderDirection
			]
		}
	}
}
