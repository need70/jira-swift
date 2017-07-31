//
//  TempoTeamsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class TempoUsersVC: UITableViewController {

    var viewModel = TempoUsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getUsers()
    }
    
    func getUsers() {
        viewModel.getTempoUsers(sBlock: { [weak self] (array) in
            self?.tableView.reloadData()
            self?.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView,indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueUsersToWorklog", sender: viewModel.tempoUsers[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueUsersToWorklog" {
            let user = sender as! TempoUser
            let vc = segue.destination as! WorklogsVC
            vc.viewModel = WorklogsViewModel(tempoUser: user)
        }
    }
}

//MARK: - TempoUsersCell

class TempoUsersCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var iconImage: ImageViewCache!
    @IBOutlet weak var lbAvailability: UILabel!
    
    var user: TempoUser?
    
    func customInit() {
        iconImage.roundCorners()
        if let user = user {
            lbTitle.text = user.member?.displayName
            lbSubtitle.text = user.membership?.role
            if let availability = user.membership?.availability {
                lbAvailability.text = availability + "%"
            }
            iconImage.loadImage(url: user.member?.avatar!, placeHolder: UIImage(named: "ic_no_avatar"))
            
        }
    }
}
