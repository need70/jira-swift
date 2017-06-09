//
//  Utils.swift
//  CoordinatorExample
//
//  Created by Andriy Kramar on 6/8/17.
//  Copyright © 2017 Will Townsend. All rights reserved.
//

import Foundation

class Utils {
    
    public class func formattedDateFrom(dateStr: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        let date: Date = df.date(from: dateStr)!
        df.dateFormat = "YYYY/MM/dd, HH:mm"
        return df.string(from: date)
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
