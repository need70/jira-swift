//
//  SettingViewModel.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

class IssueDetailsViewModel {
    
    fileprivate var issueKey: String?
    var issue: Issue?
    
    init(issueKey: String?) {
        self.issueKey = issueKey
    }
    
    var title: String {
        return issueKey ?? "Issue Details"
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

    func getIssue(completition: @escaping responseHandler) {
        
        guard let key = issueKey else {
            completition(.failed("Issue key not found!"))
            return
        }
        
        request.send(method: .get, url: Api.issue(key).path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                if let dict = responseObj as? [String : Any] {
                    self.issue = Issue(JSON: dict)!
                } else {
                    self.issue = Issue(JSON: [:])!
                }
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
    
    func watchIssue(completition: @escaping responseHandler) {
        
        guard let issueId = issue?.issueId else {
            completition(.failed("Fatal error!"))
            return
        }
        
        guard let username = UserDefaults.standard.value(forKey: "Username") as? String else {
            completition(.failed("Username not found!"))
            return
        }
        
        let params = String(format: "\"%@\"", username as String)
        
        request.send(method: .post, url: Api.watchIssue(issueId).path, params: params, completition: { (result) in
            
            switch result {
                
            case .success(_):
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
    
    func removeFromWatchList(completition: @escaping responseHandler) {
        
        guard let issueId = issue?.issueId else {
            completition(.failed("Fatal error!"))
            return
        }
        
        guard let username = UserDefaults.standard.value(forKey: "Username") as? String else {
            completition(.failed("Username not found!"))
            return
        }
        
        request.send(method: .delete, url: Api.unwatchIssue(issueId, username).path, params: nil, completition: { (result) in

            switch result {
                
            case .success(_):
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
            }
        
        })
    }
    
    func getTransitions(completition: @escaping responseHandler) {
        
        guard let key = issueKey else {
            completition(.failed("Issue key not found!"))
            return
        }
        
        Request().send(method: .get, url: Api.transitions(key).path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                if let dict = responseObj as? [String : Any], let array =  dict["transitions"] as? [Any] {
                    
                    var objects: [Transition] = []
                    
                    for index in 0..<array.count {
                        let dict = array[index] as! [String: Any]
                        let obj: Transition = Transition(JSON: dict)!
                        objects.append(obj)
                    }
                    completition(.success(objects))
                }
                
            case .failed(let err):
                completition(.failed(err))
            }
            
        })
    }
    
    func updateStatus(transition: Transition?, completition: @escaping responseHandler) {
        
        guard let key = issueKey else {
            completition(.failed("Issue key not found!"))
            return
        }
        
        guard transition != nil else {
            completition(.failed("Transition not found!"))
            return
        }
        
        let params = ["transition": ["id" : transition?.transitionId]]
        
        request.send(method: .post, url: Api.transitions(key).path, params: params, completition: { (result) in
            
            switch result {
                
            case .success(_):
                completition(.success(nil))
                
            case .failed(let err):
                completition(.failed(err))
                
            }
        })
    }
    
}
