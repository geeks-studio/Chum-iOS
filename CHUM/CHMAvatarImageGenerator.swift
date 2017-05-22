//
//  CHMAvatarImageGenerator.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 31/03/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import Colours

class CHMAvatarImageGenerator: NSObject {
    var avatarPrivider:CHMAvatarProvider
    
    required init (withAvatarProvider avatarPrivider:CHMAvatarProvider) {
        
        self.avatarPrivider = avatarPrivider
    }
    
    func imageWithHeight(height:CGFloat) -> UIImage {
        let size = CGSize(width: height, height: height)
        let imgView = generteAvatar(height)
        UIGraphicsBeginImageContextWithOptions(size,false, 2.0)
        imgView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return viewImage
    }
    
    private func generteAvatar(height:CGFloat) -> UIImageView {
        let frame = CGRect(x: 0,y: 0, width: height, height: height)
        let name = avatarPrivider.imageID.stringValue
        let img = UIImage(named:name)
        let imgView = UIImageView(frame: frame)
        imgView.image = img
        imgView.layer.cornerRadius = height/2.0
        imgView.opaque = false
        imgView.backgroundColor = avatarPrivider.backColor
        
        if avatarPrivider.hasCrown {
            let crownImg = UIImage(named: "crown")
            let crownHeight = height * 0.4
            let offset = height - crownHeight
            let crownFrame = CGRect(x: offset, y: offset, width: crownHeight, height: crownHeight)
            let crownImageView = UIImageView(frame: crownFrame)
            crownImageView.image =  crownImg
            imgView.addSubview(crownImageView)
        }
        
        return imgView
    }
    
    func attrString(withImage image:UIImage) -> NSAttributedString {
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let attrStringWithImage = NSAttributedString(attachment:textAttachment)
        
        return attrStringWithImage
    }
    
    func appendComma(toString attributedString:NSMutableAttributedString) -> NSMutableAttributedString {
        let comaString = ", "
        
        let appendString = NSAttributedString(string: comaString)
        
        attributedString.appendAttributedString(appendString)
        return attributedString
    }
    
    
    func textWithCommaAndImage(height:CGFloat) -> NSMutableAttributedString {

        let img = imageWithHeight(height)
        let attrStrimgWithImage = attrString(withImage: img).mutableCopy() as! NSMutableAttributedString
        let stringWithComa = appendComma(toString: attrStrimgWithImage)
        
        return stringWithComa
    }
    
}
