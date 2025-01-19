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
				  orderBy: String?,
				  orderDirection: String?)

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

		case let .coinDetails(_, timePeriod):
			return [
				"timePeriod": timePeriod,
			]
		}
	}
}
