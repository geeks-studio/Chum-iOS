//
//  PlaceType.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class PlaceType: NSObject {
    let placeType:String
    
    init(withPlaceType placeType:String) {
        self.placeType = placeType
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? PlaceType {
            return placeType == object.placeType
        } else {
            return false
        }
    }
    
    override var hash: Int {
        return placeType.hash
    }


}
