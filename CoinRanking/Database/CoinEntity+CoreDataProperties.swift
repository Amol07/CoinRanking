//
//  CoinEntity+CoreDataProperties.swift
//  CoinRanking
//
//  Created by Abhishek Kumar on 20/01/25.
//
//

import Foundation
import CoreData

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

extension CoinEntity : Identifiable {}
