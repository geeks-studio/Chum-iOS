//
//  KarmaView.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 22/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import CircleProgressBar
import PureLayout

class KarmaView: UIView {
    
    let insideOffset:CGFloat = 32
    
    var view: UIView!
    @IBOutlet weak var circleProgress: CircleProgressBar!
    @IBOutlet weak var levelImageView: UIImageView!
    
    var levelView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
    var levelLabel:UILabel = UILabel(forAutoLayout: ())
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        view.clipsToBounds = false
        self.clipsToBounds = false
        configureUI()
    }
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "KarmaView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func drawRect(rect: CGRect) {
        updateLabelPosition()
    }
    
    func configure(withLevel level:Int, progress:Float) {
        let imgName = "l\(level)"
        levelImageView.image = UIImage(named: imgName)
        circleProgress.setProgress(CGFloat(progress), animated: false)
        levelLabel.text = "\(level)"
        self.updateLabelPosition()
    }
    
    func configureUI () {
        configureView()
        configureSlider()
        configureLevelLabelView()
        configureLabel()
    }
    
    func configureView () {
        backgroundColor                = .clearColor()
        view.backgroundColor           = .clearColor()
        levelImageView.backgroundColor = .clearColor()
        view.opaque = false
        self.opaque = false
    }
    
    func configureSlider () {
        circleProgress.progressBarWidth         = 10.0
        circleProgress.progressBarProgressColor = UIColor(236, g: 102, b: 140)
        circleProgress.progressBarTrackColor    = UIColor(182, g: 74, b: 105)
        circleProgress.startAngle               = -90
        circleProgress.hintHidden               = true
        circleProgress.backgroundColor          = .clearColor()
        circleProgress.setProgress(0.75, animated: false)
    }
    
    func configureLevelLabelView () {
        levelView.backgroundColor       = UIColor.projectPinkColor()
        levelView.layer.cornerRadius    = levelView.frame.size.height/2.0
        levelView.layer.masksToBounds   = true
        levelView.layer.shadowColor     = UIColor.blackColor().CGColor
        levelView.layer.shadowOpacity   = 0.4
        levelView.layer.shadowRadius    = 1.0
        view.addSubview(levelView)
    }
    
    func configureLabel() {
        levelLabel.textColor     = UIColor.whiteColor()
        levelLabel.textAlignment = .Center
        levelView.addSubview(levelLabel)
        levelLabel.autoPinEdgesToSuperviewEdges()
    }
    
    func updateLabelPosition () {
        let r = self.bounds;
        let radius = Double((r.size.height - self.circleProgress.progressBarWidth - insideOffset) / 2.0)
        let progress = Double(circleProgress.progress)
        let angle = progress * M_PI * 2.0
        let sinus = sin(angle) * radius
        let cosinus = cos(angle) * radius
        let x = self.center.x + CGFloat(sinus)
        let y = self.center.y - CGFloat(cosinus)
        levelView.center = CGPoint(x:x, y:y);
    }
}
