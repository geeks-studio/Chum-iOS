//
//  UserActivityPresenterProtocol.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import Foundation
import TTTAttributedLabel

protocol UserActivityPresenterProtocol {
    var typeImage:UIImage? {get}
    var timeAgoText:String? {get}
    var activityText:NSAttributedString? {get}
    var postUrl:NSURL? {get}
    var textHeight:CGFloat {get}
}
