//
//  IssueDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


class IssueDetailsVC: UITableViewController {

    var issueKey: NSNumber = NSNumber()
    
    let someLabel: UILabel = {
        let lbl: UILabel = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 50))
        lbl.backgroundColor = .yellow
        lbl.text = "some text"
        return lbl
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        self.title = "Issue Details \(issueKey)"
        self.tableView.addSubview(someLabel)
        
        
    }
}
