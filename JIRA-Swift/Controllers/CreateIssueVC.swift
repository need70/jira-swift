//
//  CreateIssueVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/10/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit



class CreateIssueVC: UITableViewController {

    var viewModel = CreateIssueViewModel()
    
    @IBOutlet weak var lbProject: UILabel!
    @IBOutlet weak var projIcon: ImageViewCache!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var typeIcon: ImageViewCache!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbPriority: UILabel!
    @IBOutlet weak var priorityIcon: ImageViewCache!
    @IBOutlet weak var tfEpicName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLeftBarButton(image: nil, title: "Cancel")
        addRightBarButton(image: nil, title: "Send")
        
        tvSummary.layer.borderColor = kSystemSeparatorColor.cgColor
        tvSummary.layer.borderWidth = 1
        tvSummary.layer.cornerRadius = 5.0

        tvDescription.layer.borderColor = kSystemSeparatorColor.cgColor
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.cornerRadius = 5.0

        AKActivityView.add(to: view)
        getCreateMeta()
    }
    
    func getCreateMeta() {
        viewModel.getCreateMeta(completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                self?.setupUI()
                AKActivityView.remove(animated: true)
                
            case .failed(let err):
                AKActivityView.remove(animated: true)
                self?.alert(title: "Error", message: err)

            }
        })
    }

    override func leftBarButtonPressed() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func rightBarButtonPressed() {
        view.endEditing(true)

        viewModel.summary = tvSummary.text
        viewModel.description = tvDescription.text
        viewModel.epicName = tfEpicName.text
        
        guard viewModel.project != nil, viewModel.issueType != nil, viewModel.summary.characters.count > 0 else {
            alert(title: "Alert", message: "(Project, IssueType, Summary) must not be empty." )
            return
        }
        
        if viewModel.isEpic == true && tfEpicName.text == "" {
            alert(title: "Alert", message: "Epic name must not be empty." )
            return
        }
        createIssue()
    }
    
    func createIssue() {
        ToastView.show("Creating...")
        viewModel.createIssue(completition: { [weak self] (result) in
            
            switch result {
                
            case .success(let keyString):
                ToastView.hide(fBlock: {
                    let msg = String(format: "Issue %@ was succesfully created.", keyString as! String)
                    self?.alert(title: "Success", message: msg, block: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                })
                
            case .failed(let err):
                ToastView.errHide(fBlock: {
                    self?.alert(title: "Error", message: err)
                })
            }
        })
    }
    
    func setupUI() {
        
        lbPriority.text = viewModel.priorityString
        priorityIcon.loadImage(url: viewModel.priorityIconUrl)
        
        lbProject.text = viewModel.projectString
        projIcon.loadImage(url: viewModel.projectIconUrl)
        
        lbType.text = viewModel.issuetypeString
        typeIcon.loadImage(url: viewModel.issuetypeIconUrl)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                Presenter.pushProjectPicker(from: navigationController, delegate: self, items: viewModel.projects)
                break
                
            case 1:
                guard viewModel.project != nil else {
                    alert(title: "Alert", message: "Select the project first!")
                    return
                }
                Presenter.pushProjectPicker(from: navigationController, delegate: self, items: (viewModel.project?.issueTypes)!)
                break
            default: break
            }
            
        } else {
            
            switch indexPath.row {
            case 2:
                Presenter.pushMetaPicker(from: navigationController, delegate: self)
                break
            default: break
            }
        }
    }
}

extension CreateIssueVC: MetaPickerDelegate, ProjectPickerDelegate {
    
    func selectedPriority(item: IssuePriority?) {
        viewModel.priority = item
        setupUI()
    }
    
    func selectedItem(item: Any) {
        if item is Project {
            viewModel.project = item as? Project
            viewModel.issueType = nil
        } else if item is IssueType {
            viewModel.issueType = item as? IssueType
        }
        setupUI()
    }
}

