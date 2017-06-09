//
//  Utils.swift
//  JIRA-Swift
//
//  Created by Denis Senichkin on 7/6/17.
//  Copyright © 2017 Denis Senichkin. All rights reserved.
//

class Utils {
    
    static var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
    
    class func stringFromDate(fromDate: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        let stringFromDate = dateFormatter.string(from: fromDate)
        return stringFromDate.capitalized
    }
    
    class func dateFromString(fromString: String, format: String) -> Date {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: fromString) {
            return date
        }
        return Date()
    }
}
