//
//  ThemeCell.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import SDWebImage

class ThemeCell: UITableViewCell {
    
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var coverColorView: UIView!
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var isFavoriteImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userCountLabel: UILabel!
    
    func configure(themePresenter:ThemePresenterProtocol) {
        themeNameLabel.text = themePresenter.themeName
        if let userCount = themePresenter.userCount {
            userCountLabel.text = userCount
            userImageView.hidden = false
        } else {
            userCountLabel.text = ""
            userImageView.hidden = true
        }
        
        if themePresenter.isFavorite {
            isFavoriteImageView.hidden = false
        } else {
            isFavoriteImageView.hidden = true
        }
        
        themeImageView.backgroundColor = UIColor(forText: themePresenter.themeName)
        if let imageURL = themePresenter.imageURL {
            themeImageView .sd_setImageWithURL(imageURL)
        } else {
            themeImageView.image = nil
        }
        
        if let coverColor = themePresenter.coverColor {
            coverColorView.backgroundColor = coverColor
        } else {
            coverColorView.backgroundColor = .clearColor()
        }
    }

}
