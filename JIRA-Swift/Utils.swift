//
//  Utils.swift
//  JIRA-Swift
//

import Foundation

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
    
    public class func formattedDateFrom(dateStr: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        let date: Date = dateFormatter.date(from: dateStr)!
        dateFormatter.dateFormat = "YYYY/MM/dd, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    public class func showActionSheet(items: [String], title: String, vc: UIViewController, block: @escaping (_ index: Int) -> ()) {
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for index in 0..<items.count {
            let action = UIAlertAction(title: items[index], style: .default, handler: { (action) in
                ac.dismiss(animated: true, completion: nil)
                block(index)
            })
            ac.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(cancel)
        vc.present(ac, animated: true, completion: nil)
    }
}
