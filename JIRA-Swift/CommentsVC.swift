//
//  CommentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class CommentsVC: UITableViewController {

    var issue: Issue?
    var comments:[Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        AKActivityView.add(to: view)
        getComments()
    }
    
    func getComments() {
        if let issue = issue {
            kMainModel.getComments(issueId: issue.issueId!) { (array) in
                self.comments += array as! [Comment]
                self.tableView.reloadData()
                AKActivityView.remove(animated: true)
                self.tableView.separatorStyle = .none
            }
        }
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count == 0 {
            return 1
        }
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
}

//MARK: - CommentsCell

class CommentsCell: UITableViewCell {
    
    var comment: Comment?
    
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var tvBody: UITextView!
    @IBOutlet weak var lbDate: UILabel!
    
    func customInit() {
        if let comment = comment {
            lbAuthor.text = comment.author?.displayName
            lbDate.text = comment.formattedCreated()
            tvBody.text = comment.body
        }
    }

}
