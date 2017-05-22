//
//  VoxUser.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 26/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

let voxLoginKey = "voxLoginKey"
let voxPasswordKey = "voxPasswordKey"

class VoxUser: NSObject, NSCoding {
    
    let voxLogin:String
    let voxPassword:String
    

    init(withLogin login:String, password:String) {
        self.voxLogin = login
        self.voxPassword = password
    }
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(voxLoginKey) as! String
        let password = aDecoder.decodeObjectForKey(voxPasswordKey) as! String
        self.init(withLogin:name, password:password)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(voxLogin, forKey: voxLoginKey)
        aCoder.encodeObject(voxPassword, forKey: voxPasswordKey)
    }
}
