//
//  IssueDetailsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


class IssueDetailsVC: UITableViewController {

    var issue: IssueObj?
    
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
        tableView.tableFooterView = UIView()
        setupUI()
        tableView.reloadData()
    }
    
    func setupUI() {
        
        if let issue = issue {
            
            //project info
            projectIcon.loadImage(url: (issue.project?.iconUrl)!, placeHolder: UIImage(named: "tab_project"))
            lbProjInfo.text = (issue.project?.name)! + " / " + issue.key
            
            lbSummary.text = issue.summary
            tvDescription.text = issue.theDescription
            
            //assignee
            assigneeAvatar.loadImage(url: (issue.assignee?.avatarUrl)!, placeHolder: UIImage(named: "tab_project"))
            assigneeAvatar.roundCorners()
            lbAssignee.text = issue.assignee?.displayName
            
            //reporter
            reporterAvatar.loadImage(url: (issue.reporter?.avatarUrl)!, placeHolder: UIImage(named: "tab_project"))
            reporterAvatar.roundCorners()
            lbReporter.text = issue.reporter?.displayName
            
            //dates
            lbCreated.text = issue.createdDate
            lbUpdated.text = issue.updatedDate
            
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
            lbResolution.text = issue.resolution?.name
        }
    }

    @IBAction func rightButtonAction(_ sender: UIBarButtonItem) {
        
        let items = ["Log Work", "Watch"]
        Utils.showActionSheet(items: items, title: "Choose action", vc: self) { (index) in
            print("rightButtonAction = \(index)")
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
