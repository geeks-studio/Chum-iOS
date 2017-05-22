//
//  UserActivityCell.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SDWebImage

class UserActivityCell: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityLabel: TTTAttributedLabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        if let backImageView = activityImage.superview {
            backImageView.backgroundColor = UIColor.lightBackgroundColor()
            backImageView.layer.cornerRadius = 20
            backImageView.layer.masksToBounds = true
        }
    }
    
    func configure(withActivityPresenter activityPresenter:UserActivityPresenterProtocol) {
        activityImage.image = activityPresenter.typeImage
        timeAgoLabel.text = activityPresenter.timeAgoText
        activityLabel.attributedText = activityPresenter.activityText
        
        if let imgURL = activityPresenter.postUrl {
            imageWidthConstraint.constant = 40
            postImage.sd_setImageWithURL(imgURL)
        } else {
            imageWidthConstraint.constant = 15
            postImage.image = nil
        }
    }
}
