//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class IssueDetailsViewModel: ViewModel {
    
    fileprivate var issueKey: String?
    var issue: Issue?
    
    convenience init(issueKey: String?) {
        self.init()
        self.issueKey = issueKey
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
    
    var projectIconUrl: String? {
        guard let url = issue?.project?.iconUrl else {
            return nil
        }
        return url
    }
    
    var summary: String {
        if let sum = issue?.summary {
            return sum
        }
        return ""
    }
    
    var typeName: String {
        if let name = issue?.type?.name {
            return name
        }
        return ""
    }
    
    var typeIconUrl: String? {
        guard let url = issue?.type?.iconUrl else {
            return nil
        }
        return url
    }
    
    var priorityName: String {
        if let name = issue?.priority?.name {
            return name
        }
        return ""
    }
    
    var priorityIconUrl: String? {
        guard let url = issue?.priority?.iconUrl else {
            return nil
        }
        return url
    }
    
    var statusName: String {
        if let name = issue?.status?.name {
            return name
        }
        return ""
    }
    
    var statusColor: UIColor? {
        guard let color = issue?.status?.getStatusColor() else {
            return .black
        }
        return color
    }
    
    var resolutionName: String {
        if let name = issue?.resolution?.name {
            return name
        }
        return "Unresolved"
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
    
    var assigneeAvatarUrl: String? {
        guard let url = issue?.assignee?.avatarUrl else {
            return nil
        }
        return url
    }
    
    var reporter: String {
        if let text = issue?.reporter?.displayName {
            return text
        }
        return "N/A"
    }
    
    var reporterAvatarUrl: String? {
        guard let url = issue?.reporter?.avatarUrl else {
            return nil
        }
        return url
    }
    
    var created: String {
        return issue?.formattedCreated() ?? "N/A"
    }
    
    var updated: String {
        return issue?.formattedUpdated() ?? "N/A"
    }
    
    var estimated: String {
        if let text = issue?.timeTracking?.originalEstimate {
            return text
        }
        return "Not Specified"
    }
    
    var remaining: String {
        if let text = issue?.timeTracking?.remainingEstimate {
            return text
        }
        return "-"
    }
    
    var logged: String {
        if let text = issue?.timeTracking?.timeSpent {
            return text
        }
        return "-"
    }
    
    var btnCommentsTitle: String {
        if let count = issue?.comments?.count, count > 0 {
            return String(format: "Comments: %zd", count)
        }
        return "Add Comment"
    }
    
    var btnAttachmentsTitle: String {
        if let count = issue?.attachments?.count, count > 0 {
            return String(format: "Attachments: %zd", count)
        }
        return "No attachments yet"
    }
    
    var btnAttachmentsEnabled: Bool {
        if let count = issue?.attachments?.count, count > 0 {
            return true
        }
        return false
    }
    
    //MARK: requests

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
    
}
