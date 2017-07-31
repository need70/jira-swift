//
//  LogWorkViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/10/17.
//  Copyright © 2017 home. All rights reserved.
//

class LogWorkViewModel: ViewModel {
    
    fileprivate var issue: Issue?
    
    convenience init(issue: Issue?) {
        self.init()
        self.issue = issue
    }
    
    var title: String {
        if let issueKey = issue?.key {
            return "Log Work: " + issueKey
        }
        return "Log Work"
    }
    
    func logWork(params: [String : String], sBlock: @escaping dictBlock, eBlock: @escaping stringBlock) {
        
        guard let issueKey = issue?.key else {
            eBlock("Missing issue key!")
            return
        }
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/worklog?adjustEstimate=auto", issueKey)
        let path = baseURL + pathComponent
        
        Request().send(method: .post, url: path, params: params, successBlock: { (responseObj) in
            print(responseObj!)
            let dict = responseObj as! [String : Any]
            sBlock(dict)
        }, errorBlock: { (error) in
            if let err = error {
                print(err)
                eBlock(err)
            }
        })
    }
}
