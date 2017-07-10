//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class IssueDetailsViewModel: BaseViewModel {
    
    fileprivate var issueKey: String?
    var issue: Issue?
    
    convenience init(issueKey: String?) {
        self.init()
        self.issueKey = issueKey
    }
    
    func getIssue(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        guard let issueKey = issueKey else {
            eBlock("Issue key not found!")
            return
        }
        
        let pathComponent = String(format: "/rest/api/2/issue/%@", issueKey)
        let path = baseURL + pathComponent
        
        Request().send(method: .get, url: path, params: nil, successBlock: { (responseObj) in
            
            if let dict = responseObj as? [String : Any] {
                self.issue = Issue(JSON: dict)!
                fBlock()
            } else {
                self.issue = Issue(JSON: [:])!
                fBlock()
            }
            
        }, errorBlock: { (error) in
            if let err = error {
                eBlock(err)
            }
        })
    }
    
    func watchIssue(sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        guard let issueId = issue?.issueId else {
            eBlock("Fatal error!")
            return
        }
        
        guard let username = UserDefaults.standard.value(forKey: "Username") as? String else {
            eBlock("Username not found!")
            return
        }
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers", issueId)
        let path = baseURL + pathComponent
        let params = String(format: "\"%@\"", username as String)
        
        Request().send(method: .post, url: path, params: params, successBlock: { (responseObj) in
            print(responseObj as Any)
            sBlock()
        }, errorBlock: { (error) in
            if let err = error {
                eBlock(err)
            }
        })
    }
    
    func removeFromWatchList(sBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        guard let issueId = issue?.issueId else {
            eBlock("Fatal error!")
            return
        }
        
        guard let username = UserDefaults.standard.value(forKey: "Username") as? String else {
            eBlock("Username not found!")
            return
        }
        
        let pathComponent = String(format: "/rest/api/2/issue/%@/watchers?%@", issueId, username)
        let path = baseURL + pathComponent
        
        Request().send(method: .delete, url: path, params: nil, successBlock: { (responseObj) in
            print(responseObj as Any)
            sBlock()
        }, errorBlock: { (error) in
            if let err = error {
                eBlock(err)
            }
        })
    }
    
    var title: String {
        return issueKey ?? "IssueDetails"
    }
    
    var commentsCount: Int {
        if let count = issue?.comments?.count {
            return count
        }
        return 0
    }
    
    var isWatchingIssue: Bool {
        if let isWatching = issue?.isWatching {
            return isWatching
        }
        return false
    }
    
    var projInfo: String {
        if let name = issue?.project?.name, let key = issueKey {
            return name + " / " + key
        }
        return ""
    }
    
    var summary: String {
        if let sum = issue?.summary {
            return sum
        }
        return ""
    }
    
    var descriptionText: String {
        if let text = issue?.descript {
            return text
        }
        return ""
    }
    
    var assignee: String {
        if let text = issue?.assignee?.displayName {
            return text
        }
        return "N/A"
    }
    
    var reporter: String {
        if let text = issue?.reporter?.displayName {
            return text
        }
        return "N/A"
    }
    
    var created: String {
        return issue?.formattedCreated() ?? "N/A"
    }
    
    var updated: String {
        return issue?.formattedUpdated() ?? "N/A"
    }
}
