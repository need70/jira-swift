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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
        performSegue(withIdentifier: "segueIssuesToList", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueIssuesToList" {
            let index = sender as! Int
            let vc = segue.destination as! IssuesListVC
            vc.categoryTitle = defaultFilterKeys[index]
            vc.jql = defaultFilterValues[index]
            if defaultFilterKeys[index] == "Recent" {
                vc.orderBy = "lastViewed DESC"
            }
        }
    }
}
