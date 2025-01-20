//
//  JSONFunctions.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//

import Foundation

class JSONFunctions {

	static func getDummyType<T: Decodable>(_ jsonResource: String) -> T? {
		do {
			guard let url = Bundle(for: JSONFunctions.self).url(forResource: jsonResource, withExtension: "json") else {
				print("Failed to load data with the resource name: \(jsonResource)")
				return nil
			}
			let data = try Data(contentsOf: url, options: .mappedIfSafe)
			let object = try JSONDecoder().decode(T.self, from: data)
			return object
		} catch {
			print("Failed to load data with the resource name: \(jsonResource)")
		}
		return nil
	}

	static func getDummyType(_ jsonResource: String) -> Data? {
		do {
			guard let url = Bundle(for: JSONFunctions.self).url(forResource: jsonResource, withExtension: "json") else {
				print("Failed to load data with the resource name: \(jsonResource)")
				return nil
			}
			let data = try Data(contentsOf: url, options: .mappedIfSafe)
			return data
		} catch {
			print("Failed to load data with the resource name: \(jsonResource)")
		}
		return nil
	}
}
