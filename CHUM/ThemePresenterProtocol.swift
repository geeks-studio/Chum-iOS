//
//  ThemePresenterProtocol.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

protocol ThemePresenterProtocol {
    var themeName:String {get}
    var userCount:String? {get}
    var isFavorite:Bool {get}
    var coverColor:UIColor? {get}
    var imageURL:NSURL? {get}
}

