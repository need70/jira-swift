//
//  IssueDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


class IssueDetailsVC: UITableViewController {

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
    
    override func viewDidLoad() {
       super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(getIssue), for: .valueChanged)

        AKActivityView.add(to: view)
        getIssue()
    }
    
    func getIssue() {
        kMainModel.getIssue(issueId: (issue?.key)!) { (obj) in
            self.issue = obj as? Issue
            self.setupUI()
            self.tableView.reloadData()
            AKActivityView.remove(animated: true)
            self.tableView.separatorStyle = .none
            self.refreshControl?.endRefreshing()
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
            assigneeAvatar.loadImage(url: issue.assignee?.avatarUrl, placeHolder: UIImage(named: "tab_project"))
            assigneeAvatar.roundCorners()
            lbAssignee.text = issue.assignee?.displayName ?? "N/A"

            //reporter
            reporterAvatar.loadImage(url: issue.reporter?.avatarUrl, placeHolder: UIImage(named: "tab_project"))
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

}
