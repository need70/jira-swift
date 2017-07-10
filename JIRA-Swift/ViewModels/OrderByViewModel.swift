//
//  OrderByViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/10/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol OrderByDelegate {
    func selectedField(_ field: Field?)
}

class OrderByViewModel: BaseViewModel {
    
    fileprivate var fields: [Field] = []
    fileprivate var filteredFields: [Field] = []
    fileprivate var searchActive = false
    var selectedField: Field?
    var _delegate: OrderByDelegate?
    
    var count: Int {
        return fields.count
    }
    
    var filteredCount: Int {
        return filteredFields.count
    }
    
    func numberOfRows(tableView: UITableView, section: Int) -> Int {
        if(searchActive) {
            return filteredFields.count
        }
        return fields.count
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func setSelectedField(index: Int) {
        let field = searchActive ? filteredFields[index] : fields[index]
        selectedField = field
    }
    
    func handleSearchBar(text: String) {
        filteredFields = fields.filter({ (field) -> Bool in
            let tmp = field.name!
            let range = tmp.range(of: text, options: .caseInsensitive)
            return range != nil
        })
        
        if(filteredCount == 0){
            searchActive = false
        } else {
            searchActive = true
        }
    }
    
    func handleSelectedField() {
        _delegate?.selectedField(selectedField)
    }
    
    func getOrderBy(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/api/2/field"
        
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
            print(responseObj as! [Any])
            
            let array = responseObj as! [Any]
            
            var objects: [Field] = []
            
            for index in 0..<array.count {
                let dict = array[index] as! [String: Any]
                let obj = Field(JSON: dict)!
                objects.append(obj)
            }
            self.fields = objects
            fBlock()
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
