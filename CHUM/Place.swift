//
//  Place.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 01/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class Place: NSObject {
    
    dynamic var placeID:String?
    dynamic var placeName:String?
    dynamic var city:String?
    dynamic var lat:NSNumber?
    dynamic var lon:NSNumber?
    
    dynamic var isAdmin = false
    dynamic var isChoosed = false
    
    dynamic var placeURL:NSURL?
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Place {
            return placeID == object.placeID
        } else {
            return false
        }
    }
    
    override var hash: Int {
        return (placeID?.hash)!
    }
}
