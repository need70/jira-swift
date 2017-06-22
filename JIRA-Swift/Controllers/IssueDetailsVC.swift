//
//  IssueDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

enum DetailsSections: Int {
    case info, comments, details, people, dates, timeTracking
}

class IssueDetailsVC: UITableViewController {

    var issueKey: String?
    var issue: Issue?
    
    @IBOutlet weak var lbProjInfo: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var projectIcon: ImageViewCache!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var assigneeAvatar: ImageViewCache!
    @IBOutlet weak var lbAssignee: UILabel!
    @IBOutlet weak var reporterAvatar: ImageViewCache!
    @IBOutlet weak var lbReporter: UILabel!
    @IBOutlet weak var lbCreated: UILabel!
    @IBOutlet weak var lbUpdated: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var typeIcon: ImageViewCache!
    @IBOutlet weak var lbPriority: UILabel!
    @IBOutlet weak var priorityIcon: ImageViewCache!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbResolution: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnAttachments: UIButton!
    @IBOutlet weak var lbEstimated: UILabel!
    @IBOutlet weak var lbRemaining: UILabel!
    @IBOutlet weak var lbLogged: UILabel!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        start()
    }
    
    @IBAction func goToComments(_ sender: Any) {
        
        if let count = issue?.comments?.count, count > 0 {
            showComments()
        } else {
            addCommentAction()
        }
    }
    
    @IBAction func goToAttachments(_ sender: Any) {
        showAttachments()
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension IssueDetailsVC {
    
    func start() {
        refreshControl?.addTarget(self, action: #selector(getIssue), for: .valueChanged)
        addRightBarButton(image: "ic_more", title: nil)
        navigationItem.title = issueKey
        
        AKActivityView.add(to: view)
        getIssue()
    }
    
    func getIssue() {
        if let issueKey = issueKey {
            kMainModel.getIssue(issueId: issueKey) { (obj) in
                self.issue = obj as? Issue
                self.setupUI()
                self.tableView.reloadData()
                AKActivityView.remove(animated: true)
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setupUI() {
        
        if let issue = issue {
            
            //project info
            projectIcon.loadImage(url: (issue.project?.iconUrl)!, placeHolder: UIImage(named: "tab_project"))
            projectIcon.roundCorners()
            lbProjInfo.text = (issue.project?.name)! + " / " + issue.key!
            
            lbSummary.text = issue.summary
            tvDescription.text = issue.descript
            
            //assignee
            assigneeAvatar.loadImage(url: issue.assignee?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
            assigneeAvatar.roundCorners()
            lbAssignee.text = issue.assignee?.displayName ?? "N/A"
            
            //reporter
            reporterAvatar.loadImage(url: issue.reporter?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
            reporterAvatar.roundCorners()
            lbReporter.text = issue.reporter?.displayName ?? "N/A"
            
            //dates
            lbCreated.text = issue.formattedCreated()
            lbUpdated.text = issue.formattedUpdated()
            
            //type
            lbType.text = issue.type?.name
            typeIcon.loadImage(url: (issue.type?.iconUrl)!)
            
            //priority
            lbPriority.text = issue.priority?.name
            priorityIcon.loadImage(url: (issue.priority?.iconUrl)!)
            
            //status
            lbStatus.text = issue.status?.name
            lbStatus.textColor = issue.status?.getStatusColor()
            
            //resolution
            lbResolution.text = issue.resolution?.name ?? "Unresolved"
            
            //comments
            if let count = issue.comments?.count, count > 0 {
                let text = String(format: "Comments: %zd", count)
                btnComments.setTitle(text, for: .normal)
            } else {
                btnComments.setTitle("Add Comment", for: .normal)
            }
            
            //attach
            if let count = issue.attachments?.count, count > 0 {
                let text = String(format: "Attachments: %zd", count)
                btnAttachments.setTitle(text, for: .normal)
                btnAttachments.isEnabled = true
            } else {
                btnAttachments.setTitle("No attachments yet", for: .normal)
                btnAttachments.isEnabled = false
            }
            
            //time tracking
            lbEstimated.text = issue.timeTracking?.originalEstimate ?? "Not Specified"
            lbRemaining.text = issue.timeTracking?.remainingEstimate ?? "-"
            lbLogged.text = issue.timeTracking?.timeSpent ?? "-"
        }
    }
    
    //MARK: right bar button
    
    override func rightBarButtonPressed() {
        
        let watchString = (issue?.isWatching)! ? "Stop Watching" : "Watch"
        let actions = ["Add Comment", "Log Work", watchString]

        Utils.showActionSheet(items: actions, title: "Choose action", vc: self) { (index) in
            switch index {
            case 0:
                self.addCommentAction()
                break
            case 1:
                self.logWorkAction()
                break
            case 2:
                self.watchAction()
                break
            default: break
            }
        }
    }
    
    func showComments() {
        Router.pushComments(from: navigationController, issue: issue)
    }
    
    func showAttachments() {
        Router.pushAttachments(from: navigationController, issue: issue)
    }
    
    func addCommentAction() {
        Router.presentAddComment(from: self, issue: issue)
    }
    
    func logWorkAction() {
        Router.presentLogWork(from: self, issue: issue)
    }
    
    func watchAction() {
        ToastView.show("Processing...")
        kMainModel.watchIssue(issueId: (issue?.issueId)!) {
            ToastView.hide()
        }
    }
}
