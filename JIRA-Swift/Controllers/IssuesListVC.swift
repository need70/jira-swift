
let ISSUES_PER_PAGE = 20

class IssuesListVC: UITableViewController, OrderByDelegate {
    
    var categoryTitle: String?
    var jql: String?
    var orderBy: String?
    
    var issues: [Issue] = []
    var pagingEnabled = false
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        addRightBarButton(image: nil, title: "Order By")
        navigationItem.title = categoryTitle
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getIssues()
    }
    
    override func rightBarButtonPressed() {
        let vc = kIssuesStoryboard.instantiateViewController(withIdentifier: "OrderByVC") as! OrderByVC
        vc._delegate = self
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func refresh() {
        issues.removeAll()
        getIssues()
    }
    
    func getIssues() {
        
        if isLoading { return }
        pagingEnabled = true
        isLoading = true
        
        var jqlString = ""
        
        if let jql = jql {
            jqlString = jql
        }
        
        if let order = orderBy {
            let orderStr = " order by " + order
            jqlString +=  orderStr
        }
        
        print("JQL string = \(jqlString)")
        
        kMainModel.getIssues(jql: jqlString, startAt: issues.count, count: ISSUES_PER_PAGE, fBlock: { [weak self] (array) in
            guard let weakSelf = self else { return }
            weakSelf.pagingEnabled = (array.count < ISSUES_PER_PAGE) ? false : true
            weakSelf.issues += array as! [Issue]
            weakSelf.tableView.reloadData()
            weakSelf.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
            weakSelf.refreshControl?.endRefreshing()
            weakSelf.isLoading = false
            
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            AKActivityView.remove(animated: true)
            weakSelf.alert(title: "Error", message: errString)
        }
    }
    
    //MARK: OrderBy delegate
    
    func selectedField(field: Field) {
        print("selected field = \(field.name ?? "")")
        orderBy = field.key
        
        issues.removeAll()
        AKActivityView.add(to: view)
        getIssues()
    }
    
    //MARK:  TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if issues.count == 0 {
            return 1
        }
        return pagingEnabled ? issues.count + 1 : issues.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if issues.count == 0 {
            return 100
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == LoadingCell.cellTag {
            self.perform(#selector(getIssues), with: nil, afterDelay: 0.3)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if issues.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataCell")!
            return cell
        }
        
        if indexPath.row >= issues.count {
            return LoadingCell.instance()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueCell
        
        if indexPath.row < issues.count {
            let issue = issues[indexPath.row]
            cell.issue = issue
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < issues.count {
            let issue = issues[indexPath.row]
            Router.pushIssueDetails(from: navigationController, issueKey: issue.key)
        }
    }
}

//MARK: - IssueCell

class IssueCell: UITableViewCell {
    
    @IBOutlet weak var lbKey: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var svgView: SVGImageView!
    @IBOutlet weak var issueIcon: ImageViewCache!
    
    var issue: Issue?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        if let issue = issue {
            lbKey.text = issue.key
            lbSummary.text = issue.summary
            svgView.loadUrl((issue.type?.iconUrl)!)
            issueIcon.isHidden = true
        }
    }
}


