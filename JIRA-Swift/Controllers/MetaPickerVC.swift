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
        viewModel.getPriorities(completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                self?.tableView.reloadData()
                self?.tableView.separatorStyle = .singleLine
                AKActivityView.remove(animated: true)
                
            case .failed(let err):
                AKActivityView.remove(animated: true)
                self?.alert(title: "Error", message: err)
            }
        })
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

class MetaPickerViewModel {
    
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
    
    func getPriorities(completition: @escaping responseHandler) {
        
        request.send(method: .get, url: Api.priority.path, params: nil, completition: { (result) in
                        
            switch result {
                
            case .success(let responseObj):
                
                if let array = responseObj as? [Any] {
                    
                    var objects: [IssuePriority] = []
                    
                    for index in 0..<array.count {
                        let dict = array[index] as! [String: Any]
                        let obj = IssuePriority(JSON: dict)!
                        objects.append(obj)
                    }
                    self.items = objects
                    completition(.success(nil))
                }
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
}
