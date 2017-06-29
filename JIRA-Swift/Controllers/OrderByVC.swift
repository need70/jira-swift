//
//  OrderByVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol OrderByDelegate {
    func selectedField(field: Field)
}

class OrderByVC: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var fields: [Field] = []
    var filteredFields: [Field] = []
    var selectedField: Field?
    var _delegate: OrderByDelegate?
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sort By"
        addLeftBarButton(image: nil, title: "Cancel")
        addRightBarButton(image: nil, title: "Apply")
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getOrderBy()
    }
    
    func getOrderBy() {
        kMainModel.getOrderBy(fBlock: { [weak self] (items) in
            
            guard let weakSelf = self else { return }
            weakSelf.fields += items as! [Field]
            weakSelf.tableView.separatorStyle = .singleLine
            weakSelf.tableView.reloadData()
            AKActivityView.remove(animated: true)
            
        }) {[weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    override func rightBarButtonPressed() {
        dismiss(animated: true) {
            guard let field = self.selectedField else { return }
            self._delegate?.selectedField(field: field)
        }
    }
    
    override func leftBarButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredFields.count
        }
        return fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row < fields.count {
            
            let field = searchActive ? filteredFields[indexPath.row] : fields[indexPath.row]
            
            if field.fieldId == selectedField?.fieldId {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            cell.textLabel?.text = field.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let field = searchActive ? filteredFields[indexPath.row] : fields[indexPath.row]
        selectedField = field
        tableView.reloadData()
    }

    //MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredFields = fields.filter({ (field) -> Bool in
            let tmp = field.name!
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range != nil
        })
        
        if(filteredFields.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
}
