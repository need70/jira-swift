//
//  BoardDetailsViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardsViewModel {
    
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
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row < boards.count {
            let item = boards[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.type
        }
        return cell
    }
    
    func getBoards(completition: @escaping responseHandler) {
        
        request.send(method: .get, url: Api.boards.path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                let dict = responseObj as! [String : Any]
                if let array = dict["values"] as? [Any] {
                    var objects: [Board] = []
                    
                    for index in 0..<array.count {
                        let dict = array[index] as! [String: Any]
                        let obj = Board(JSON: dict)!
                        objects.append(obj)
                    }
                    self.boards = objects
                    completition(.success(nil))
                }
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
    

}
