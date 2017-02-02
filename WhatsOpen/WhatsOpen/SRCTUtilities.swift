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
        
        if(!facility.mainSchedule.openTimes.isEmpty) {
            if let openDay = today(facility: facility) {
                let nowTime = time(openTime: openDay)
                if(nowTime == true) {
                    open = true
                } else {
                    open = false
                }
            }
        } else {
            open = false
        }
        print(facility.mainSchedule.name ," is ", open)
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
    
    static func today(facility: Facility) -> OpenTimes? {
        let currentDay = getDayOfWeek()
        let day = currentDay
        
        for openTime in facility.mainSchedule.openTimes {
            if(day! >= openTime.startDay && day! <= openTime.endDay) {
                return openTime
            }
        }
        
        return nil
    }
    
    static func time(openTime: OpenTimes) -> Bool {
        var time = false
        let nowTime = getCurrentTime()
        
        if(openTime.startTime >= openTime.endTime || nowTime >= openTime.startTime && nowTime <= openTime.endTime) {
            time = true
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
    
    // TODO: Function to check for special schedules?
    //================== PAT LOOK HERE ==================
    /** static func specialSchedule(facility: Facility) -> Bool {
     var special = false
     if(!(facility.specialSchedules!.openTimes.isEmpty)){
     special = true
     
     }
     return special
     } ================== PAT LOOK HERE ==================**/
    
    
}
