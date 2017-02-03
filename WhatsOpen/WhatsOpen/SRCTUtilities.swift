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
        var open = false
        
        //if(specialSchedule(facility: facility) == true) {
        //}
        
        if(!facility.mainSchedule.openTimes.isEmpty) {
            let now = today(facility: facility)
            if(now == true) {
                let nowTime = time(facility: facility)
                if(nowTime == true) {
                    print(facility.mainSchedule.name ," open")
                    open = true
                } else {
                    open = false
                }
                print("Same Day")
            } else {
                open = false
            }
            
            
        } else {
            open = false
        }
        return open
    }
    
    static func getDayOfWeek() -> Int? {
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
    
    static func today(facility: Facility) -> Bool {
        var today = false
        let currentDay = getDayOfWeek()
        let day = currentDay
        
        for i in 0 ..< facility.mainSchedule.openTimes.count {
            if(day! >= facility.mainSchedule.openTimes[i].startDay && day! <= facility.mainSchedule.openTimes[i].endDay) {
                today = true
            }
        }
        
        return today
    }
    
    static func time(facility: Facility) -> Bool {
        var time = false
        let currentTime = getCurrentTime()
        let nowTime = currentTime
        
        for i in 0 ..< facility.mainSchedule.openTimes.count {
            if(nowTime >= facility.mainSchedule.openTimes[i].startTime && nowTime <= facility.mainSchedule.openTimes[i].endTime) {
                time = true
            }
        }
        
        return time
    }
    
    //TODO
    static func timeUntilCloseOfFacility(_ facility: Facility) -> (hours: Int, minutes: Int)? {
        //var currentTime = getCurrentTime()
        if(Utilities.isOpen(facility: facility)) {
            
            return (hours: 0, minutes: 0)
        }
        else {
            return nil
        }
    }
    

    /**static func specialSchedule(facility: Facility) -> Bool {
        var special = false
        if(!(facility.specialSchedules?.openTimes.)){
            special = true
            
        }
        return special
    }**/
    
   
}
