//
//  SRCTUtilities.swift
//  WhatsOpen
//
//  Created by Patrick Murray on 20/11/2016.
//  Copyright © 2016 SRCT. Some rights reserved.
//

import UIKit


class Utilities: NSObject {
    
    
    static func isOpen(facility: Facility) -> Bool {
        var open = false
        if (isSpecialSchedule(facility) == true) {
            
       
        if (!(facility.specialSchedule.openTimes.isEmpty)) {
            if let openDay = today(facility: facility) {
                let nowTime = time(openTime: openDay)
                if(nowTime == true){
                    open = true
                } else {
                    open = false
                }
            }
            }
        } else {
        
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
        }
    
//        print(facility.mainScheduleprint.name ," is ", open)
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
    static func timeUntilFacility(_ facility: Facility) -> String? {
        //var currentTime = getCurrentTime()
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        
        if(Utilities.isOpen(facility: facility)) {
            // Might be a better way of doing this, but for now, this works.
            if(!facility.mainSchedule.openTimes.isEmpty) {
            let time = dateComponentsFormatter.string(from: getCurrentTime(), to: (today(facility: facility)?.endTime)!)
            return "Closes in \(time!)."
            
			//Eventually add more detailled text here, allowing for more custom
			//messages as it gets closer to closing time
        } else {
			let time = dateComponentsFormatter.string(from: getCurrentTime(), to: (today(facility: facility)?.startTime)!) //This line doesn't work pls fix
            return "Opens in \(time!)."
        }
            
        } else {
            return "Closed"
        }

    }
    

    // TODO: Function to check for special schedules.
    static func isSpecialSchedule(_ facility: Facility) -> Bool? {
        var isSpecial = false
        if (facility.specialSchedules == nil) {
            isSpecial = false
            
        }
        else {
            isSpecial = true
        }
        return isSpecial
    }
}

