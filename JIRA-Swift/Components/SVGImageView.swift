//
//  SVGImageView.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

class SVGImageView: UIWebView {
    
    public func loadUrl(_ urlString: String) {
        self.backgroundColor = .clear
        self.isOpaque = false
        self.scrollView.isScrollEnabled = false
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        self.loadRequest(request)
    }
}
