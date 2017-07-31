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
    
    class func pushIssues(from: UINavigationController?, jql: String?, order: String?, title: String?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "IssuesListVC") as! IssuesListVC
        vc.viewModel = IssuesListViewModel(jql: jql, orderBy: order, categoryTitle: title)
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
        vc.viewModel = LogWorkViewModel(issue: issue)
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
    
    class func presentCreateIssue(from: UIViewController?, issueKey: String?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "CreateIssueVC") as! CreateIssueVC
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    
    class func pushMetaPicker(from: UINavigationController?, delegate: UIViewController) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "MetaPickerVC") as! MetaPickerVC
        vc.viewModel = MetaPickerViewModel()
        vc.delegate = delegate as? MetaPickerDelegate
        from?.pushViewController(vc, animated: true)
    }
    
    class func pushProjectPicker(from: UINavigationController?, delegate: UIViewController?, items: [Any]) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "ProjectPickerVC") as! ProjectPickerVC
        vc.viewModel = ProjectPickerViewModel(items: items)
        vc.delegate = delegate as? ProjectPickerDelegate
        from?.pushViewController(vc, animated: true)
    }
    
    class func presentOrderBy(from: UIViewController?) {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "OrderByVC") as! OrderByVC
        vc.viewModel = OrderByViewModel()
        vc.viewModel._delegate = from as? OrderByDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    

}
