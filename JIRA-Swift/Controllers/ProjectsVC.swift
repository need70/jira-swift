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
            ToastView.errHide(fBlock: {
                weakSelf.alert(title: "Error", message: errString)
            })
        }
    }
    
    func refresh() {
        viewModel.projects.removeAll()
        getProjects()
    }

    //MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        if indexPath.row < viewModel.projects.count {
            let item = viewModel.projects[indexPath.row] as Project
            cell.project = item
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < viewModel.projects.count {
            let item = viewModel.projects[indexPath.row] as Project
            
            let jqlString = String(format: "project = '%@' ORDER BY created", item.key!)
            let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "IssuesListVC") as! IssuesListVC
            vc.jql = jqlString
            vc.categoryTitle = item.key
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - ProjectCell

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iconImage: ImageViewCache!
    
    var project: Project?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let project = project {
            lbTitle.text = project.name
            iconImage.loadImage(url: project.iconUrl!, placeHolder: UIImage(named: "tab_project"))
        }
    }
}
