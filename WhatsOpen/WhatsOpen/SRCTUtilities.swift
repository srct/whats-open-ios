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
        
        let date = Date()
        let result = getDayOfWeek()
        
        
        
        print (result)
        //Testing
        /**
        print(facility.mainSchedule.openTimes[0].startTime)
        print(facility.mainSchedule.openTimes[0].endTime)
        print(facility.mainSchedule.openTimes[0].endDay)
        print(facility.mainSchedule.openTimes[0].startDay)
        **/
        
        
        
        return true;
    }
    
    static func getDayOfWeek()->Int? {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let myComponents = myCalendar?.components(.weekday, from: todayDate as Date)
        let weekDay = myComponents?.weekday
        let pyweekDay = (5 + weekDay!) % 7
        return pyweekDay
    }
    
}
