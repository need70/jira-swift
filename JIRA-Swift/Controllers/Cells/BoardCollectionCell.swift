//
//  BoardCollectionCell.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var issues: [Issue] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func customInit() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    // MARK:  UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardIssueCell", for: indexPath) as! BoardIssueCell
        
        if indexPath.row < issues.count {
            cell.issue = issues[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < issues.count {
            let issue = issues[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BoardIssueTapped"), object: issue)
        }
        
    }
}
