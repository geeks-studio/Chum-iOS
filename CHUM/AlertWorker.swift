//
//  AlertWorker.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 02/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
//import SCLAlertView

@objc enum AlertType:Int {
    case Done, Level, IncomingCall
}

class AlertWorker: NSObject {
    
    var alert:SCLAlertView
    
    convenience init (withType type:AlertType) {
        
        switch type {
        case .Done:
            let circleHeight = UIScreen.mainScreen().bounds.size.width/3.5
            let circleOffsetProportion:CGFloat = 0.85
            self.init(circleHeight: circleHeight, circleOffsetProportion: circleOffsetProportion)
        case .Level:
            let width = UIScreen.mainScreen().bounds.width * 0.7
            self.init(circleHeight: width,
                      circleOffsetProportion: 0.95,
                      heightOffset: 100,
                      imageProportion: 1.1,
                      windowWidth: width * 1.1)
        case .IncomingCall:
            let circleHeight = UIScreen.mainScreen().bounds.size.width/4
            let circleOffsetProportion:CGFloat = 0.85
            self.init(circleHeight: circleHeight, circleOffsetProportion: circleOffsetProportion)
        }
    }
    
    required init(circleHeight:CGFloat,
                  circleOffsetProportion:CGFloat,
                  heightOffset: CGFloat = 15,
                  imageProportion:CGFloat = 0.6, windowWidth:CGFloat = 240) {
        alert = SCLAlertView(circleHeight: circleHeight,
                             circleOffsetProportion: circleOffsetProportion,
                             fontSize: 15,
                             heightOffset: heightOffset,
                             imageProportion: imageProportion,
                             windowWidth: windowWidth)
    }
    
    
    func showSuccesAlert (withText text:String, duration:NSTimeInterval, completionHandler: () -> Void) {
        alert.showCloseButton = false
        let img = UIImage(named: "okIconBig")
        let responder = alert.showTitle(text, subTitle: "", duration: duration, completeText: nil, style: .Success, colorStyle: 0x54C5D5,circleIconImage:img)
        responder.setDismissBlock {
            completionHandler()
        }
    }
    
    
    func showAlertAboutNewLevel(level:Int, text:String = "", completionHandler: () -> Void) {
        let r = CGRect(x: 0, y: 0, width: 200, height: 200)
        let karmaView = KarmaView(frame: r)
        karmaView.configure(withLevel: level, progress: 0.75)
        let karmaImage = karmaView.imageWithView()
        alert.showCloseButton = false
        
        let levelString = "\(level) уровня"
        let message = "Твоя карма достигла \(levelString)!\n "
        let str = NSString(string: message)
        let range = str.rangeOfString(levelString)
        
        let attrString = NSMutableAttributedString(string: message)
        let attrs = [NSForegroundColorAttributeName:UIColor.projectPinkColor()];
        attrString.addAttributes(attrs, range: range)
        
        let responder = alert.showTitle(message,
                                        subTitle: "",
                                        duration: 4,
                                        completeText: "",
                                        style: .Success,
                                        colorStyle: 0xFFFFFF,
                                        circleIconImage: karmaImage,
                                        attributedTitle: attrString)
        responder.setDismissBlock {
            completionHandler()
        }
    }
    
    func showAlertAboutIncomingCall(completionHandler:(Bool)->Void) {
        alert.showCloseButton = false
        alert.addButton("Принять") { 
            completionHandler(true)
        }
        
        alert.addButton("Отклонить") {
            completionHandler(false)
        }
        
        let image = UIImage(named: "phone")
        
       alert.showTitle("Входящий вызов",
                                        subTitle: "",
                                        duration: 0,
                                        completeText: "",
                                        style: .Success,
                                        colorStyle: 0x4CC5D5,
                                        circleIconImage: image
                                        )
    }

}
