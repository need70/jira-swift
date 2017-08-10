//
//  BoardDetailsViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardInfoViewModel {
    
    var board: Board?
    fileprivate var columns: [BoardColumn?] = []
    fileprivate var boardIssues: [Issue] = []
    
    var title: String {
        if let name = board?.name {
            return name
        }
        return "Board"
    }
    
    var columnsCount:Int {
        return columns.count
    }
    
    var colTitles: [String] {
        let actions: [String] = columns.map { $0!.name! }
        return actions
    }
    
    convenience init(board: Board) {
        self.init()
        self.board = board
    }
    
    func columnName(index: Int) -> String {
        if let col = columns[index], let name = col.name {
            return name
        }
        return ""
    }
    
    func nameAndCount(index: Int) -> String {
        if let col = columns[index], let name = col.name {
            return String(format: "%@ (%zd)", name, boardIssues.count)
        }
        return ""
    }
    
    func issuesForColumn(name: String) -> [Issue] {
        let filteredArray = boardIssues.filter() { $0.status?.name! == name }
        return filteredArray
    }
    
    func issueFor(index: Int) -> Issue? {
        guard index < boardIssues.count else {
            return nil
        }
        return boardIssues[index]
    }
    
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        return boardIssues.count > 0 ? boardIssues.count : 1
    }
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        if boardIssues.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell") as! BoardCell
        
        if indexPath.row < boardIssues.count {
            let boardIssue = boardIssues[indexPath.row]
            cell.setup(for: boardIssue)
        }
        return cell
    }
    
    
    //MARK: requests
    
    func getBoardColumns(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let boardId = board?.boardId else { return }
        
        Request().send(method: .get, url: Api.boardCols(boardId).path, params: nil, successBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            let subDict = dict["columnConfig"] as! [String : Any]
            
            if let array = subDict["columns"] as? [Any] {
                
                var objects: [BoardColumn] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = BoardColumn(JSON: dict)!
                    
                    if obj.statuses.count > 0 {
                        objects.append(obj)
                    }
                }
                self.columns = objects
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func getBoardIssues(index: Int, fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let boardId = board?.boardId else { return }
        
        guard let col = columns[index] else { return }
        
        Request().send(method: .get, url: Api.boardIssues(boardId, col.name!).path, params: nil, successBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            
            if let array = dict["issues"] as? [Any] {
                
                var objects: [Issue] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Issue(JSON: dict)!
                    
                    objects.append(obj)
                }
                self.boardIssues = objects
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
