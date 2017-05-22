//
//  ActivityServerExtension.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 16/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import AFNetworking
import LoremIpsum

extension CHMServerBase {
    func loadActivities(withCount count:Int, offset:Int, completion:([UserActivityProtocol]?, NSError?, Int) -> Void) {
//        let params = ["count":count, "offset":offset]
//        
//        manager.GET("activity/",
//                    parameters: params,
//                    progress: nil,
//                    success: { (dataTastk, responseObject) in
//            
//                        
//                    }) { (dataTask, error) in
//                        let r:NSHTTPURLResponse = dataTask?.response ?? 400
//                        completion(nil, error, r.statusCode)
//
//                
//                    }
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let fd = self.generateFakeActivitis(20)
            completion(fd, nil, 200)
        }
    }
    
    func getUnshowedActivitiesCount(completion:(Int)->Void)  {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            completion(0)
        }
    }
    
    func makeAllActivitiesViewedWithCompletion(completion:(NSError?,Int)->Void) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            completion(nil, 201)
        }
    }
    
    
    private func generateFakeActivitis(count:Int) -> [UserActivityProtocol] {
        var arr:[UserActivityProtocol] = []
        for _ in 0...count {
            let fd = fakeData()
            if let fd = fd {
                arr.append(fd)
            }
        }
        
        return arr
    }
    
    
    private func fakeData() -> UserActivityProtocol? {
        let typeNum:NSInteger = Int(arc4random() % 5)
        let type = ActivityType(rawValue: typeNum)!
        let fakeAct = self.fakeActivity(type)
        var actP:UserActivityProtocol? = nil
        
        let c = CHMComment()
        c.commentText = LoremIpsum.wordsWithNumber(10)
        c.commentID = LoremIpsum.word()
        
        let p = CHMPost()
        p.text = LoremIpsum.wordsWithNumber(10)
        p.postID = LoremIpsum.word()
        
        let likeCount:NSInteger = NSInteger(1 + arc4random()%100)
        
        switch type {
        case .Comments:
            actP = UserActivityWithPostAndComment(userActivity: fakeAct, post: p, comment: c)
        case .Level:
            actP = UserActivityNewLevel(userActivity: fakeAct, level: likeCount)
        case .LikeComment:
            actP = UserActivityNewLikeInComment(userActivity: fakeAct, post: p, comment: c, likes: likeCount)
        case .LikePost:
            actP = UserActivityNewLikesInPost(userActivity: fakeAct, post: p, likes: likeCount)
        case .Replay:
            actP = UserActivityWithPostAndComment(userActivity: fakeAct, post: p, comment: c)
        default:
            actP = nil
        }
        
        if let ap = actP {
            return ap
        } else {
            return nil
        }
    }
    
    private func fakeActivity(type:ActivityType) -> UserActivity {
        let date = LoremIpsum.date()
        return UserActivity(type: type, creationDate: date)
    }
    
}
