//
//  NoteItem+CoreDataProperties.swift
//  NoteAppFinal
//
//  Created by Gian Carlo Baldonado on 5/9/21.
//
//

import Foundation
import CoreData


extension NoteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteItem> {
        return NSFetchRequest<NoteItem>(entityName: "NoteItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var desc: String?

}

extension NoteItem : Identifiable {

}
