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
        
        let date = getDayOfWeek()
        // Swift has Sunday = 1, Python has Monday = 0.
        // This fixes the issue, thanks to rhitt, should be incorporated into the function, but that's hard.
        let pyDate = (5 + date!) % 7
        
        
        
        print (pyDate)
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
        return weekDay
    }
    
}
