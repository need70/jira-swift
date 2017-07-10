//
//  TempoTeamsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class TempoTeamsVC: UITableViewController {

    var viewModel = TempoTeamsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getTeams()
    }
    
    func getTeams() {
        viewModel.getTempoTeams(fBlock: { [weak self] (array) in
            guard let weakSelf = self else { return }
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueTeamsToUsers", sender: viewModel.tempoTeams[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTeamsToUsers" {
            let team = sender as! TempoTeam
            let vc = segue.destination as! TempoUsersVC
            vc.viewModel = TempoUsersViewModel(tempoTeam: team)
        }
    }

}
