//
//  ActivityRouter.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 08/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class ActivityRouter: NSObject {
    
    func openScreen(withActivity activity:UserActivityProtocol) {
        
        switch activity.userActivity.type {
        case .Comments, .LikePost, .LikeComment, .Replay:
            let r = Router()
            r.showActivity(withActivity: activity)
        default: break
            
        }
    }

}
