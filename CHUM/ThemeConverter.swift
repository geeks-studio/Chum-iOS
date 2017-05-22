//
//  ThemeConverter.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class ThemeConverter: NSObject {
    class func convertPlace(place:CHMPlace) -> ThemePresenterProtocol {
        let themePresenter = ThemePresenter()
        themePresenter.themeName = place.placeName
        themePresenter.imageURL = place.placeURL
        return themePresenter
    }

}
