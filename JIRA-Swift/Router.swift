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

class Router {
    
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
        idvc.issueKey = issueKey
        from?.pushViewController(idvc, animated: true)
    }
    
   class func pushComments(from: UINavigationController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.issue = issue
        from?.pushViewController(vc, animated: true)
    }
    
    class func pushAttachments(from: UINavigationController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "AttachmentsVC") as! AttachmentsVC
        vc.issue = issue
        from?.pushViewController(vc, animated: true)
    }
    
    class func presentAddComment(from: UIViewController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "AddCommentVC") as! AddCommentVC
        vc.issue = issue
        vc.delegate = from as? AddCommentDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }

    class func presentLogWork(from: UIViewController?, issue: Issue?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "LogWorkVC") as! LogWorkVC
        vc.issue = issue
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
}
