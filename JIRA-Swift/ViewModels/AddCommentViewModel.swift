//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

protocol AddCommentViewModelProtocol {
    
    var title: String { get }
    func addComment(body: String, completition: @escaping responseHandler)
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
    
    func addComment(body: String, completition: @escaping responseHandler) {
        
        guard let key = issue?.key else { return }
        let params = ["body" : body]
        
        Request().send(method: .post, url: Api.comments(key).path, params: params, completition: { (result) in
            
            switch result {
                
            case .success(_):
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
}
