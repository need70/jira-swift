//
//  IssueContainerVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


enum IssueContainerState: Int {
    case details, comments, attachments
}

let actions = ["Add Comment", "Log Work", "Watch"]

class IssueContainerVC: UIViewController {

    var issue: Issue?
    var state: IssueContainerState = .details
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet weak var attachmentsContainer: UIView!
    @IBOutlet weak var commentsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRightBarButton(image: "ic_more", title: nil)
        setupContainers()
    }
    
    func setupContainers() {
        switch state {
        case .details:
            detailsContainer.isHidden = false
            commentsContainer.isHidden = true
            attachmentsContainer.isHidden = true
            break
        case .comments:
            detailsContainer.isHidden = true
            commentsContainer.isHidden = false
            attachmentsContainer.isHidden = true
            break
        case .attachments:
            detailsContainer.isHidden = true
            commentsContainer.isHidden = true
            attachmentsContainer.isHidden = false
            break
        }
    }
    
    @IBAction func segmentStateChanged(_ sender: UISegmentedControl) {
        state = IssueContainerState(rawValue: sender.selectedSegmentIndex)!
        setupContainers()
    }
    
    override func rightBarButtonPressed() {
        Utils.showActionSheet(items: actions, title: "Choose action", vc: self) { (index) in
            switch index {
            case 0:
                self.addCommentPressed()
                break
            case 1:
                self.logWorkPressed()
                break
            case 2:
                self.watchPressed()
                break
            default: break
            }
        }
    }
    
    func addCommentPressed() {
        let acvc = self.storyboard?.instantiateViewController(withIdentifier: "AddCommentVC") as! AddCommentVC
        acvc.issue = self.issue
        Utils.presentWithNavBar(acvc, animated: true, fromVC: self, block: nil)
    }

    
    func logWorkPressed() {
        let lwvc = self.storyboard?.instantiateViewController(withIdentifier: "LogWorkVC") as! LogWorkVC
        lwvc.issue = self.issue
        Utils.presentWithNavBar(lwvc, animated: true, fromVC: self, block: nil)
    }
    
    func watchPressed() {
            ToastView.show("Processing...")
            kMainModel.watchIssue(issueId: (issue?.issueId)!) { 
                ToastView.hide()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToIssueDetails" {
            let vc = segue.destination as? IssueDetailsVC
            vc?.issue = issue
        } else if segue.identifier == "segueToComments" {
            let vc = segue.destination as? CommentsVC
            vc?.issue = issue
        }
    }
}
