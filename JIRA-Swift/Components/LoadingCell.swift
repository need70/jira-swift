//
//  LoadingCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/9/17.
//  Copyright © 2017 home. All rights reserved.
//

let useCircleIndicatorHere = true

class LoadingCell: UITableViewCell {
    
    static var cellHeight: CGFloat = 60
    static var cellTag: Int = 7777
    
    public class func instance() -> LoadingCell {
        let cell = LoadingCell(style: .default, reuseIdentifier: "LoadingCell")
        return cell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.width)!, height: LoadingCell.cellHeight)
        self.tag = LoadingCell.cellTag
        self.backgroundColor = .clear
        
        if useCircleIndicatorHere {
            let indicator = CircleIndicatorView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            indicator.lineWidth = 1.0
            indicator.center = self.center
            self.addSubview(indicator)
        } else {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.center = self.center
            indicator.startAnimating()
            self.addSubview(indicator)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
