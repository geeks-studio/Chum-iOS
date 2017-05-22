//
//  PostUploader.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 19/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostUploader: NSObject {
    
    let viewController:UIViewController
    let post:CHMPost
    
    
    init(viewController:UIViewController, post:CHMPost) {
        self.viewController = viewController
        self.post = post
    }
    
    func startUploading() {
        if let v = viewController.navigationController?.view {
            MBProgressHUD.showHUDAddedTo(v, animated: true)
        }
    }
    
    func finishUploading() {
        if let v = viewController.navigationController?.view {
            MBProgressHUD.hideAllHUDsForView(v, animated: true)
        }
    }
    
    func updatePostLocation(location:CLLocation) {
        let c = location.coordinate;
        post.location.lat = NSNumber(double:c.latitude);
        post.location.lon = NSNumber(double:c.longitude);
    }
    
    func uploadPost() {
        CHMServerBase.shared().uploadPost(post) { (backPost, err, status) in
            MBProgressHUD.hideAllHUDsForView(self.viewController.navigationController?.view, animated: true)
            if let _ = backPost {
                self.showSucces(withText: "Пост успешно отправлен!")
                NSNotificationCenter.defaultCenter().postNotificationName(CHMNeedUpdateLists, object: nil)
            } else {
                self.viewController.showWarningWithText("Что-то пошло не так")
            }
        }
    }
    
    func showSucces(withText text:String) {
        let av = AlertWorker(withType: .Done)
        av.showSuccesAlert(withText: text, duration: 2) { 
            self.viewController.dismisVC()
        }
    }
}
