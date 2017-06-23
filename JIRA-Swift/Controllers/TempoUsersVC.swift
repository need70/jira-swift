//
//  TempoTeamsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class TempoUsersVC: UITableViewController {

    var team: TempoTeam?
    var users: [TempoUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getUsers()
    }
    
    func getUsers() {
        
        guard let teamId = team?.teamId else { return }
        kMainModel.getTempoUsers(teamId: teamId, fBlock: { [weak self] (array) in
            guard let weakSelf = self else { return }
            weakSelf.users += array as! [TempoUser]
            weakSelf.tableView.reloadData()
            weakSelf.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TempoUsersCell", for: indexPath) as! TempoUsersCell

        if indexPath.row < users.count {
            
            let user = users[indexPath.row]
            cell.user = user
            cell.customInit()
            
        }
        return cell
    }

}

//MARK: - TempoUsersCell

class TempoUsersCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var iconImage: ImageViewCache!
    
    var user: TempoUser?
    
    func customInit() {
        iconImage.roundCorners()
        if let user = user {
            lbTitle.text = user.member?.displayName
            lbSubtitle.text = user.membership?.role
            iconImage.loadImage(url: user.member?.avatar!, placeHolder: UIImage(named: "ic_no_avatar"))
            
        }
    }
}
