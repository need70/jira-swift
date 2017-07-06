//
//  Router.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

let kMainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let kIssuesStoryboard = UIStoryboard(name: "Issues", bundle: nil)
let kTempoStoryboard = UIStoryboard(name: "Tempo", bundle: nil)

class Presenter {
    
   class func presentTabbarController(from: UIViewController?) {
        let vc = kMainStoryboard.instantiateViewController(withIdentifier: "TabbarController") as! UITabBarController
        from?.present(vc, animated: true, completion: nil)
    }
    
    class func pushIssues(from: UINavigationController?, jql: String?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "IssuesListVC") as! IssuesListVC
        vc.jql = jql
        from?.pushViewController(vc, animated: true)
    }
    
   class func pushIssueDetails(from: UINavigationController?, issueKey: String?) {
        let idvc = kIssuesStoryboard.instantiateViewController(withIdentifier: "IssueDetailsVC") as! IssueDetailsVC
        idvc.viewModel = IssueDetailsViewModel(issueKey: issueKey)
        from?.pushViewController(idvc, animated: true)
    }
    
   class func pushComments(from: UINavigationController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.viewModel = CommentsViewModel(issue: issue)
        from?.pushViewController(vc, animated: true)
    }
    
    class func pushAttachments(from: UINavigationController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "AttachmentsVC") as! AttachmentsVC
        vc.viewModel = AttachmentsViewModel(issue: issue)
        from?.pushViewController(vc, animated: true)
    }
    
    class func presentAddComment(from: UIViewController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "AddCommentVC") as! AddCommentVC
        vc.viewModel = AddCommentViewModel(issue: issue)
        vc.delegate = from as? AddCommentDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }

    class func presentLogWork(from: UIViewController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "LogWorkVC") as! LogWorkVC
        vc.issue = issue
        vc._delegate = from as? LogWorkDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    
    class func presentWorklogEdit(from: UIViewController?, worklog: Worklog?) {
        let vc = kTempoStoryboard.instantiateViewController(withIdentifier: "WorklogEditVC") as! WorklogEditVC
        vc.worklog = worklog
        vc._delegate = from as? WorklogEditDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
}