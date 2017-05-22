//
//  UserActivityPresenter.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

struct UserActivityPresenter: UserActivityPresenterProtocol {
    let typeImage: UIImage?
    let timeAgoText: String?
    let activityText: NSAttributedString?
    let postUrl:NSURL?
    let textHeight:CGFloat
    
//    static let heightHelper:CHMTextHeightHelper = {
//        let heightHelper = CHMTextHeightHelper(textWidth: 1)
//        return heightHelper
//    }()
    
    private let  widthWithoutImage:CGFloat = {
        let width = UIScreen.mainScreen().bounds.size.width - 40 - 8 - 12 - 8 - 15 - 8
        return width
    }()
    
    private var widthWithImage:CGFloat = {
        let width = UIScreen.mainScreen().bounds.size.width - 40 - 8 - 12 - 8 - 44 - 8
        return width
    }()
    
    init(activityText:NSAttributedString, typeImage:UIImage, timeAgoText:String, imageURL:NSURL? = nil) {
        self.activityText = activityText
        self.timeAgoText = timeAgoText
        self.typeImage = typeImage
        self.postUrl = imageURL
        let heightHelper = CHMTextHeightHelper()
        if let _ = imageURL {
            heightHelper.textWidth = widthWithImage
        } else {
            heightHelper.textWidth = widthWithoutImage
        }
        var height = heightHelper.heightOfText(activityText.string)
        
        if height < 50 {
            height = 50
        }
        
        self.textHeight = height
    }
    
}
