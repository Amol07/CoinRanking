//
//  CoinEntity+CoreDataProperties.swift
//  CoinRanking
//
//  Created by Amol Prakash on 20/01/25.
//
//

import CoreData
import Foundation

extension CoinEntity {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CoinEntity> {
        return NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
    }

    @NSManaged public var uuid: String
    @NSManaged public var symbol: String
    @NSManaged public var name: String
    @NSManaged public var iconURL: String
}

extension CoinEntity: Identifiable {}
