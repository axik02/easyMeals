
//
//  File.swift
//  EasyMeals
//
//  Created by Максим on 2/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class UserViewModel {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    public var userNameText: String {
        return user.data?.userName ?? ""
    }
    
    public var userEmailText: String {
        return user.data?.email ?? ""
    }
    
    public var userCreatedTimeAgoText: String {
        if let createdAt = user.data?.createdAt {
            let doubleUnixTime = Double(createdAt)
            let date = Date(timeIntervalSince1970: doubleUnixTime)
            return Constants.timeAgoSince(date)
        } else {
            return "Can't determine created time"
        }
    }
    
    public var userID: Int {
        return user.data?.usersID ?? 0
    }
    
}
