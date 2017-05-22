//
//  NibAndID.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 21/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

extension UIView {
    class func nib() -> UINib? {
        let className = String(self)
        return UINib(nibName:className , bundle: nil)
    }
    
    class func identifier() -> String {
        let className = String(self)
        let str = "k\(className)Identifier"
        
        return str
    }
}
