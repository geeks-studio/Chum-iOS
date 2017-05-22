//
//  CHMOnboardingController.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 13/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

//import UIKit
import EZSwipeController
import Crashlytics

class CHMOnboardingController: EZSwipeController {
    
    let firstController  = CHMScreenGenerator().firstScreen()
    let secondController = CHMScreenGenerator().secondScreen()
    let thirdController  = CHMScreenGenerator().thirdController()
    let geolocations     = CHMScreenGenerator().geolocationScreen()
    let notification     = CHMScreenGenerator().notificationControler()

    
    
    var viewControllers:[UIViewController] {
        let vcs = [firstController, secondController, thirdController, geolocations, notification]
        vcs.forEach({$0.buttonDelegate = self})
        return vcs
    }
    
    override func setupView() {
        datasource = self
        navigationBarShouldNotExist = true
//        navigationBarShouldBeOnBottom = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        self.setNeedsStatusBarAppearanceUpdate()
    
//        self.addButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func addButton() {
//        
//        let screenS = UIScreen.mainScreen().bounds.size
//        let r = CGRect(x:0 , y: screenS.height - btnHeight, width: screenS.width, height: btnHeight)
//        let v = UIView(frame:r)
//        
//        v.backgroundColor = UIColor.blackColor()
//        
//        
//        view.addSubview(v)
//        
//        view.bringSubviewToFront(v)
//        
//        let btn = UIButton(type: .Custom)
//        btn.setTitle("Пропустить", forState: .Normal)
//        v.addSubview(btn)
//        
//        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
//        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
//        btn.contentHorizontalAlignment = .Left
//        
//        
//        btn.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
//        btn.autoPinEdgeToSuperviewEdge(.Top)
//        btn.autoPinEdgeToSuperviewEdge(.Bottom)
//        btn.autoSetDimension(.Width, toSize: 100)
//        
//        btn.addTarget(self, action: "skip", forControlEvents: .TouchUpInside)
//        
//        
//        let rbtn = UIButton(type: .Custom)
//        let img = UIImage(named: "forwardArror")
//        //        rbtn.setTitle("Далее", forState: .Normal)
//        rbtn.setImage(img, forState: .Normal)
//        rbtn.contentHorizontalAlignment = .Right
//        
//        
//        v.addSubview(rbtn)
//        rbtn.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
//        rbtn.autoPinEdgeToSuperviewEdge(.Top)
//        rbtn.autoPinEdgeToSuperviewEdge(.Bottom)
//        rbtn.autoSetDimension(.Width, toSize: 30)
//        
//        rbtn.addTarget(self, action: "moveForvard", forControlEvents: .TouchUpInside)
//        
//        
//    }
    
    
    func moveForvard() {
        //        let currentPage = currentVCIndex
        if currentStackVC == stackPageVC.last {
            skip()
            return
        }
        
//        self.clickedRightButton()
    }
    
    func skip() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension CHMOnboardingController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
       return viewControllers
    }
}

extension CHMOnboardingController: CHMTwoButtonProtocol {
    func didPressLeftButton(button: UIButton!, owner: CHMTwoButtonsController!) {
        if owner.isEqual(firstController) {
            skip()
            Answers.logCustomEventWithName("onboarding canceled", customAttributes: nil)
        } else if owner.isEqual(geolocations) {
            clickedRightButton()
            Answers.logCustomEventWithName("geolocation canceled", customAttributes: nil)
        } else if owner == notification {
            skip()
            Answers.logCustomEventWithName("onboarding finished", customAttributes: nil)
            Answers.logCustomEventWithName("notification canceled", customAttributes: nil)
        }
    }
    
    func didPressRightButton(button: UIButton!, owner: CHMTwoButtonsController!) {
        if owner.isEqual(geolocations) {
            ICanHas.Location(closure: { (authorized, status) -> Void in
                print(status)
                self.clickedRightButton()
                if status == .AuthorizedWhenInUse {
                     NSNotificationCenter.defaultCenter().postNotificationName(CHMNeedUpdateLists, object: nil)
                }
            })
        } else if owner.isEqual(firstController) {
            clickedRightButton()
            Answers.logCustomEventWithName("onboarding started", customAttributes: nil)
        } else if owner == notification {
            ICanHas.Push(closure: {[weak self] (authorized) -> Void  in
                Answers.logCustomEventWithName("onboarding finished", customAttributes: nil)
                self?.skip()
            })
        }
    }
    
    func didPressCentralButton(button: UIButton!, owner: CHMTwoButtonsController!) {
        
        switch owner {
        case firstController:
            Answers.logCustomEventWithName("onboarding started", customAttributes: nil)
            fallthrough
        case firstController, secondController, thirdController:
            clickedRightButton()
        default:
            print("")
        }
        
//        if owner == secondController {
//            clickedRightButton()
//        } else if owner.isEqual(geoChooser) {
//            skip()
//            Answers.logCustomEventWithName("onboarding finished", customAttributes: nil)
//        } else if owner == firstController {
//            clickedRightButton()
//            Answers.logCustomEventWithName("onboarding started", customAttributes: nil)
//        }
    }
}