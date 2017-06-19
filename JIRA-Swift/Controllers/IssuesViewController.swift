
class IssuesViewController: UITableViewController {

    var viewModel = IssuesViewModel() 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AKActivityView.add(to: view)
        viewModel.completition = {
            self.tableView.reloadData()
            AKActivityView.remove(animated: true)
        }
    }
    
    func loadMore() {
        viewModel.getIssues()
    }
    
    //MARK:  TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pagingEnabled ? viewModel.issues.count + 1 : viewModel.issues.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == LoadingCell.cellTag {
            self.perform(#selector(loadMore), with: nil, afterDelay: 0.3)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(indexPath: indexPath, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.pushToDetails(navCon: self.navigationController, indexPath: indexPath)
    }
}

