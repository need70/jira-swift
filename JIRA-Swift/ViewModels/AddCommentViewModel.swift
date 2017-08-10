//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol AddCommentViewModelProtocol {
    
    var title: String { get }
    func addComment(body: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock)
}

class AddCommentViewModel: AddCommentViewModelProtocol {
    
    var issue: Issue?
    
    init(issue: Issue?) {
        self.issue = issue
    }
    
    var title: String {
        if let issueKey = issue?.key {
             return issueKey + ": Add Comment"
        }
        return "Add Comment"
    }
    
    func addComment(body: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        guard let key = issue?.key else { return }
        let params = ["body" : body]
        
        Request().send(method: .post, url: Api.comments(key).path, params: params, successBlock: { (responseObj) in
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                eBlock(err)
            }
        })
    }
}
