//
//  TempoTeamsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class TempoTeamsVC: UITableViewController {

    var teams: [TempoTeam] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getTeams()
    }
    
    func getTeams() {
        kMainModel.getTempoTeams(fBlock: { [weak self] (array) in
            guard let weakSelf = self else { return }
            weakSelf.teams += array as! [TempoTeam]
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
        return teams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row < teams.count {
            let team = teams[indexPath.row]
            cell.textLabel?.text = team.name
            cell.detailTextLabel?.text = team.lead
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let team = teams[indexPath.row]
        performSegue(withIdentifier: "segueTeamsToUsers", sender: team)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueTeamsToUsers" {
            let team = sender as! TempoTeam
            let vc = segue.destination as! TempoUsersVC
            vc.team = team
        }
    }

}
