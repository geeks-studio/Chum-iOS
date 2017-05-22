//
//  CHMScreenGenerator.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 14/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class CHMScreenGenerator: NSObject {
    
    lazy var sb:UIStoryboard = {
        let sb = UIStoryboard(name: "Onboarding", bundle: nil)
        
        return sb
    }()
    
    func geolocationScreen()-> CHMTwoButtonsController {
        let geolocations = sb.instantiateViewControllerWithIdentifier(CHMTwoButtonsControllerID) as! CHMTwoButtonsController
        
        let centralImage = UIImage(named: "centralGeo")
        let backGeo = UIImage(named: "pushBack")
        
        geolocations.configureWithCentralImage(
            centralImage,
            backImage: backGeo,
            title: "ГЕОЛОКАЦИЯ",
            subtitle: "Хочешь, чтобы окружающие видели твои посты, а ты их?",
            buttonsVisible: true,
            leftButtonTitle: "Нет, спасибо",
            rightButtonTitle: "Да, конечно!"
        )
        
        return geolocations
    }
    
    func firstScreen()-> CHMTwoButtonsController {
        let firstController = sb.instantiateViewControllerWithIdentifier(CHMTwoButtonsControllerID) as! CHMTwoButtonsController
        
        let firstCentralImage = UIImage()
        let firstBackImg = UIImage(named: "back1")
        
        firstController.configureWithCentralImage(
            firstCentralImage,
            backImage: firstBackImg,
            title: "",
            subtitle: "",
            buttonsVisible: false,
            leftButtonTitle: "",
            rightButtonTitle: "",
            centralButtonText: "Понятно"
        )
        
        return firstController
    }
    
    func secondScreen() -> CHMTwoButtonsController {
        let secondController = sb.instantiateViewControllerWithIdentifier(CHMTwoButtonsControllerID) as! CHMTwoButtonsController
        
        let secondCentralImage = UIImage()
        let secondBack = UIImage(named: "back2")
        
        secondController.configureWithCentralImage(
            secondCentralImage,
            backImage: secondBack,
            title: "",
            subtitle: "",
            buttonsVisible: false,
            leftButtonTitle: "",
            rightButtonTitle: "",
            centralButtonText: "Понятно"
        )
        
        return secondController
    }
    
    func thirdController() -> CHMTwoButtonsController {
        let thirdController = sb.instantiateViewControllerWithIdentifier(CHMTwoButtonsControllerID) as! CHMTwoButtonsController
        
        let centralImage = UIImage()
        let back = UIImage(named: "back3")
        
        thirdController.configureWithCentralImage(
            centralImage,
            backImage: back,
            title: "",
            subtitle: "",
            buttonsVisible: false,
            leftButtonTitle: "",
            rightButtonTitle: "",
            centralButtonText: "Понятно"
        )
        
        return thirdController
    }
    
    
    func notificationControler() -> CHMTwoButtonsController {
        
        let notification = sb.instantiateViewControllerWithIdentifier(CHMTwoButtonsControllerID) as! CHMTwoButtonsController
        
        let centralImage = UIImage(named: "centralPush")
        let backGeo = UIImage(named: "pushBack")
        
        notification.configureWithCentralImage(
            centralImage,
            backImage: backGeo,
            title: "УВЕДОМЛЕНИЯ",
            subtitle: "Хочешь получать уведомления о новых сообщениях и комментариях?",
            buttonsVisible: true,
            leftButtonTitle: "Нет, спасибо",
            rightButtonTitle: "Да, конечно!"
        )
        
        return notification
        
    }
}
