//
//  TutorialView.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 12/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import PureLayout

class TutorialView: UIView {
    
    private static let cornerRadius:CGFloat = 5
    
    let acceptButton:UIButton = {
        let button = UIButton(type: .Custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ПОНЯТНО!", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = .mainColor()
        button.layer.cornerRadius = TutorialView.cornerRadius
        button.layer.masksToBounds = true
        return button
    }()
    
    private let bottomView:UIView = {
        let v = UIView(forAutoLayout: ())
        v.backgroundColor = .whiteColor()
        v.layer.cornerRadius = TutorialView.cornerRadius
        v.alpha = 0
        return v
    }()
    
    
    private let titleLabel:UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.textColor = .mainColor()
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = .Center
        label
        
        return label
    }()
    
    private let descrLabel:UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Center
        label.textColor = .blackColor()
        
        return label
    }()
    
    
    private let triangleView:UIView = {
        let v = TriangeView(forAutoLayout: ())
        v.backgroundColor = .clearColor()
        v.alpha = 0
        return v
    }()
    
    private var offsetConstraint:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clearColor()
        
//        acceptButton.addTarget(self, action: #selector(TutorialView.removeViewAction(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(triangleView)
        addSubview(bottomView)
        bottomView.addSubview(acceptButton)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(descrLabel)
        
        let topOffset:CGFloat = 25
        let widthMultiplier:CGFloat = 1.4
        
        let insets = UIEdgeInsets(top: topOffset, left: 10, bottom: 10, right: 10)
        
        bottomView.autoPinEdgesToSuperviewEdgesWithInsets(insets)
        
        triangleView.autoPinEdgeToSuperviewEdge(.Top)
        triangleView.autoPinEdge(.Bottom, toEdge: .Top, ofView: bottomView, withOffset: 0)
        triangleView.autoMatchDimension(.Width, toDimension: .Height, ofView: triangleView, withMultiplier: widthMultiplier)
        let offset = (bounds.size.width - topOffset * widthMultiplier)/2.0
        offsetConstraint = triangleView.autoPinEdgeToSuperviewEdge(.Left, withInset: offset)
        
        acceptButton.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
        acceptButton.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        acceptButton.autoPinEdgeToSuperviewEdge(.Right, withInset: 30)
        acceptButton.autoSetDimension(.Height, toSize: 40)
        
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 8)
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 16)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 8)
        titleLabel.autoSetDimension(.Height, toSize: 20)
        
        descrLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        descrLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        descrLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 0)
        descrLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: acceptButton, withOffset: -8)
    }
    
    convenience init (frame: CGRect, title:String, text:String) {
        self.init(frame:frame)
        titleLabel.text = title
        descrLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeViewAction(sender:UIButton) {
        removeView(animated: true)
    }
    
    func removeView(animated animated:Bool) {
        if animated {
            UIView.animateWithDuration(0.5, animations: { 
                    self.alpha = 0
                }, completion: { (finished) in
                    self.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }
    
    func configureOffset(offset:CGFloat) {
        offsetConstraint.constant = offset
    }
    
    func showView(animated animated:Bool)  {
        func makeVisible() {
            self.bottomView.alpha = 1.0
            self.triangleView.alpha = 1.0
        }
        if animated {
            UIView.animateWithDuration(0.5, animations: { 
                makeVisible()
            })
        } else {
            makeVisible()
        }

    }
}
