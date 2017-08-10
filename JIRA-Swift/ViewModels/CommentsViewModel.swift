//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol CommentsViewModelProtocol {
    
    var title: String { get }
    var issue: Issue? { get }
    
    func remove()
    func getComments(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock)
    func numberOfRows(_ section: Int) -> Int
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
}

class CommentsViewModel: CommentsViewModelProtocol {
    
    var issue: Issue?
    fileprivate var comments:[Comment] = []
    
    var title: String {
        if let key = issue?.key {
            return "\(key): Comments"
        }
        return "Comments"
    }
    
    func remove() {
        comments.removeAll()
    }

    init(issue: Issue?) {
        self.issue = issue
        if let items = issue?.comments {
            comments = items
        }
    }
    
    func getComments(fBlock: @escaping finishedBlock,  eBlock: @escaping stringBlock) {
        
        guard let key = issue?.key else { return }
        
        Request().send(method: .get, url: Api.comments(key).path, params: nil, successBlock: { (responseObj) in
            
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
    
    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if comments.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell")!
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        if indexPath.row < comments.count {
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .white : RGBColor(250, 250, 250)
            cell.setup(for: comments[indexPath.row])
        }
        return cell
    }
    
    func numberOfRows(_ section: Int) -> Int {
        if comments.count == 0 {
            return 1
        }
        return comments.count
    }
    
}
