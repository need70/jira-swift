//
//  UIView+additions.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/8/17.
//  Copyright © 2017 home. All rights reserved.
//

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
