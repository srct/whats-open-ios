// This file was generated by json2swift. https://github.com/ijoshsmith/json2swift

import Foundation

//
// MARK: - Data Model
//

enum Day: Int {
	case Monday = 0
	case Tuesday = 1
	case Wednesday = 2
	case Thursday = 3
	case Friday = 4
	case Saturday = 5
	case Sunday = 6
	
	// Add functions here later if we need them
}

struct OpenTimes: CreatableFromJSON { // TODO: Rename this struct
    let endDay: Int
    let endTime: Date
    let id: Int
    let lastModified: Date
    let schedule: Int
    let startDay: Int
    let startTime: Date
    init(endDay: Int, endTime: Date, id: Int, lastModified: Date, schedule: Int, startDay: Int, startTime: Date) {
        self.endDay = endDay
        self.endTime = endTime
        self.id = id
        self.lastModified = lastModified
        self.schedule = schedule
        self.startDay = startDay
        self.startTime = startTime
    }
    init?(json: [String: Any]) {
        guard let endDay = json["end_day"] as? Int else { return nil }
        guard let endTime = Date(json: json, key: "end_time", format: "HH:mm:ss") else { return nil }
        guard let id = json["id"] as? Int else { return nil }
        guard let lastModified = Date(json: json, key: "last_modified", format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else { return nil }
        guard let schedule = json["schedule"] as? Int else { return nil }
        guard let startDay = json["start_day"] as? Int else { return nil }
        guard let startTime = Date(json: json, key: "start_time", format: "HH:mm:ss") else { return nil }
        self.init(endDay: endDay, endTime: endTime, id: id, lastModified: lastModified, schedule: schedule, startDay: startDay, startTime: startTime)
    }
}


struct Facility: CreatableFromJSON { // TODO: Rename this struct
    let category: Any?
    let id: Int
    let lastModified: Date
    let location: String
    let mainSchedule: MainSchedule
    let name: String
    let specialSchedules: SpecialSchedules?
    init(category: Any?, id: Int, lastModified: Date, location: String, mainSchedule: MainSchedule, name: String, specialSchedules: SpecialSchedules?) {
        self.category = category
        self.id = id
        self.lastModified = lastModified
        self.location = location
        self.mainSchedule = mainSchedule
        self.name = name
        self.specialSchedules = specialSchedules
    }
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int else { return nil }
        guard let lastModified = Date(json: json, key: "last_modified", format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else { return nil }
        guard let location = json["location"] as? String else { return nil }
        guard let mainSchedule = MainSchedule(json: json, key: "main_schedule") else { return nil }
        guard let name = json["name"] as? String else { return nil }
        let specialSchedules = SpecialSchedules(json: json, key: "special_schedules")
        let category = json["category"] as? [Any?]
        self.init(category: category, id: id, lastModified: lastModified, location: location, mainSchedule: mainSchedule, name: name, specialSchedules: specialSchedules)
    }
    struct MainSchedule: CreatableFromJSON { // TODO: Rename this struct
        let id: Int
        let lastModified: Date
        let name: String
        let openTimes: [OpenTimes]
        let validEnd: Date
        let validStart: Date
        init(id: Int, lastModified: Date, name: String, openTimes: [OpenTimes], validEnd: Date, validStart: Date) {
            self.id = id
            self.lastModified = lastModified
            self.name = name
            self.openTimes = openTimes
            self.validEnd = validEnd
            self.validStart = validStart
        }
        init?(json: [String: Any]) {
            guard let id = json["id"] as? Int else { return nil }
            guard let lastModified = Date(json: json, key: "last_modified", format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else { return nil }
            guard let name = json["name"] as? String else { return nil }
            guard let openTimes = OpenTimes.createRequiredInstances(from: json, arrayKey: "open_times") else { return nil }
            guard let validEnd = Date(json: json, key: "valid_end", format: "yyyy-MM-dd") else { return nil }
            guard let validStart = Date(json: json, key: "valid_start", format: "yyyy-MM-dd") else { return nil }
            self.init(id: id, lastModified: lastModified, name: name, openTimes: openTimes, validEnd: validEnd, validStart: validStart)
        }
        
    }
    struct SpecialSchedules: CreatableFromJSON { // TODO: Rename this struct
        let id: Int
        let lastModified: Date
        let name: String
        let openTimes: [OpenTimes]
        let validEnd: Date
        let validStart: Date
        init(id: Int, lastModified: Date, name: String, openTimes: [OpenTimes], validEnd: Date, validStart: Date) {
            self.id = id
            self.lastModified = lastModified
            self.name = name
            self.openTimes = openTimes
            self.validEnd = validEnd
            self.validStart = validStart
        }
        init?(json: [String: Any]) {
            guard let id = json["id"] as? Int else { return nil }
            guard let lastModified = Date(json: json, key: "last_modified", format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") else { return nil }
            guard let name = json["name"] as? String else { return nil }
            guard let openTimes = OpenTimes.createRequiredInstances(from: json, arrayKey: "open_times") else { return nil }
            guard let validEnd = Date(json: json, key: "valid_end", format: "yyyy-MM-dd") else { return nil }
            guard let validStart = Date(json: json, key: "valid_start", format: "yyyy-MM-dd") else { return nil }
            self.init(id: id, lastModified: lastModified, name: name, openTimes: openTimes, validEnd: validEnd, validStart: validStart)
        }
    }
}

//
// MARK: - JSON Utilities
//
/// Adopted by a type that can be instantiated from JSON data.
protocol CreatableFromJSON {
    /// Attempts to configure a new instance of the conforming type with values from a JSON dictionary.
    init?(json: [String: Any])
}

extension CreatableFromJSON {
    /// Attempts to configure a new instance using a JSON dictionary selected by the `key` argument.
    init?(json: [String: Any], key: String) {
        guard let jsonDictionary = json[key] as? [String: Any] else { return nil }
        self.init(json: jsonDictionary)
    }
    
    /// Attempts to produce an array of instances of the conforming type based on an array in the JSON dictionary.
    /// - Returns: `nil` if the JSON array is missing or if there is an invalid/null element in the JSON array.
    static func createRequiredInstances(from json: [String: Any], arrayKey: String) -> [Self]? {
        guard let jsonDictionaries = json[arrayKey] as? [[String: Any]] else { return nil }
        return createRequiredInstances(from: jsonDictionaries)
    }
    
    /// Attempts to produce an array of instances of the conforming type based on an array of JSON dictionaries.
    /// - Returns: `nil` if there is an invalid/null element in the JSON array.
    static func createRequiredInstances(from jsonDictionaries: [[String: Any]]) -> [Self]? {
        var array = [Self]()
        for jsonDictionary in jsonDictionaries {
            guard let instance = Self.init(json: jsonDictionary) else { return nil }
            array.append(instance)
        }
        return array
    }
    
    /// Attempts to produce an array of instances of the conforming type, or `nil`, based on an array in the JSON dictionary.
    /// - Returns: `nil` if the JSON array is missing, or an array with `nil` for each invalid/null element in the JSON array.
    static func createOptionalInstances(from json: [String: Any], arrayKey: String) -> [Self?]? {
        guard let array = json[arrayKey] as? [Any] else { return nil }
        return createOptionalInstances(from: array)
    }
    
    /// Attempts to produce an array of instances of the conforming type, or `nil`, based on an array.
    /// - Returns: An array of instances of the conforming type and `nil` for each invalid/null element in the source array.
    static func createOptionalInstances(from array: [Any]) -> [Self?] {
        return array.map { item in
            if let jsonDictionary = item as? [String: Any] {
                return Self.init(json: jsonDictionary)
            }
            else {
                return nil
            }
        }
    }
}

extension Date {
    // Date formatters are cached because they are expensive to create. All cache access is performed on a serial queue.
    private static let cacheQueue = DispatchQueue(label: "DateFormatterCacheQueue")
    private static var formatterCache = [String: DateFormatter]()
    private static func dateFormatter(with format: String) -> DateFormatter {
        if let formatter = formatterCache[format] { return formatter }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())! // changed to be the user's local time.
        formatterCache[format] = formatter
        return formatter
    }
    
    static func parse(string: String, format: String) -> Date? {
        var formatter: DateFormatter!
        cacheQueue.sync { formatter = dateFormatter(with: format) }
        return formatter.date(from: string)
    }
    
    init?(json: [String: Any], key: String, format: String) {
        guard let string = json[key] as? String else { return nil }
        guard let date = Date.parse(string: string, format: format) else { return nil }
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
}

extension URL {
    init?(json: [String: Any], key: String) {
        guard let string = json[key] as? String else { return nil }
        self.init(string: string)
    }
}

extension Double {
    init?(json: [String: Any], key: String) {
        // Explicitly unboxing the number allows an integer to be converted to a double,
        // which is needed when a JSON attribute value can have either representation.
        guard let nsNumber = json[key] as? NSNumber else { return nil }
        self.init(_: nsNumber.doubleValue)
    }
}

extension Array where Element: NSNumber {
    // Convert integers to doubles, for example [1, 2.0] becomes [1.0, 2.0]
    // This is necessary because ([1, 2.0] as? [Double]) yields nil.
    func toDoubleArray() -> [Double] {
        return map { $0.doubleValue }
    }
}

extension Array where Element: CustomStringConvertible {
    func toDateArray(withFormat format: String) -> [Date]? {
        var dateArray = [Date]()
        for string in self {
            guard let date = Date.parse(string: String(describing: string), format: format) else { return nil }
            dateArray.append(date)
        }
        return dateArray
    }
    
    func toURLArray() -> [URL]? {
        var urlArray = [URL]()
        for string in self {
            guard let url = URL(string: String(describing: string)) else { return nil }
            urlArray.append(url)
        }
        return urlArray
    }
}

extension Array where Element: Any {
    func toOptionalValueArray<Value>() -> [Value?] {
        return map { ($0 is NSNull) ? nil : ($0 as? Value) }
    }
    
    func toOptionalDateArray(withFormat format: String) -> [Date?] {
        return map { item in
            guard let string = item as? String else { return nil }
            return Date.parse(string: string, format: format)
        }
    }
    
    func toOptionalDoubleArray() -> [Double?] {
        return map { item in
            guard let nsNumber = item as? NSNumber else { return nil }
            return nsNumber.doubleValue
        }
    }
    
    func toOptionalURLArray() -> [URL?] {
        return map { item in
            guard let string = item as? String else { return nil }
            return URL(string: string)
        }
    }
}
