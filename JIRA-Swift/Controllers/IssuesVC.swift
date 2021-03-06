//
//  IssuesVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/21/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

let defaultFilterKeys = ["Assigned To Me",
                         "Reported By Me",
                         "Watching",
                         "Recent"]

let defaultFilterValues = ["assignee in (currentUser())",
                           "reporter in (currentUser())",
                           "watcher in (currentUser())",
                           "issuekey in issueHistory()"]

class IssuesVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        addRightBarButton(image: nil, title: "Create")
    }
    
    override func rightBarButtonPressed() {
        Presenter.presentCreateIssue(from: self, issueKey: "key")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultFilterKeys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row < defaultFilterKeys.count {
            cell.textLabel?.text = defaultFilterKeys[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        let orderBy = defaultFilterKeys[index] == "Recent" ? "lastViewed DESC" : nil
        Presenter.pushIssues(from: navigationController, jql: defaultFilterValues[index], order: orderBy, title: defaultFilterKeys[index])
    }
}
