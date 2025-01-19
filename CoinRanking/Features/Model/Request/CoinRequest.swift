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
				  orderBy: String,
				  orderDirection: String)

	case coinDetails(uuid: String,
					 timePeriod: String)
}

extension CoinRequest: RequestProvider {
	var path: String {
		switch self {
			case .coinList:
				"/coins"
			case let .coinDetails(uuid, _):
				"/coin/\(uuid)"
		}
	}

	var method: HTTPMethod { .GET }

	var queryParams: [String : String]? {
		switch self {
		case let .coinList(offset, limit, timePeriod, orderBy, orderDirection):
			[
				"offset": "\(offset)",
				"limit": "\(limit)",
				"timePeriod": timePeriod,
				"orderBy": orderBy,
				"orderDirection": orderDirection
			]
		case let .coinDetails(_, timePeriod):
			[
				"timePeriod": timePeriod,
			]
		}
	}
}
