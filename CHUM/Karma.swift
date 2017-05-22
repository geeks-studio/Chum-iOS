//
//  Karma.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 30/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit

class Karma: NSObject {
//    @property (strong, nonatomic) NSNumber *likeCount;
//    @property (strong, nonatomic, nullable) NSNumber *maxMeterCount;
//    @property (strong, nonatomic) NSNumber *level;
//    @property (strong, nonatomic) NSNumber *progress;
//    @property (strong, nonatomic) NSNumber *likeToNextLevel;
    
    let likeToNextLevel:Int
    let progress:Int
    let level:Int
    let likeCount:Int
    
    init(level:Int, likeCount:Int, progress:Int, likeToNextLevel:Int) {
        self.level = level
        self.likeCount = likeCount
        self.progress = progress;
        self.likeToNextLevel = likeToNextLevel
    }

}
