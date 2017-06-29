//
//  AddCommentVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

protocol AddCommentDelegate {
    func commentAdded()
}

class AddCommentVC: UITableViewController {

    var viewModel = AddCommentViewModel()
    var delegate: AddCommentDelegate?
    
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
        navigationItem.title = viewModel.getTitle()
        
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
            alert(title: "Alert", message: "Enter the comment text, please!")
        }
    }
    
    func addComment() {
        ToastView.show("Adding comment...")
        viewModel.addComment(body: tvCommentBody.text, fBlock: { [weak self] in
            guard let weakSelf = self else { return }
            ToastView.hide(fBlock: {
                weakSelf.finish()
            })
            
        }, eBlock: { [weak self] (errString) in
            guard let weakSelf = self else { return }
            weakSelf.alert(title: "Error", message: errString)
        })
    }
    
    func finish() {
        dismiss(animated: true, completion: {
            self.delegate?.commentAdded()
        })
    }

    //MARK: TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}
