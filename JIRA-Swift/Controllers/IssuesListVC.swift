
class IssuesListVC: UITableViewController {
    
    var viewModel = IssuesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        addRightBarButton(image: nil, title: "Order By")
        navigationItem.title = viewModel.title
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getIssues()
    }
    
    override func rightBarButtonPressed() {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "OrderByVC") as! OrderByVC
        vc.viewModel._delegate = self
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func refresh() {
        viewModel.remove()
        getIssues()
    }
    
    func getIssues() {
        
        viewModel.getIssues(fBlock: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
            weakSelf.refreshControl?.endRefreshing()
            
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    //MARK:  TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView, section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  viewModel.heightForRow(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == LoadingCell.cellTag {
            self.perform(#selector(getIssues), with: nil, afterDelay: 0.3)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            let issue = viewModel.issueFor(index: indexPath.row)
            Presenter.pushIssueDetails(from: navigationController, issueKey: issue.key)
    }
}

extension IssuesListVC: OrderByDelegate {
    
    func selectedField(_ field: Field?) {
        viewModel.setOrder(field?.key)
        viewModel.remove()
        AKActivityView.add(to: view)
        getIssues()
    }

}
