//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class AddCommentViewModel: BaseViewModel {
    
    var issue: Issue?
    
    convenience init(issue: Issue?) {
        self.init()
        self.issue = issue
    }
    
    func getTitle() -> String {
        if let issueKey = issue?.key {
             return issueKey + ": Add Comment"
        }
        return "Add Comment"
    }
    
    func addComment(body: String, fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let params = ["body" : body]
        let pathComponent = String(format: "/rest/api/2/issue/%@/comment", (issue?.issueId)!)
        let path = baseURL + pathComponent
        
        Request().send(method: .post, url: path, params: params, successBlock: { (responseObj) in
            fBlock()
        }, errorBlock: { (error) in
            if let err = error {
                eBlock(err)
            }
        })
    }
}
