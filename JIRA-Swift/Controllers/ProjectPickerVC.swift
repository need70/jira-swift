//
//  ProjectPickerVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol ProjectPickerDelegate {
    func selectedItem(item: Any)
}

class ProjectPickerVC: UITableViewController {
    
    var viewModel = ProjectPickerViewModel()
    var delegate: ProjectPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(for: indexPath.row) as Any
        delegate?.selectedItem(item: item)
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - ProjectPickerViewModel

class ProjectPickerViewModel: ViewModel {
    
    fileprivate var items: [Any] = []
    
    convenience init(items: [Any]) {
        self.init()
        self.items = items
        
        //if we select IssueType remove type Sub-Task. Sub-task type 
        if self.items is [IssueType] {
            self.items = self.items.filter() { ($0 as! IssueType).isSubtask == false }
        }
    }
    
    var title: String {
        if self.items is [Project] {
            return "Select Project"
        } else if self.items is [IssueType] {
            return "Select Issue Type"
        }
        return ""
    }
    
    var count: Int {
        return items.count
    }
    
    func item(for index: Int) -> Any? {
        guard index < count else {
            return nil
        }
        return items[index]
    }
    
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        return count
    }
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let icon = cell.viewWithTag(10) as! ImageViewCache
        let lbName = cell.viewWithTag(20) as! UILabel
        
        if indexPath.row < count {
            if items is [Project]  {
                let item = items[indexPath.row] as! Project
                lbName.text = item.name
                icon.loadImage(url: item.iconUrl)
            } else if items is [IssueType] {
                let item = items[indexPath.row] as! IssueType
                lbName.text = item.name
                icon.loadImage(url: item.iconUrl)
            }
        }
        return cell
    }
}
