//
//  ShoppingItem+CoreDataProperties.swift
//  Core Data Demo
//
//  Created by Shien on 2022/8/18.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?

}

extension ShoppingItem : Identifiable {

}
