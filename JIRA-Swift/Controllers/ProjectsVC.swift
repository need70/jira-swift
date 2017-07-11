//
//  ProjectsVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//


class ProjectsVC: UITableViewController {
    
    let viewModel = ProjectsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        AKActivityView.add(to: view)
        getProjects()
    }
        
    func getProjects() {
        viewModel.getProjects(fBlock: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            AKActivityView.remove(animated: true)
            weakSelf.refreshControl?.endRefreshing()
            
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    func refresh() {
        viewModel.remove()
        getProjects()
    }

    //MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = viewModel.item(for: indexPath.row) {
            let jqlString = String(format: "project = '%@'", item.key!)
            Presenter.pushIssues(from: navigationController, jql: jqlString, order: nil, title: item.key)
        }
    }
}
