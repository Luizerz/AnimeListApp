//
//  AnimeEntity+CoreDataProperties.swift
//  AnimeListApp
//
//  Created by Luiz Sena on 20/10/22.
//
//

import Foundation
import CoreData

extension AnimeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimeEntity> {
        return NSFetchRequest<AnimeEntity>(entityName: "AnimeEntity")
    }

    @NSManaged public var animeImage: String?
    @NSManaged public var detailText: String?
    @NSManaged public var malID: Int64
    @NSManaged public var malRating: Float
    @NSManaged public var title: String?
    @NSManaged public var isOnMyList: Bool
    @NSManaged public var episodes: Int64

}

extension AnimeEntity: Identifiable {

}
