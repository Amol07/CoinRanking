//
//  ViewController.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		Task {
			do {
				try await fetchData()
			} catch {
				print(error)
			}
		}
	}

	func fetchData() async throws {
		let request = CoinRequest.coinList(offset: 0, limit: 20, timePeriod: "5y", orderBy: "price", orderDirection: "asc")
		let response = try await CoinListService().fetchCoinList(request: request)
		print(response)
	}
}
