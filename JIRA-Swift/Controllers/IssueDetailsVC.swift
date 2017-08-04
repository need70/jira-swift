//
//  IssueDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class IssueDetailsVC: UITableViewController {
    
    private enum Sections: Int {
        case info, comments, details, people, dates, timeTracking
    }
    
    var viewModel = IssueDetailsViewModel(issueKey: nil)

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
            self?.setupUI()
            self?.tableView.reloadData()
            AKActivityView.remove(animated: true)
            self?.refreshControl?.endRefreshing()
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func refresh() {
        getIssue()
    }
    
    func setupUI() {
        
        projectIcon.roundCorners()
        assigneeAvatar.roundCorners()
        reporterAvatar.roundCorners()
        
        //project info
        projectIcon.loadImage(url: viewModel.projectIconUrl, placeHolder: UIImage(named: "tab_project"))
        lbProjInfo.text = viewModel.projInfo
        
        lbSummary.text = viewModel.summary
        tvDescription.text = viewModel.descriptionText
        
        //assignee
        assigneeAvatar.loadImage(url: viewModel.assigneeAvatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
        lbAssignee.text = viewModel.assignee

        //reporter
        reporterAvatar.loadImage(url: viewModel.reporterAvatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
        lbReporter.text = viewModel.reporter
        
        //dates
        lbCreated.text = viewModel.created
        lbUpdated.text = viewModel.updated
        
        //type
        lbType.text = viewModel.typeName
        typeIcon.loadImage(url: viewModel.typeIconUrl)
        
        //priority
        lbPriority.text = viewModel.priorityName
        priorityIcon.loadImage(url: viewModel.priorityIconUrl)
        
        //status
        lbStatus.text = viewModel.statusName
        lbStatus.textColor = viewModel.statusColor
        
        //resolution
        lbResolution.text = viewModel.resolutionName
        
        //time tracking
        lbEstimated.text = viewModel.estimated
        lbRemaining.text = viewModel.remaining
        lbLogged.text = viewModel.logged
        
        //comments
        btnComments.setTitle(viewModel.btnCommentsTitle, for: .normal)
        
        //attach
        btnAttachments.setTitle(viewModel.btnAttachmentsTitle, for: .normal)
        btnAttachments.isEnabled = viewModel.btnAttachmentsEnabled
    }
    
    //MARK: right bar button
    
    override func rightBarButtonPressed() {
        
        let watchString = viewModel.isWatchingIssue ? "Stop Watching" : "Watch"
        let actions = ["Add Comment", "Log Work", watchString]

        actionSheet(items: actions, title: "Choose action") { [weak self] (index) in
            switch index {
            case 0:
                self?.addCommentAction()
                break
            case 1:
                self?.logWorkAction()
                break
            case 2:
                self?.watchAction()
                break
            default: break
            }
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
        
        switch indexPath.section {
        case Sections.details.rawValue:
            if indexPath.row == 2 {
                getStatuses()
            }
            break
        default: break
        }
    }
}

extension IssueDetailsVC {
    
    //MARK: Actions
    
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
            ToastView.hide(fBlock: {
                self?.refresh()
            })
        }) { [weak self] (errString) in
            ToastView.errHide(fBlock: {
                self?.alert(title: "Error", message: errString)
            })
        }
    }
    
    func removeFromWatchList() {
        ToastView.show("Processing...")
        viewModel.removeFromWatchList(sBlock: { [weak self] in
            ToastView.hide(fBlock: {
                self?.refresh()
            })
        }) { [weak self] (errString) in
            ToastView.errHide(fBlock: {
                self?.alert(title: "Error", message: errString)
            })
        }
    }
    
    func getStatuses() {
        ToastView.show("Processing...")
        viewModel.getTransitions(fBlock: { [weak self] array in
            
            ToastView.errHide(fBlock: nil)
            guard let transitions = array as? [Transition], transitions.count > 0 else {
                return
            }
            
            let actions: [String] = transitions.map { $0.name! }

            self?.actionSheet(items: actions, title: "Move issue to") { [weak self] (index) in
                
                let transition = transitions[index]
                self?.changeStatus(for: transition)
            }
            
        }) { [weak self] (errString) in
            ToastView.errHide(fBlock: {
                self?.alert(title: "Error", message: errString)
            })
        }
    }
    
    func changeStatus(for transition: Transition?) {
        ToastView.show("Processing...")
        viewModel.updateStatus(transition: transition, fBlock: { [weak self] in
            ToastView.hide(fBlock: {
                self?.refresh()
            })
        }) { [weak self] (errString) in
            ToastView.errHide(fBlock: {
                self?.alert(title: "Error", message: errString)
            })
        }
    }
}

extension IssueDetailsVC: AddCommentDelegate, LogWorkDelegate {
    
    // MARK: Add comment delegate
    
    func commentAdded() {
        refresh()
    }
    
    // MARK: Log work delegate
    
    func logWorkUpdated() {
        refresh()
    }
}
