//
//  UIApplicationExtension.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 18/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import Foundation
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
