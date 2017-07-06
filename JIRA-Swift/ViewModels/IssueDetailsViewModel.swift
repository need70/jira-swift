//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class IssueDetailsViewModel: BaseViewModel {
    
    var issueKey: String?
    var issue: Issue?
    
    convenience init(issueKey: String?) {
        self.init()
        self.issueKey = issueKey
    }
    
    func getIssue(fBlock: @escaping finishedBlock, eBlock: @escaping stringBlock) {
        
        let pathComponent = String(format: "/rest/api/2/issue/%@", issueKey!)
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
        return (issue?.isWatching)!
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
