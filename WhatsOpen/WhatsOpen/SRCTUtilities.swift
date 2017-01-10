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
        var time = getCurrentTime()
        let closedOpen = open(weekDay: currentDay!, facility: facility)
        
        //print(time!)
        //print (currentDay!)
        //print(facility.mainSchedule.openTimes[currentDay!].startDay)
        
        return closedOpen
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
    
    static func open(weekDay: Int, facility: Facility) -> Bool{
        let start = facility.mainSchedule.openTimes[weekDay].startTime
        let end = facility.mainSchedule.openTimes[weekDay].endTime
        let time = getCurrentTime()
        if(time >= start && time <= end){
            return true
        }else{
            return false
        }
    }
    
}
