//
//  UserActivityConverter.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import DateTools
import LoremIpsum

class UserActivityConverter: NSObject {
    class func convert(userActivity:UserActivityProtocol) -> UserActivityPresenterProtocol {
//        var typeImage:UIImage? = self.imageForType(userActivity.userActivity.type)
        var activityPresenter:UserActivityPresenterProtocol? = nil
        switch userActivity.userActivity.type {
        case .Comments:
            activityPresenter = self.configureForComment(userActivity)
        case .Level:
            activityPresenter = self.configureForLevel(userActivity)
        case .LikeComment:
            activityPresenter = self.configureForLikeComment(userActivity)
        case .LikePost:
            activityPresenter = self.configureForLikePost(userActivity)
        case .Replay:
            activityPresenter = self.configureForReply(userActivity)
        default:
            activityPresenter = nil
        }
        
        if let ap = activityPresenter {
            return ap
        } else {
            let attrString = NSAttributedString(string: "")
            return UserActivityPresenter(activityText: attrString, typeImage: UIImage(), timeAgoText: "")
        }
    }
    
    class func configureForComment(userActivity:UserActivityProtocol ) -> UserActivityPresenterProtocol? {
        if let userActivityComment = userActivity as? UserActivityWithPostAndComment {
            let postText = "\"\(userActivityComment.post.text.firstWordsWithDots(wordsCount: 3))\""
            let commentText = userActivityComment.comment.commentText.firstWordsWithDots(wordsCount: 3)
            
            let text = "Ваш пост \(postText) прокомментировали: \"\(commentText)\""
            
            let attrString = underlinedString(text, term: postText)
            
            return self.configureWith(userActivity: userActivity, text: attrString, imageURL: userActivityComment.post.imgUrl)
        }
        
        return nil
    }
    
    class func configureForLevel(userActivity:UserActivityProtocol ) -> UserActivityPresenterProtocol? {
        if let levelActivity = userActivity as? UserActivityNewLevel {
            let level = levelActivity.level
            let text = "Ваш Чам достиг \(level)-го уровня. Радиус постов увеличен!"
            let attrstring = NSAttributedString(string: text, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)])
            return self.configureWith(userActivity: userActivity, text: attrstring)
        }
        
        return nil
    }
    
    class func configureForLikeComment(userActivity:UserActivityProtocol ) -> UserActivityPresenterProtocol? {
        
        if let likeCommentActivity = userActivity as? UserActivityNewLikeInComment {
            let commentText = likeCommentActivity.comment.commentText.firstWordsWithDots(wordsCount: 3)
            let postText = "\"\(likeCommentActivity.post.text.firstWordsWithDots(wordsCount: 3))\""
            let postURL = likeCommentActivity.post.imgUrl
            let likeCount = likeCommentActivity.likeCount
            let likeWord = likeCount == 1 ? "лайк" : "лайков"
            
            let text = "Ваш комментарий \"\(commentText)\" в посте \(postText) набрал \(likeCount) \(likeWord)"
            
            let attrstring = underlinedString(text, term: postText)
            
            return configureWith(userActivity: userActivity, text: attrstring, imageURL: postURL)
        }
        return nil
    }
    
    class func configureForLikePost(userActivity:UserActivityProtocol ) -> UserActivityPresenterProtocol? {
        if let likePostActivity = userActivity as? UserActivityNewLikesInPost {
            let likeCount = likePostActivity.likeCount
            let likeWord = likeCount == 1 ? "лайк" : "лайков"
            let postText = "\"\(likePostActivity.post.text.firstWordsWithDots(wordsCount: 3))\""
            let postURL = likePostActivity.post.imgUrl
            
            let text = "Ваш пост \(postText) набрал \(likeCount) \(likeWord)"
            
            let attrString = underlinedString(text, term: postText)
            
            return configureWith(userActivity: userActivity, text: attrString, imageURL: postURL)
        }
        
        return nil
    }
    
    class func configureForReply(userActivity:UserActivityProtocol ) -> UserActivityPresenterProtocol? {
        if let replayActivity = userActivity as? UserActivityWithPostAndComment {
            let commentText = replayActivity.comment.commentText
            let postText = "\"\(replayActivity.post.text.firstWordsWithDots(wordsCount: 3))\""
            let postURL = replayActivity.post.imgUrl
            let text = "На ваш комментарий \"\(commentText.firstWordsWithDots(wordsCount: 3))\" в посте \(postText) ответили"
            
            let attrString = underlinedString(text, term: postText)
            
            return configureWith(userActivity: userActivity, text: attrString, imageURL: postURL)
        }
        
        return nil
    }
    
    class func configureWith(userActivity userActivity:UserActivityProtocol, text:NSAttributedString, imageURL:NSURL? = nil) -> UserActivityPresenterProtocol {
        let image = self.imageForType(userActivity.userActivity.type)
        let timeAgoText = userActivity.userActivity.creationDate.timeAgoSinceNow()
        let uap = UserActivityPresenter(activityText: text, typeImage: image, timeAgoText: timeAgoText, imageURL: imageURL)
        return uap
    }
    
    class func underlinedString(string: String, term: String) -> NSAttributedString {
        let str = NSString(string: string)
        let output = NSMutableAttributedString(string: string )
        let underlineRange = str.rangeOfString(term)
        
        output.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: NSMakeRange(0, str.length))
        output.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightLinkColor(), range: underlineRange)
        
        output.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(17)], range:  NSMakeRange(0, str.length))
        
        return output
    }
    
    class func imageForType(activityType:ActivityType) -> UIImage {
        let img:UIImage
        switch activityType {
        case .Comments:
            img = UIImage(named: "activityComment")!
        case .Level:
            img = UIImage(named: "activityLevel")!
        case .LikeComment, .LikePost:
            img = UIImage(named: "activityLike")!
        case .Replay:
            img = UIImage(named: "activityCommentReply")!
        default:
            img = UIImage()
        }
        return img
    }
}
