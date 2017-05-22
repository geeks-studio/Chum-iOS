//
//  UserActivity.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

@objc enum ActivityType:NSInteger {
    case Comments
    case Replay
    case LikeComment
    case LikePost
    case Level
    case None
    
}

protocol UserActivityProtocol {
    var userActivity:UserActivity {get}
}

protocol UserActivityBaseProtocol {
    var type:ActivityType {get}
    var creationDate:NSDate {get}
}

protocol WithPostProtocol {
    var post:CHMPost {get}
}

protocol WithCommentProtocol {
    var comment:CHMComment {get}
}

protocol WithLikesProtocol {
    var likeCount:NSInteger {get}
}

struct UserActivity:UserActivityBaseProtocol {
    var type:ActivityType = .None
    var creationDate:NSDate
    
    init(type:ActivityType, creationDate:NSDate) {
        self.type = type
        self.creationDate = creationDate
        
    }
}

struct UserActivityNewLevel: UserActivityProtocol{
    var userActivity: UserActivity
    var level:NSInteger
    init(userActivity:UserActivity, level:NSInteger) {
        self.userActivity = userActivity
        self.level = level
    }
}

struct UserActivityWithPostAndComment:UserActivityProtocol, WithPostProtocol, WithCommentProtocol {
    var userActivity: UserActivity
    var post: CHMPost
    var comment: CHMComment
    
    init (userActivity:UserActivity, post:CHMPost, comment:CHMComment) {
        self.userActivity = userActivity
        self.post = post
        self.comment = comment
    }
}

struct UserActivityNewLikesInPost: UserActivityProtocol, WithPostProtocol, WithLikesProtocol  {
    var userActivity: UserActivity
    var post: CHMPost
    var likeCount:NSInteger
    
    init (userActivity:UserActivity, post:CHMPost, likes:NSInteger) {
        self.userActivity = userActivity
        self.post = post
        self.likeCount = likes
    }
}

struct UserActivityNewLikeInComment:UserActivityProtocol, WithPostProtocol, WithCommentProtocol,WithLikesProtocol {
    let userActivity: UserActivity
    let post: CHMPost
    let comment: CHMComment
    let likeCount:NSInteger
    
    init(userActivity:UserActivity, post:CHMPost, comment:CHMComment, likes:NSInteger) {
        self.userActivity = userActivity
        self.post = post
        self.comment = comment
        self.likeCount = likes
    }
}



