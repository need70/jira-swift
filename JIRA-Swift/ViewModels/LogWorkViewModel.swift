//
//  LogWorkViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/10/17.
//  Copyright © 2017 home. All rights reserved.
//

class LogWorkViewModel {
    
    fileprivate var issue: Issue?
    
    init(issue: Issue?) {
        self.issue = issue
    }
    
    var title: String {
        if let issueKey = issue?.key {
            return "Log Work: " + issueKey
        }
        return "Log Work"
    }
    
    func logWork(params: [String : String], completition: @escaping responseHandler) {
        
        guard let key = issue?.key else {
            completition(.failed("Missing issue key!"))
            return
        }
        
        Request().send(method: .post, url: Api.logWork(key).path, params: params, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                print(responseObj!)
                let dict = responseObj as! [String : Any]
                completition(.success(dict))
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
}
