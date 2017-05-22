//
//  TutorialWorker.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 12/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class TutorialWorker: NSObject {
    
    var backView = UIView()
    var tutorialView:TutorialView?
    
    private lazy var removeTGR:UITapGestureRecognizer = {
        let tgr = UITapGestureRecognizer(target: self, action: #selector(TutorialWorker.removeBackView))
        return tgr
        
    }()
    
    private lazy var removeSGR:UISwipeGestureRecognizer = {
        let sgr = UISwipeGestureRecognizer(target: self, action:  #selector(TutorialWorker.removeBackView))
        sgr.direction = UISwipeGestureRecognizerDirection.Up 
        return sgr
    }()
    
    override init() {
        super.init()
        backView.addGestureRecognizer(removeTGR)
        backView.addGestureRecognizer(removeSGR)
        
    }
    
    func generateTutorialViewForNavBar(withTitle title:String, text:String, offset:CGFloat, backFrame:CGRect) -> UIView {
        backView.frame = backFrame
        backView.alpha = 0
        backView.backgroundColor = UIColor(white: 0.4, alpha: 0.6)
        let s = UIScreen.mainScreen().bounds.size
        let tutorialFrame = CGRect(x: 0, y: 0, width: s.width, height: 250)
        tutorialView = TutorialView(frame: tutorialFrame,
                                        title: title,
                                        text: text)
        tutorialView?.configureOffset(offset)
        backView.addSubview(tutorialView!)
        
        
        
        tutorialView!.acceptButton.addTarget(self, action: #selector(TutorialWorker.removeBackView), forControlEvents: .TouchUpInside)
        
        return backView
        
    }
    
    
    func generateTutorialViewForScreenCenter(withTitle title:String, text:String, verticalOffset:CGFloat, backFrame:CGRect) -> UIView {
        
        backView.frame = backFrame
        backView.alpha = 0
        backView.backgroundColor = UIColor.clearColor()
        let s = UIScreen.mainScreen().bounds.size
        let bottomViewHeight = s.height - verticalOffset
        let bottomFrame = CGRect(x: 0, y: verticalOffset, width: s.width, height: bottomViewHeight)
        let additionBottomView = UIView(frame: bottomFrame)
        additionBottomView.backgroundColor = UIColor(white: 0.4, alpha: 0.6)
        backView.addSubview(additionBottomView)
        
        var tutorialHeight:CGFloat = 250
        
        if bottomViewHeight - 16 < 250 {
            tutorialHeight = bottomViewHeight - 16
        }
        
        let tutorialFrame = CGRect(x: 0, y: 0, width: s.width, height: tutorialHeight)
        tutorialView = TutorialView(frame: tutorialFrame,
                                    title: title,
                                    text: text)
        additionBottomView.addSubview(tutorialView!)
        tutorialView!.acceptButton.addTarget(self, action: #selector(TutorialWorker.removeBackView), forControlEvents: .TouchUpInside)
        
        return backView
        
    }
    
    func canRemoveFromSuperView () -> Bool {
        if let _ = backView.superview {
            return true
        } else {
            return false
        }
    }
    
    func showView() {
        UIView.animateWithDuration(0.5) { 
            self.backView.alpha = 1
        }
        tutorialView?.showView(animated: true)
    }
    
    func removeBackView()  {
        UIView.animateWithDuration(0.5, animations: { 
            self.backView.alpha = 0
            }) { (finished) in
                self.backView.removeFromSuperview()
        }
    }

}
