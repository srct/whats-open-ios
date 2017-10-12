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
            
            
            if (!(facility.specialSchedule!.openTimes.isEmpty)) {
            if let openDay = today(facility: facility) {
                let nowTime = time(facility)
                if(nowTime == true){
                    open = true
                } else {
                    open = false
                }
            }
            }
        } else {
            if(isMainSchedule(facility:facility)) {
                if(!facility.mainSchedule!.openTimes.isEmpty) {
                    if today(facility: facility) != nil {
                        let nowTime = time(facility)
                        if(nowTime == true) {
                            open = true
                            
                        } else {
                            open = false
                        }
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
    
    //Gets the current day of the week.
    static func today(facility: Facility) -> OpenTimes? {
        let currentDay = getDayOfWeek()
        let day = currentDay
        
        if(isMainSchedule(facility: facility)) {
            for openTime in facility.mainSchedule!.openTimes {
                if(day! >= openTime.startDay && day! <= openTime.endDay) {
                    return openTime
                }
            }
        }
        
        
        return nil
    }
    
    // Converts our startTime and endTime to dates.
    static func convertTime(_ facility: Facility) -> (startTime: Date, endTime: Date)? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "US_en")
        formatter.dateFormat = "HH:mm:ss"
        
        // TODO: This is a forced unwrapping, very dangerous, and needs to be fixed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let startTime = dateFormatter.date(from: facility.mainSchedule!.validStart), let endTime = dateFormatter.date(from: facility.mainSchedule!.validEnd) else { return nil }
        
        return (startTime, endTime)
    }
    
    static func time(_ facility: Facility) -> Bool {
        var time = false
        let nowTime = getCurrentTime()
        // TODO: Check if this logic works
        guard let startEnd = convertTime(facility) else { return false }
        if(startEnd.startTime >= startEnd.endTime || nowTime >= startEnd.startTime && nowTime <= startEnd.endTime) {
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
        let startEnd = convertTime(facility)
        
        if(Utilities.isOpen(facility: facility)) {
            // Might be a better way of doing this, but for now, this works.
            if(isMainSchedule(facility: facility)) {
                if(!facility.mainSchedule!.openTimes.isEmpty) {
                    
                    if startEnd != nil {
                        let time = dateComponentsFormatter.string(from: getCurrentTime(), to: (startEnd!.endTime))
                        return "Closes in \(time!)"
                    }
            }
			//Eventually add more detailled text here, allowing for more custom
			//messages as it gets closer to closing time
        } else {
                if startEnd != nil {
                    let time = dateComponentsFormatter.string(from: getCurrentTime(), to: (startEnd!.startTime)) //This line doesn't work pls fix
                    return "Opens in \(time!)."
                }
			
        }
            
        } else {
            return "Closed"
        }
        return nil

    }
    

    // TODO: Function to check for special schedules.
    static func isSpecialSchedule(_ facility: Facility) -> Bool {
        var isSpecial = false
        if (facility.specialSchedule == nil) {
            isSpecial = false
        }
        else {
            isSpecial = true
        }
        return isSpecial
    }
    
    static func isMainSchedule(facility: Facility) -> Bool {
        return facility.mainSchedule != nil
    }
    
}

