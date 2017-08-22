
class IssuesListVC: UITableViewController {
    
    var viewModel = IssuesListViewModel(jql: nil, orderBy: nil, categoryTitle: nil)
    
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
        Presenter.presentOrderBy(from: self)
    }
    
    func refresh() {
        viewModel.remove()
        getIssues()
    }
    
    func getIssues() {
        viewModel.getIssues(completition: { [weak self] (result) in
        
            switch result {
                
            case .success(_):
                self?.tableView.reloadData()
                self?.tableView.separatorStyle = .singleLine
                
            case .failed(let err):
                self?.alert(title: "Error", message: err)

            }
            AKActivityView.remove(animated: true)
            self?.refreshControl?.endRefreshing()
        })
    }
    
    //MARK:  TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
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
