//
//  BoardDetailsViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/5/17.
//  Copyright © 2017 home. All rights reserved.
//

class BoardDetailsViewModel {
    
    var board: Board?
    fileprivate var columns: [BoardColumn?] = []
    fileprivate var boardIssues: [Issue] = []
    
    var title: String {
        if let name = board?.name {
            return name
        }
        return "Board"
    }
    
    var count:Int {
        return columns.count
    }
    
    init(board: Board) {
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
            return String(format: "%@ (%zd)", name, issuesForColumn(name: name).count)
        }
        return ""
    }
    
    func issuesForColumn(name: String) -> [Issue] {
        let filteredArray = boardIssues.filter() { $0.status?.name! == name }
        return filteredArray
    }
    
    func getBoardColumns(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let boardId = board?.boardId else { return }
        
        Request().send(method: .get, url: Api.boardCols(boardId), params: nil, successBlock: { (responseObj) in
            
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
                self.getBoardIssues(fBlock: fBlock, eBlock: eBlock)
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func getBoardIssues(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let boardId = board?.boardId else { return }
        
        Request().send(method: .get, url: Api.boardIssues(boardId), params: nil, successBlock: { (responseObj) in
            
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
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionCell", for: indexPath) as! BoardCollectionCell
        
        if indexPath.row < columns.count {
            let colName = columnName(index: indexPath.row)
            print(colName)
            cell.issues = issuesForColumn(name: colName)
            cell.customInit()
        }
        return cell
    }
    
}
