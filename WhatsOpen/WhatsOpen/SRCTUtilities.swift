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
        let currentTime = time
        let day = currentDay
        var open:Bool = false
        if(!facility.mainSchedule.openTimes.isEmpty){
            for i in 0 ..< facility.mainSchedule.openTimes.count{
                
                if(day! >= facility.mainSchedule.openTimes[i].startDay || day! <= facility.mainSchedule.openTimes[i].endDay){
                    
                    if(currentTime >= facility.mainSchedule.openTimes[i].startTime && currentTime <= facility.mainSchedule.openTimes[i].endTime){
                        open = true
                        return open
                    }else{
                        open = false
                    }
                }
            }
       
        }
        return open
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
        dateFormatter.locale = Locale(identifier: "ET")
        dateFormatter.dateFormat = "HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let currentDay = dateFormatter.date(from: convertedDate)
        return currentDay!
    }
    
}
