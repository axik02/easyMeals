

import UIKit
import KeychainSwift

public struct Constants {
    
    static var currentUser:User? = nil
    static var keychainInstance = KeychainSwift()
    static var deviceToken = String().getDeviceToken()
    static var categoriesViewModel:CategoriesViewModel? = nil
    
    struct notificationKeys {
        static let keyForDistanceFilter = "keyForDistanceFilter"
    }

    struct userDefaultsKeys {
        static let keyForDeviceToken = "keyForDeviceToken"
    }
    
    struct keychainKeys {
        static let keyForLoginEmail = "keyForLoginEmail"
        static let keyForLoginPassword = "keyForLoginPassword"
        static let keyForJWTToken = "keyForJWTToken"
        static let keyForRefreshToken = "keyForRefreshToken"
    }
        
    static public func showAlert(_ title : String?, message : String?, buttonName : String = "OK")
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonName, style: .default) { action in
            // perhaps use action.title here
        })
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    static public func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        
        if let year = components.year, year >= 5 {
            return "\(year)" + " years ago"
        }
        
        if let year = components.year, year >= 2 {
            return "\(year)" + " years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)" + " months ago"
        }
        
        if let month = components.month, month >= 5 {
            return "\(month)" + " months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 5 {
            return "\(week)" + " weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)" + " weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)" + " days ago"
        }
        
        if let day = components.day, day >= 5 {
            return "\(day)" + " days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 5 {
            return "\(hour)" + " hours ago"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)" + " hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 5 {
            return "\(minute)" + " minutes ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)" + " minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 5 {
            return "\(second)" + " seconds ago"
        }
        
        return "Just now"
        
    }
    
    static func presentMainVCWith(currentVC: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavigationMainVC") as! UINavigationController
        currentVC.present(vc, animated: true, completion: nil)
    }

    
}
