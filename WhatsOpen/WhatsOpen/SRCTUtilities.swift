//
//  SRCTUtilities.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 20/11/2016.
//  Copyright © 2016 Patrick Murray. All rights reserved.
//

import UIKit


class Utilities: NSObject {
    
    
    static func isOpen(facility: Facility) -> Bool {
        
        let currentDay = getDayOfWeek()
        let time = getCurrentTime()
        
        if(facility.mainSchedule.openTimes.isEmpty || facility.mainSchedule.openTimes.count < currentDay!){
            return false
        } else {
            if(time >= facility.mainSchedule.openTimes[currentDay!].startTime && time <= facility.mainSchedule.openTimes[currentDay!].endTime){
                return true
            }
        }
            return true
    }
    
    static func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let myComponents = myCalendar?.components(.weekday, from: todayDate as Date)
        let weekDay = myComponents?.weekday
        let pyweekDay = (5 + weekDay!) % 7
        return pyweekDay
    }
    
    static func getCurrentTime() -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let currentDay = dateFormatter.date(from: convertedDate)
        return currentDay!
    }
    
}
