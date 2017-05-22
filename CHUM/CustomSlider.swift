//
//  CustomSlider.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 19/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRectForBounds(customBounds)
        return customBounds
    }
    
    
}
