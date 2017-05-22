//
//  CHMTabBar.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 11/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class CHMTabBar: UITabBarController {
    
    var addPostButton = CHMAddPostButton(frame: CGRectMake(0, 0, 60, 60))
    
    lazy var launchView:CHMStartingView = {
        let r = UIScreen.mainScreen().bounds;
        let lv = CHMStartingView(frame: r)
        lv.setLoading(true)
        lv.reloadButton?.addTarget(self, action: #selector(registrateUser), forControlEvents: .TouchUpInside)
        return lv;
    }()
    
    let vcs:[UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyboard.instantiateViewControllerWithIdentifier(CHMUserProfileControllerID)
        let messangerVC = storyboard.instantiateViewControllerWithIdentifier(PAAConversationsTVCID)
        let aroundVC = storyboard.instantiateViewControllerWithIdentifier(CHMPostsListControllerID)
        let placeVC = storyboard.instantiateViewControllerWithIdentifier(CHMPostsListControllerID)
        let themeChooser = ThemeChooserController()
        
        if  let feed1 = aroundVC as? CHMPostsListController,
            let feed2 = placeVC as? CHMPostsListController {
            feed1.feedType = CHMFeedType.Near
            feed2.feedType = CHMFeedType.Places
        }
        let vcs = [themeChooser, aroundVC, messangerVC, userVC]
        return vcs
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setViewControllers(controllers(), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers(controllers(), animated: false)
        configureView()
        configureImages()
        self.setNeedsStatusBarAppearanceUpdate()
        view.addSubview(launchView)
        registrateUser()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(CHMTabBar.updateUnreadCount(_:)),
                                                         name: CHMShoulUpdateUnreadCount,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(CHMTabBar.updateUnwathedActivitiesCount(_:)),
                                                         name: UserActivityNotifier.CHMUnshowedActivityCountNotification,
                                                         object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
        showtutorialView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK - ui
    
    func configureView() {
        view.backgroundColor = UIColor.mainColor()
        tabBar.backgroundColor = UIColor.mainColor()
        tabBar.barTintColor = UIColor.mainColor()
        tabBar.translucent = false
        tabBar.tintColor = UIColor.wheatColor()
        let unselectedColor = UIColor(colorLiteralRed: 75/255.0, green: 139/255.0, blue: 149/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
    }
    
    func configureImages() {
        let nearFeedIcon = UIImage(named: "nearFeed")
        let placesFeedIcon = UIImage(named: "placeFeed")
        let conversationIcon = UIImage(named: "conversation")
        let profileIcon = UIImage(named: "profile")
        
        let nearFeedBlue = UIImage(named: "nearFeedBlue")
        let placeFeedBlue = UIImage(named: "placeFeedBlue")
        let conversationBlue = UIImage(named: "conversationBlue")
        let profileBlue = UIImage(named: "profileBlue")
        
        let icons = [placesFeedIcon, nearFeedIcon, conversationIcon, profileIcon]
        let selectedIcons = [placeFeedBlue, nearFeedBlue, conversationBlue, profileBlue]
        let names = [ "Темы", "Вокруг", "Диалоги", "Профиль"];
        
        for (index, item) in (tabBar.items?.enumerate())! {
            let selectedIcon = icons[index]!.imageWithRenderingMode(.AlwaysOriginal)
            let icon = selectedIcons[index]!.imageWithRenderingMode(.AlwaysOriginal)
            let text = names[index]
            item.title = text
            item.image = icon
            item.selectedImage = selectedIcon
        }
    }
    
    //MARK: actions
    
    
    func registrateUser() {
        launchView.setLoading(true)
        CHMCurrentUserManager.shared().cloudIDAsync { (icloudToken, er ) -> Void in
            guard let identifier = icloudToken else {
                return;
            }
            CHMServerBase.shared().registrateWithID(identifier) { (token , err, status_code) -> Void in
                self.launchView.setLoading(false);
                guard let tkn = token else {
                    return
                }
                self.launchView.removeFromSuperview()
                PAAMessageManager.sharedInstance().setIdentifier(identifier)
                CHMCurrentUserManager.shared().setToken(tkn)
                CallWorker.sharedInstance.start()
                self.updateVCS()
                CHMNotificationCenter.shared().performStoredAction()
                PAAMessageManager.sharedInstance().updateUnreadCountEverywhere()
                UserActivityNotifier.updateUnwatherCountEverythere()
            }
        }
    }
    
    func updateVCS() {
        for (_, element) in vcs.enumerate() {
            if element.respondsToSelector(#selector(CHMCanBeReloaded.reloadDataSender(_:))) {
                let canBeReloaded = element as? CHMCanBeReloaded
                canBeReloaded?.reloadDataSender(self)
            }
        }
    }
    
    func showOnboarding() {
        let key = "CHMIsOnbordingShowed"
        let isShowed = NSUserDefaults.standardUserDefaults().boolForKey(key)
        if !isShowed {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)
            Router().showOnboarding()
        }
    }

    func controllers() -> [UIViewController] {
        var withNavs:[UIViewController] = []
        for (_, element) in vcs.enumerate() {
            let nav = CHMNavigationController(rootViewController: element)
            withNavs.append(nav)
        }
        return withNavs
    }
    
    //MARK: badge 
    
    func updateUnreadCount(note:NSNotification) {
        guard let count = note.object as? NSNumber else {
            return
        }
        setBadgeCount(count, badgeNumber: 2)
    }
    
    func updateUnwathedActivitiesCount(note:NSNotification) {
        guard let count = note.object as? NSNumber else {
            return
        }
        setBadgeCount(count, badgeNumber: 3)
    }
    
    func setBadgeCount(count:NSNumber, badgeNumber:Int) {
        guard let items = self.tabBar.items else {
            return
        }
        let item = items[badgeNumber]
        if count.integerValue > 0 {
            item.badgeValue = "\(count)"
        } else {
            item.badgeValue = nil
        }
    }
    
    //MARK: test
    
    func showtutorialView() {

    }
}



