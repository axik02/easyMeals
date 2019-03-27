

import UIKit

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
//    func hour() -> Int
//    {
//        //Get Hour
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: self)
//
//        //Return Hour
//        return hour
//    }
//
//
//    func minute() -> Int
//    {
//        //Get Minute
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: self)
//
//        //Return Minute
//        return minute
//    }
    
    func currentTimeInDouble() -> Double {
        let stringTime = String(self.hour) + String(self.minute)
        let doubleTime = Double(stringTime)!
        return doubleTime
    }
  
}





