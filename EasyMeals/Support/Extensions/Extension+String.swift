//
//  Extension+String.swift
//  EasyMeals
//
//  Created by Максим on 2/21/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    //"👌🏿".isSingleEmoji // true
    //"🙎🏼‍♂️".isSingleEmoji // true
    //"👨‍👩‍👧‍👧".isSingleEmoji // true
    //"👨‍👩‍👧‍👧".containsOnlyEmoji // true
    //"Hello 👨‍👩‍👧‍👧".containsOnlyEmoji // false
    //"Hello 👨‍👩‍👧‍👧".containsEmoji // true
    //"👫 Héllo 👨‍👩‍👧‍👧".emojiString // "👫👨‍👩‍👧‍👧"
    //"👨‍👩‍👧‍👧".glyphCount // 1
    //"👨‍👩‍👧‍👧".characters.count // 4, Will return '1' in Swift 4.2 so previous method not needed anymore
    //
    //"👫 Héllœ 👨‍👩‍👧‍👧".emojiScalars // [128107, 128104, 8205, 128105, 8205, 128103, 8205, 128103]
    //"👫 Héllœ 👨‍👩‍👧‍👧".emojis // ["👫", "👨‍👩‍👧‍👧"]
    //
    //"👫👨‍👩‍👧‍👧👨‍👨‍👦".isSingleEmoji // false
    //"👫👨‍👩‍👧‍👧👨‍👨‍👦".containsOnlyEmoji // true
    //"👫👨‍👩‍👧‍👧👨‍👨‍👦".glyphCount // 3
    //"👫👨‍👩‍👧‍👧👨‍👨‍👦".characters.count // 8, Will return '3' in Swift 4.2 so previous method not
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func getDeviceToken() -> String {
        
        if let token = UserDefaults.standard.object(forKey: Constants.userDefaultsKeys.keyForDeviceToken) as? String {
            return token
        } else {
            UserDefaults.standard.setValue(self.randomString(length: 32), forKey: Constants.userDefaultsKeys.keyForDeviceToken)
            return UserDefaults.standard.object(forKey: Constants.userDefaultsKeys.keyForDeviceToken) as! String
        }
        
    }
    
}
