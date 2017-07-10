//
//  BoardDetailsViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardsViewModel: BaseViewModel {
    
    fileprivate var boards: [Board] = []
    
    var count:Int {
        return boards.count
    }
    
    func remove () {
        boards.removeAll()
    }
    
    func board(index: Int) -> Board {
        return boards[index]
    }
    
    func getBoards(sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let path = baseURL + "/rest/agile/1.0/board/"
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            if let array = dict["values"] as? [Any] {
                var objects: [Board] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Board(JSON: dict)!
                    objects.append(obj)
                }
                self.boards = objects
                sBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < boards.count {
            let item = boards[indexPath.row]
            cell.textLabel?.text = item.name
        }
        return cell
    }
}
