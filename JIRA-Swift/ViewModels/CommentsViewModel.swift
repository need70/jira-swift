//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class CommentsViewModel: BaseViewModel {
    
    var issue: Issue?
    var comments:[Comment] = []
    
    convenience init(issue: Issue?) {
        self.init()
        self.issue = issue
        if let items = issue?.comments {
            comments = items
        }
    }
    
    func getComments(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let issueKey = issue?.key else { return }
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", issueKey)
        let path = baseURL + pathComponent
        
        Request().sendGET(url: path, successBlock: { (responseObj) in
            
            let dict = responseObj as! [String : Any]
            
            if let array = dict["comments"] as? [Any] {
                
                var objects: [Comment] = []
                
                for index in 0..<array.count {
                    let dict = array[index] as! [String: Any]
                    let obj = Comment(JSON: dict)!
                    objects.append(obj)
                }
                self.comments = objects
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if comments.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell")!
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentsCell
        
        if indexPath.row < comments.count {
            cell.comment = comments[indexPath.row]
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .white : RGBColor(250, 250, 250)
            cell.customInit()
        }
        return cell
    }
    
    func numberOfRows(tableView: UITableView, section: Int) -> Int {
        if comments.count == 0 {
            return 1
        }
        return comments.count
    }
    
}
