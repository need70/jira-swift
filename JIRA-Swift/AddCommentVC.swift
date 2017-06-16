//
//  AddCommentVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class AddCommentVC: UITableViewController {

    var issue: Issue?
    @IBOutlet weak var tvCommentBody: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tvCommentBody.becomeFirstResponder()
    }
    
    func setupUI() {
        
        if let issueKey = issue?.key {
            self.navigationItem.title = "Add Comment to " + issueKey
        }
        
        addRightBarButton(image: nil, title: "Send")
        addLeftBarButton(image: nil, title: "Cancel")
        
        tvCommentBody.layer.borderColor = kSystemSeparatorColor.cgColor
        tvCommentBody.layer.borderWidth = 1
        tvCommentBody.layer.cornerRadius = 5.0
    }
    
    override func leftBarButtonPressed() {
        tvCommentBody.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func rightBarButtonPressed() {
        tvCommentBody.resignFirstResponder()
        if tvCommentBody.text != "" {
            addComment()
        } else {
            Utils.showSimpleAlert(title: "", message: "Enter the comment text, please!", fromVC: self)
        }
    }
    
    func addComment() {
        ToastView.show("Adding comment...")
        
        let params: [String : String] = ["body" : tvCommentBody.text!]
        print("params = \(params)")
        
        kMainModel.addComment(issueId: (issue?.issueId)!, params: params) { (obj) in
            
            let newComment = obj as! Comment
            print(newComment)
            
            ToastView.hide(fBlock: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    //MARK: TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}
