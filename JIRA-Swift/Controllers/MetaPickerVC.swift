//
//  MetaPickerVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/11/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol MetaPickerDelegate {
    
    func selectedPriority(item: IssuePriority?)
}

class MetaPickerVC: UITableViewController {

    var viewModel = MetaPickerViewModel()
    var delegate: MetaPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        navigationItem.title = viewModel.title

        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getPriorities()
    }
    
    func getPriorities() {
        viewModel.getPriorities(fBlock: { [weak self] in
            
            self?.tableView.reloadData()
            self?.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
            
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView, section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.item(for: indexPath.row) as! IssuePriority
        delegate?.selectedPriority(item: item)
        navigationController?.popViewController(animated: true)
    }
}

enum PickerType: String {
    case project, issueType, priority, assignee
}

class MetaPickerViewModel: ViewModel {
    
    var items: [Any] = []
    var type: PickerType?
    
    var title: String {
        return "Priority"
    }
    
    func count() -> Int {
        return items.count
    }
    
    func item(for index: Int) -> Any? {
        guard index < count() else {
            return nil
        }
        return items[index]
    }
    
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        return count()
    }
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let icon = cell.viewWithTag(10) as! ImageViewCache
        let lbName = cell.viewWithTag(20) as! UILabel

        if indexPath.row < count() {
            
            let item = items[indexPath.row] as! IssuePriority
            lbName.text = item.name
            icon.loadImage(url: item.iconUrl)
        }
        return cell
    }
    
    func getPriorities(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/api/2/priority"
        
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
                        
            if let array = responseObj as? [Any] {
                
                var objects: [IssuePriority] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = IssuePriority(JSON: dict)!
                    objects.append(obj)
                }
                self.items = objects
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
