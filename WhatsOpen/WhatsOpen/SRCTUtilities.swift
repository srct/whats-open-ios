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
                if today(facility: facility, special: true) != nil {
                    open = time(facility)
                }
            }
        } else {
            if(isMainSchedule(facility:facility)) {
                if facility.mainSchedule!.twentyFourHours {
                    return true
                }
                if(!facility.mainSchedule!.openTimes.isEmpty) {
                    if today(facility: facility) != nil {
                        open = time(facility)
                    }
            }

            } else {
            open = false
        }
        }

        return open
    }

    static func getDayOfWeek(_ day: Day, small: Bool = false) -> String? {
        if !small {
            switch day {
            case .Monday:
                return "Monday"
            case .Tuesday:
                return "Tuesday"
            case .Wednesday:
                return "Wednesday"
            case .Thursday:
                return "Thursday"
            case .Friday:
                return "Friday"
            case .Saturday:
                return "Saturday"
            case .Sunday:
                return "Sunday"
            default:
                return nil
            }
        }
        else {
            switch day {
            case .Monday:
                return "Mon"
            case .Tuesday:
                return "Tue"
            case .Wednesday:
                return "Wed"
            case .Thursday:
                return "Thu"
            case .Friday:
                return "Fri"
            case .Saturday:
                return "Sat"
            case .Sunday:
                return "Sun"
            default:
                return nil
            }
        }

    }
    
    static func getCurrentDayOfWeek() -> Int? {
        let todayDate    = NSDate()
        let myCalendar   = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let myComponents = myCalendar?.components(.weekday, from: todayDate as Date)
        let weekDay      = myComponents?.weekday
        let pyweekDay    = (5 + weekDay!) % 7
        return pyweekDay
    }

    static func getCurrentTime() -> Date {
        let currentDate   = Date()

        let dateFormatter = DateFormatter.easternCoastTimeFormat

        let stringDate    = dateFormatter.string(from: currentDate)
        let formattedDate = dateFormatter.date(from: stringDate)

        return formattedDate!
    }

    //Gets the current day of the week.
    static func today(facility: Facility, special: Bool = false) -> OpenTimes? {
        let scheduleValid     = special ? self.isSpecialSchedule(facility) : self.isMainSchedule(facility: facility)
        let scheduleOpenTimes = special ? facility.specialSchedule!.openTimes : facility.mainSchedule!.openTimes

        let currentDay = getCurrentDayOfWeek()
        if(scheduleValid) {
            for openTime in scheduleOpenTimes {
                if(currentDay! >= openTime.startDay && currentDay! <= openTime.endDay) {
                    return openTime
                }
            }
        }
        return nil
    }

    static func getStartEndDates(_ facility: Facility) -> (startTime: Date, endTime: Date)? {
        let dateFormatter = DateFormatter.easternCoastTimeFormat
        // 24 Hour Case
        if self.isMainSchedule(facility: facility) && facility.mainSchedule!.twentyFourHours {
            let startDate = Date.startOfCurrentDay()
            let endDate   = Date.endOfCurrentDay()
            return (startDate, endDate)
        }
        if let today = self.today(facility: facility) {
            let startTime = today.startTime
            let endTime   = today.endTime

            let formattedStartTime     = dateFormatter.date(from: startTime)
            let formattedEndTimeDate   = dateFormatter.date(from: endTime)

            guard let startTimeDate = formattedStartTime, let endTimeDate = formattedEndTimeDate else { return nil }
            return (startTimeDate, endTimeDate)
        }
        return nil
    }

    static func time(_ facility: Facility) -> Bool {
        let nowTime        = getCurrentTime()
        guard let startEnd = getStartEndDates(facility) else { return false }
        let startTime      = startEnd.startTime
        var endTime        = startEnd.endTime
        if endTime < startTime {
            endTime = Date.endOfCurrentDay()
            if nowTime > Date.startOfCurrentDay() && nowTime < startEnd.endTime {
                endTime = startEnd.endTime
            }
        }
        // Check if the current time is
        // In between the start & end time of the facility
        return (nowTime >= startTime) && nowTime <= (endTime)
    }

    static func timeUntilFacility(_ facility: Facility) -> String? {
        //var currentTime = getCurrentTime()
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        dateComponentsFormatter.maximumUnitCount = 1
        dateComponentsFormatter.unitsStyle = .full
        let startEnd = getStartEndDates(facility)
        if facility.mainSchedule!.twentyFourHours {
            return "Open all day"
        }
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
    static func openOrClosedUntil(_ facility: Facility) -> String? {
        let viewingFormatter = DateFormatter.easternCoastTimeFormatForViewing

        let startEnd = getStartEndDates(facility)
        if facility.mainSchedule!.twentyFourHours {
            return "Open all day"
        }
        if(Utilities.isOpen(facility: facility)) {
            // Might be a better way of doing this, but for now, this works.
            if(isMainSchedule(facility: facility)) {
                if(!facility.mainSchedule!.openTimes.isEmpty) {
                    if startEnd != nil {
                        let time = viewingFormatter.string(from: startEnd!.endTime)
                        return "Open until \(time)"
                    }
                }
                //Eventually add more detailled text here, allowing for more custom
                //messages as it gets closer to closing time
            } else {
                if startEnd != nil {
                    let time = viewingFormatter.string(from: startEnd!.startTime)
                    return "Closed until \(time)."
                }
                
            }
            
        } else {
            return "Closed"
        }
        return nil
    }
    
    static func getFormattedStartandEnd(_ openTime: OpenTimes) -> String? {
        //Is it inelegant to go from string to date to string? maybe.
        //Does it work? absolutely.
        
        let dateFormatter = DateFormatter.easternCoastTimeFormat
        let startTime = dateFormatter.date(from: openTime.startTime)
        let endTime = dateFormatter.date(from: openTime.endTime)
        
        let viewingFormatter = DateFormatter.easternCoastTimeFormatForViewing
        var returning = viewingFormatter.string(from: startTime!) + " - "
        
        if(openTime.startDay != openTime.endDay) {
            returning += getDayOfWeek((Day(rawValue: openTime.endDay))!, small: true)! + " "
        }
        
        returning += viewingFormatter.string(from: endTime!)
        
        return returning
    }

    static func isSpecialSchedule(_ facility: Facility) -> Bool {
        return facility.specialSchedule!.isValid
    }

    static func isMainSchedule(facility: Facility) -> Bool {
        return facility.mainSchedule != nil
    }
    
    //MARK - Favorite facilities
    static func getFavorites() -> [Facility] {
        let defaults = UserDefaults.standard
        let favoriteStrings = defaults.array(forKey: "favorites") as! [String]
        for var str in favoriteStrings {
            // Search through realm DB for facilities w/ matching titles
        }
        return []
    }
    
    static func isFavoriteFacility(_ facility: Facility) -> Bool {
        let defaults = UserDefaults.standard
        let favoriteStrings = defaults.array(forKey: "favorites") as! [String]
        for var str in favoriteStrings! {
            // Search through realm DB for facilities w/ matching title
            // return true if found
        }
        return false
    }
    
    static func addFavoriteFacility(_ facility: Facility) -> Bool {
        if(isFavoriteFacility(facility)) {
            return false
        }
        else {
            let defaults = UserDefaults.standard
            var favoriteStrings = defaults.array(forKey: "favorites") as! [String]
            favoriteStrings.append(facility.facilityName)
            defaults.set(favoriteStrings, forKey: "favorites")
            return true
        }
    }
    
    static func removeFavoriteFacility(_ facility: Facility) -> Bool {
        if(isFavoriteFacility(facility)) {
            let defaults = UserDefaults.standard
            var favoriteStrings = defaults.array(forKey: "favorites") as! [String]
            let removing = favoriteStrings.index(of: facility.facilityName)
            favoriteStrings.remove(at: removing!)
            defaults.set(favoriteStrings, forKey: "favorites")
        }
        else {
            return false
        }
    }

}

extension DateFormatter {
    
    public static var easternCoastTimeFormat: DateFormatter {
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = TimeZone.current
        dateFormatter.locale     = Locale.current
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    public static var easternCoastTimeFormatForViewing: DateFormatter {
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = TimeZone.current
        dateFormatter.locale     = Locale.current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "hh:mm a", options: 0, locale: Locale.current)
        return dateFormatter
    }

}

extension Date {
    public static func endOfCurrentDay() -> Date {
        let dateFormatter = DateFormatter.easternCoastTimeFormat
        let endDate = dateFormatter.date(from: "23:59:59")
        return endDate!
    }

    public static func startOfCurrentDay() -> Date {
        let dateFormatter = DateFormatter.easternCoastTimeFormat
        let startDate = dateFormatter.date(from: "00:00:00")
        return startDate!
    }
}
