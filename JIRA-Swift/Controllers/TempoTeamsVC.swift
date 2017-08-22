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
        viewModel.getTempoTeams(completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                self?.tableView.reloadData()
                self?.tableView.separatorStyle = .singleLine
                AKActivityView.remove(animated: true)

            case .failed(let err):
                AKActivityView.remove(animated: true)
                self?.alert(title: "Error", message: err)
                
            }
        })
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
