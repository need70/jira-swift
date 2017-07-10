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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButton(image: nil, title: "Cancel")
        addRightBarButton(image: nil, title: "Create")
        
        tvSummary.layer.borderColor = kSystemSeparatorColor.cgColor
        tvSummary.layer.borderWidth = 1
        tvSummary.layer.cornerRadius = 5.0

        tvDescription.layer.borderColor = kSystemSeparatorColor.cgColor
        tvDescription.layer.borderWidth = 1
        tvDescription.layer.cornerRadius = 5.0
    }

    override func leftBarButtonPressed() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func rightBarButtonPressed() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

/*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
