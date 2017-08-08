//
//  Router.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/19/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let IssuesStoryboard = UIStoryboard(name: "Issues", bundle: nil)
let TempoStoryboard = UIStoryboard(name: "Tempo", bundle: nil)
let BoardsStoryboard = UIStoryboard(name: "Boards", bundle: nil)
let ProjectsStoryboard = UIStoryboard(name: "Projects", bundle: nil)
let SettingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)

class Presenter {
    
   class func presentTabbarController(from: UIViewController?) {
        let vc = MainStoryboard.instantiateViewController(withIdentifier: "TabbarController") as! UITabBarController
        from?.present(vc, animated: true, completion: nil)
    }
    
    class func pushIssues(from: UINavigationController?, jql: String?, order: String?, title: String?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "IssuesListVC") as! IssuesListVC
        vc.viewModel = IssuesListViewModel(jql: jql, orderBy: order, categoryTitle: title)
        from?.pushViewController(vc, animated: true)
    }
    
   class func pushIssueDetails(from: UINavigationController?, issueKey: String?) {
        let idvc = IssuesStoryboard.instantiateViewController(withIdentifier: "IssueDetailsVC") as! IssueDetailsVC
        idvc.viewModel = IssueDetailsViewModel(issueKey: issueKey)
        from?.pushViewController(idvc, animated: true)
    }
    
   class func pushComments(from: UINavigationController?, issue: Issue?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.viewModel = CommentsViewModel(issue: issue)
        from?.pushViewController(vc, animated: true)
    }
    
    class func pushAttachments(from: UINavigationController?, issue: Issue?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "AttachmentsVC") as! AttachmentsVC
        vc.viewModel = AttachmentsViewModel(issue: issue)
        from?.pushViewController(vc, animated: true)
    }
    
    class func presentAddComment(from: UIViewController?, issue: Issue?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "AddCommentVC") as! AddCommentVC
        vc.viewModel = AddCommentViewModel(issue: issue)
        vc.delegate = from as? AddCommentDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }

    class func presentLogWork(from: UIViewController?, issue: Issue?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "LogWorkVC") as! LogWorkVC
        vc.viewModel = LogWorkViewModel(issue: issue)
        vc._delegate = from as? LogWorkDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    
    class func presentWorklogEdit(from: UIViewController?, worklog: Worklog?) {
        let vc = TempoStoryboard.instantiateViewController(withIdentifier: "WorklogEditVC") as! WorklogEditVC
        vc.worklog = worklog
        vc._delegate = from as? WorklogEditDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    
    class func presentCreateIssue(from: UIViewController?, issueKey: String?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "CreateIssueVC") as! CreateIssueVC
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    
    class func pushMetaPicker(from: UINavigationController?, delegate: UIViewController) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "MetaPickerVC") as! MetaPickerVC
        vc.viewModel = MetaPickerViewModel()
        vc.delegate = delegate as? MetaPickerDelegate
        from?.pushViewController(vc, animated: true)
    }
    
    class func pushProjectPicker(from: UINavigationController?, delegate: UIViewController?, items: [Any]) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "ProjectPickerVC") as! ProjectPickerVC
        vc.viewModel = ProjectPickerViewModel(items: items)
        vc.delegate = delegate as? ProjectPickerDelegate
        from?.pushViewController(vc, animated: true)
    }
    
    class func presentOrderBy(from: UIViewController?) {
        let vc = IssuesStoryboard.instantiateViewController(withIdentifier: "OrderByVC") as! OrderByVC
        vc.viewModel = OrderByViewModel()
        vc.viewModel._delegate = from as? OrderByDelegate
        let nc = UINavigationController(rootViewController: vc)
        from?.present(nc, animated: true, completion: nil)
    }
    

}
