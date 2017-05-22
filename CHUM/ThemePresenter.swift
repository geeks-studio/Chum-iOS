//
//  ThemePresenter.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class ThemePresenter: NSObject, ThemePresenterProtocol {
    var themeName: String = ""
    var userCount: String?
    var isFavorite: Bool = false
    
    var coverColor:UIColor?
    var imageURL:NSURL? 
}
