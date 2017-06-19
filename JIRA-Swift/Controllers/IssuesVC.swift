
let ISSUES_PER_PAGE = 20
let arraySortBy = ["Viewed", "Assigned To Me", "Reported By Me", "Watching"]

enum IssuesState: Int {
    case viewed, assigned, reported, watching
}

class IssuesVC: UITableViewController {
    
    @IBOutlet var btnFilter: UIButton!
    var issues: [Issue] = []
    var pagingEnabled = false
    var isLoading = false
    var currentState: IssuesState = .viewed

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        AKActivityView.add(to: view)
        setupFilter()
    }
    
    func refresh() {
        issues.removeAll()
        getIssues()
    }
    
    func getIssues() {
        
        if isLoading { return }
        pagingEnabled = true
        isLoading = true
        
        let jql = jqlBy(currentState)
        
        kMainModel.getIssues(jql: jql, startAt: issues.count, count: ISSUES_PER_PAGE) { (array) in
            self.pagingEnabled = (array.count < ISSUES_PER_PAGE) ? false : true
            self.issues += array as! [Issue]
            self.tableView.reloadData()
            AKActivityView.remove(animated: true)
            self.refreshControl?.endRefreshing()
            self.isLoading = false
        }
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        Utils.showActionSheet(items: arraySortBy, title: "Sort by", vc: self) { (index) in
            print("filter index = \(index)")
            self.currentState = IssuesState(rawValue: index)!
            self.setupFilter()
        }
    }
    
    func setupFilter() {
        let title = arraySortBy[currentState.rawValue] + " \u{25BE}"
        btnFilter.setTitle(title, for: .normal)
        issues.removeAll()
        AKActivityView.add(to: view)
        getIssues()
    }
    
    func jqlBy(_ state: IssuesState) -> String {
        
        switch state {
        case .assigned: return "assignee in (currentUser())"
        case .reported: return "reporter in (currentUser())"
        case .watching: return "watcher in (currentUser())"
        case .viewed: return "project = 'EST' ORDER BY created"
        }
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
        let sb = UIStoryboard(name: "Issues", bundle: nil)
        let idvc = sb.instantiateViewController(withIdentifier: "IssueDetailsVC") as! IssueDetailsVC

        if indexPath.row < issues.count {
            let issue = issues[indexPath.row]
            idvc.issueKey = issue.key
        }
        self.navigationController?.pushViewController(idvc, animated: true)
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
//            issueIcon.loadImage(url: (issue.type?.iconUrl)!)
        }
    }
}

class SVGImageView: UIWebView {
    
    public func loadUrl(_ urlString: String) {
        self.backgroundColor = .clear
        self.isOpaque = false
        self.scrollView.isScrollEnabled = false
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        self.loadRequest(request)
    }
}
