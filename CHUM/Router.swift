//
//  Router.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

@objc enum PostCreationType:NSInteger {
    case Near, Place, PlaceDirectly
}

class Router: NSObject {

    func showCallControllerWithID(callerID:String, conversationID:String) {
        let storyboard = UIStoryboard(name: "Voximplant", bundle: nil)
        let callController =
            storyboard.instantiateViewControllerWithIdentifier(kCallControllerIdentifier) as! CallController
        callController.configure(withOpponetID: callerID, conversationID: conversationID)
        let visibleVC = visibleViewController()
        let navVc = CHMNavigationController(rootViewController: callController)
        if let vvc = visibleVC {
            vvc.presentViewController(navVc, animated: true, completion: nil)
        }
    }
    
    func showIncomingCall(callID:String, conversationID:String? = nil) {
        let storyboard = UIStoryboard(name: "Voximplant", bundle: nil)
        let callController =
            storyboard.instantiateViewControllerWithIdentifier(kCallControllerIdentifier) as! CallController
        callController.configure(withCallID: callID, conversationID: conversationID)
        let visibleVC = visibleViewController()
        let navVc = CHMNavigationController(rootViewController: callController)
        if let vvc = visibleVC {
            vvc.presentViewController(navVc, animated: true, completion: nil)
        }
    }
    
    func showMessanger(withConversationID conversationID:String) {
        let conversation = PAAConversation()
        conversation.conversationID = conversationID
        popToRootIfNeeded()
        showMessanger(withConversation:conversation)
    }
    
    
    func showMessanger(withPostID postID:String, commentID:String?) {
        let vc = PAAMessagerVC()
        vc.configureWithPostID(postID, commentID: commentID)
        pushVCWithoutTabbar(vc)
    }
    
    func showMessanger(withConversation conversation:PAAConversation) {
        let vc = PAAMessagerVC()
        vc.configureWithConverstion(conversation)
        pushVCWithoutTabbar(vc)
    }
    
    func showPost(withID postID:String) {
        let post = CHMPost()
        post.postID = postID
        popToRootIfNeeded()
        showPost(withPost:post)
    }
    
    func showPost(withPost post:CHMPost) {
        let vc = CHMPostDirectlyTVC()
        vc.configureWithPost(post)
        if let vvc = visibleViewController() {
            vvc.hidesBottomBarWhenPushed = true;
            vvc.navigationController?.pushViewController(vc, animated: true)
            vvc.hidesBottomBarWhenPushed = false
        }
    }
    
    func showOnboarding() {
        let vc = CHMOnboardingController()
        if let vvc = visibleViewController() {
            vvc.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: places
    
    func showPlaceFeed(withPlace place:CHMPlace) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(CHMPostsListControllerID) as! CHMPostsListController
        vc.place = place
        vc.feedType = .OnePlace
        if let nav = visibleViewController()?.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: creation
    
    func showCreationScreenForNearFeed() {
        showCreation(.Near, placeID: nil)
    }
    
    func showCreationScreenForPlaceFeed() {
        showCreation(.Place, placeID: nil)
    }
    
    func showCreationScreen(withPlaceID placeID:String) {
        showCreation(.PlaceDirectly, placeID: placeID)
    }
    
    func showCreation(type:PostCreationType, placeID:String?) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let creatioController = sb.instantiateViewControllerWithIdentifier(CHMPostCreationVCID) as! CHMPostCreationVC
        creatioController.configureWithCreationType(type.rawValue, placeID: placeID)
        presentVC(creatioController)
    }
    
    func showCreationInLocation(withPost post:CHMPost) {
        let vc = PostCreationInLocationVC()
        vc.configureWithPost(post)
        if let vvc = visibleViewController() {
            vvc.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showSecondCreationStage(withType type:PostCreationType, post:CHMPost) {
        switch type {
        case .Near:
            showCreationInLocation(withPost: post)
        default: break
        }
    }
    
    //MARK: activiy
    
    func showActivityController() {
        let vc = ActivityTableViewController()
        pushVC(vc)
    }
    
    func showActivity(withActivity activity:UserActivityProtocol) {
        if let act = activity as? WithPostProtocol {
            let post = act.post
            showPost(withID: post.postID)
        }
    }
    
    //MARK: support
    
    func presentVC(vc:UIViewController) {
        let nav = CHMNavigationController(rootViewController: vc)
        if let vvc = visibleViewController() {
            vvc.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    func pushVC(vc:UIViewController) {
        if let nav = visibleViewController()?.navigationController {
            nav.pushViewController(vc, animated: true)
        }
    }
    
    func pushVCWithoutTabbar(vc:UIViewController) {
        if let vvc = visibleViewController() {
            vvc.hidesBottomBarWhenPushed = true
            vvc.navigationController?.pushViewController(vc, animated: true)
            vvc.hidesBottomBarWhenPushed = false
        }
    }
    
    func popToRootIfNeeded () {
        let application = UIApplication.sharedApplication()
        if application.applicationState != .Active {
            if let vvc = visibleViewController() {
                vvc.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func visibleViewController()-> UIViewController? {
        return UIApplication.topViewController()
    }
}
