//
//  Utils.swift
//  JIRA-Swift
//

import Foundation

public typealias finishedBlock = () -> ()
public typealias arrayBlock = (_ array: [Any]) -> ()
public typealias dictBlock = (_ responseDict: [String: Any]?) -> ()
public typealias errorBlock = (_ error: Error?) -> ()
public typealias anyBlock = (_ any: Any?) -> ()
public typealias stringBlock = (_ string: String?) -> ()

#if (arch(i386) || arch(x86_64)) && os(iOS)
let DEVICE_IS_SIMULATOR = true
#else
let DEVICE_IS_SIMULATOR = false
#endif

let kWindow = UIApplication.shared.keyWindow!
let kSystemTintColor = RGBColor(25, 118, 210)
let kSystemSeparatorColor = RGBColor(241, 241, 241)

public func RGBColor(_ red: Float, _ green: Float, _ blue: Float) -> UIColor {
    let color = UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    return color
}

public func RGBAColor(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float) -> UIColor {
    let color = UIColor(colorLiteralRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    return color
}


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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        let date: Date = dateFormatter.date(from: dateStr)!
        dateFormatter.dateFormat = "YYYY/MM/dd, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    public class func formattedStringDateFrom(date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        return dateFormatter.string(from: date)
    }
    
    public class func presentWithNavBar(_ vcToPresent: UIViewController, animated: Bool, fromVC: UIViewController, block: (() -> Swift.Void)? = nil) {
        let navCon = UINavigationController()
        navCon.viewControllers = [vcToPresent]
        fromVC.present(navCon, animated: animated, completion: block)
    }

    public class func imageFromView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public class func alert(title: String?, message: String?, fromVC: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(action)
        fromVC.present(ac, animated: true, completion: nil)
    }

}
