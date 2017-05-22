//
//  StringExtension.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 16/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import Foundation

extension String {
    func firstWordsWithDots(wordsCount wordsCount:Int) -> String {
        if self.characters.count == 0 {
            return ""
        }
        
//        let string = self
        let pureString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let absolutePureString = pureString.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        let words = absolutePureString.characters.split(" ").map(String.init)
        var trueWords = words.prefix(wordsCount)
        if words.count > wordsCount {
            let lastElement = trueWords.last
            if let l = lastElement {
                let nLast = l + "..."
                trueWords.removeLast()
                trueWords.append(nLast)
            }
        }
        
        return trueWords.joinWithSeparator(" ")
    }
    
    
    
}
