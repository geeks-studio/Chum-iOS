//
//  StoredAction.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 24/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class StoredAction: NSObject {
    
    let payload:[String:AnyObject]
    
    init(withPayload payload:[String:AnyObject]) {
        self.payload = payload
    }

}
