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

class IssueDetailsVC: UITableViewController, AddCommentDelegate, LogWorkDelegate {
    
    var viewModel = IssueDetailsViewModel()

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
        refreshControl?.addTarget(self, action: #selector(getIssue), for: .valueChanged)
        addRightBarButton(image: "ic_more", title: nil)
        navigationItem.title = viewModel.title
        
        AKActivityView.add(to: view)
        getIssue()
    }
    
    @IBAction func goToComments(_ sender: Any) {
        if viewModel.commentsCount > 0 {
            showComments()
        } else {
            addCommentAction()
        }
    }
    
    @IBAction func goToAttachments(_ sender: Any) {
        showAttachments()
    }
    
    func getIssue() {
        viewModel.getIssue(fBlock: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setupUI()
            weakSelf.tableView.reloadData()
            AKActivityView.remove(animated: true)
            weakSelf.refreshControl?.endRefreshing()
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    func refresh() {
        getIssue()
    }
    
    func setupUI() {
        
        if let issue = viewModel.issue {
            
            //project info
            projectIcon.loadImage(url: (issue.project?.iconUrl)!, placeHolder: UIImage(named: "tab_project"))
            projectIcon.roundCorners()
            lbProjInfo.text = viewModel.projInfo
            
            lbSummary.text = viewModel.summary
            tvDescription.text = viewModel.descriptionText
            
            //assignee
            assigneeAvatar.loadImage(url: issue.assignee?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
            assigneeAvatar.roundCorners()
            lbAssignee.text = viewModel.assignee
            
            //reporter
            reporterAvatar.loadImage(url: issue.reporter?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
            reporterAvatar.roundCorners()
            lbReporter.text = viewModel.reporter
            
            //dates
            lbCreated.text = viewModel.created
            lbUpdated.text = viewModel.updated
            
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
        
        let watchString = viewModel.isWatchingIssue ? "Stop Watching" : "Watch"
        let actions = ["Add Comment", "Log Work", watchString]

        actionSheet(items: actions, title: "Choose action") { [weak self] (index) in
            guard let weakSelf = self else { return }
            switch index {
            case 0:
                weakSelf.addCommentAction()
                break
            case 1:
                weakSelf.logWorkAction()
                break
            case 2:
                weakSelf.watchAction()
                break
            default: break
            }
        }
    }
    
    func showComments() {
        Presenter.pushComments(from: navigationController, issue: viewModel.issue)
    }
    
    func showAttachments() {
        Presenter.pushAttachments(from: navigationController, issue: viewModel.issue)
    }
    
    func addCommentAction() {
        Presenter.presentAddComment(from: self, issue: viewModel.issue)
    }
    
    func logWorkAction() {
        Presenter.presentLogWork(from: self, issue: viewModel.issue)
    }
    
    func watchAction() {
        if viewModel.isWatchingIssue {
            removeFromWatchList()
        } else {
            watch()
        }
    }
    
    func watch() {
        ToastView.show("Processing...")
        viewModel.watchIssue( sBlock: { [weak self] in
            guard let weakSelf = self else { return }
            ToastView.hide(fBlock: {
                weakSelf.refresh()
            })
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            ToastView.errHide(fBlock: {
                weakSelf.alert(title: "Error", message: errString)
            })
        }
    }
    
    func removeFromWatchList() {
        ToastView.show("Processing...")
        viewModel.removeFromWatchList(sBlock: { [weak self] in
            guard let weakSelf = self else { return }
            ToastView.hide(fBlock: {
                weakSelf.refresh()
            })
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            ToastView.errHide(fBlock: {
                weakSelf.alert(title: "Error", message: errString)
            })
        }
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
    
    // MARK: Add comment delegate
    
    func commentAdded() {
        refresh()
    }
    
    // MARK: Log work delegate

    func logWorkUpdated() {
        refresh()
    }
}
