//
//  PlaceSelectCell.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 21/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import SDWebImage

class PlaceSelectCell: UICollectionViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeCity: UILabel!
    @IBOutlet weak var placeTags: UILabel!
    @IBOutlet weak var checkBox: UIView!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.whiteColor()
        
        checkBox.layer.cornerRadius = 18
        checkBox.layer.masksToBounds = true
        checkBox.layer.borderWidth = 0.7
        checkBox.layer.borderColor = UIColor.projectGray().CGColor
        
        placeImageView.layer.masksToBounds = true
    }
    
    override func drawRect(rect: CGRect) {
        placeImageView.layer.cornerRadius = placeImageView.bounds.size.height/2.0
        
    }
    
    func configure(withPlace place:CHMPlace) {
        
        placeName.text = place.placeName;
        placeCity.text = place.city
        placeImageView.backgroundColor = UIColor(forText:place.placeID) 
        if let placeURL = place.placeURL {
            placeImageView.sd_setImageWithURL(placeURL)
        } else {
            placeImageView.image = nil
        }
        if place.isChoosed {
            checkBox.backgroundColor = UIColor.checkboxColor()
        } else {
            checkBox.backgroundColor = UIColor.clearColor()
        }
        guard let tags = place.tags as? [String] else {
            return
        }
        
        configureTags(tags)
    }
    
    func configureTags(tags:[String]) {
        
        var resultText = ""
        for tag in tags {
            resultText += tag
            resultText += " "
        }
        self.placeTags.text = resultText
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
