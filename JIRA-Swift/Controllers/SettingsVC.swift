//
//  SettingsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/7/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    @IBOutlet weak var avatarImage: ImageViewCache!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButton(image: nil, title: "Log Out")
        getCurrentUser()
    }

    func getCurrentUser() {
        AKActivityView.add(to: view)
        if let name = kMainModel.currentUser?.name {
            kMainModel.getUser(name: name) { (obj) in
                kMainModel.currentUser = obj as? User
                self.setupUI()
                AKActivityView.remove(animated: true)
            }
        }
    }
    
    func setupUI() {
        avatarImage.roundCorners()
        
        if let user = kMainModel.currentUser {
            avatarImage.loadImage(url: user.avatarUrl!, placeHolder: UIImage(named: "tab_issue"))
            lbName.text = user.displayName
            lbEmail.text = user.emailAddress
        }
    }
    
    override func rightBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


}
