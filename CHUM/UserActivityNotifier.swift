//
//  UserActivityNotifier.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 09/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

//static let CHMUnshowedActivityCountNotification:String = "CHMUnshowedActivityCountNotification"

class UserActivityNotifier: NSObject {
    static let CHMUnshowedActivityCountNotification:String = "CHMUnshowedActivityCountNotification"
    class func updateUnwatherCountEverythere () {
        CHMServerBase.shared().getUnshowedActivitiesCount {(count) in
           UserActivityNotifier.updateActivityBadge(withCount: count)
        }
    }
    
    class func updateActivityBadge(withCount count:NSNumber) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName(UserActivityNotifier.CHMUnshowedActivityCountNotification, object: count)
    }
}
