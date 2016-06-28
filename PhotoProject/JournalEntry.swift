//
//  JournalEntry.swift
//  PhotoProject
//
//  Created by John Regner on 6/26/16.
//  Copyright © 2016 WigglingScholars. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JournalEntry: NSManagedObject {

    @NSManaged var image: NSObject?
    @NSManaged var timeStamp: NSDate?

    var img: UIImage? {
        get {
            return image as? UIImage
        }
        set {
            image = newValue
        }
    }

}
