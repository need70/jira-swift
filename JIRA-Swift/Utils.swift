//
//  Utils.swift
//  JIRA-Swift
//

import Foundation

#if (arch(i386) || arch(x86_64)) && os(iOS)
let DEVICE_IS_SIMULATOR = true
#else
let DEVICE_IS_SIMULATOR = false
#endif

let kWindow = UIApplication.shared.keyWindow!

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
    
    public class func presentWithNavBar(_ vcToPresent: UIViewController, animated: Bool, fromVC: UIViewController, block: (() -> Swift.Void)? = nil) {
        let navCon = UINavigationController()
        navCon.viewControllers = [vcToPresent]
        fromVC.present(navCon, animated: animated, completion: block)
    }
    
//    + (UIImage *)imageWithView:(UIView *)view
//    {
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//    }

    public class func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext as! CGContext)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIView {
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var left: CGFloat {
        return self.frame.origin.x
    }
    
    var right: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    var size: CGSize {
        return self.frame.size
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func roundCorners() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
