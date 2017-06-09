
let ISSUES_PER_PAGE = 20

class IssuesVC: BaseTableVC {
    
    var issues: [Issue] = []
    
    var pagingEnabled = false
    var isLoading = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        
        AKActivityView.add(to: view)
        getIssues()
    }
    
    func setupUI() {
        self.addLeftBarButton(image: nil, title: "Exit")
    }
    
    func getIssues() {
        
        if isLoading { return }
        
        pagingEnabled = true
        isLoading = true
        
        kMainModel.getIssues(startAt: issues.count, count: ISSUES_PER_PAGE) { (array) in
            
            self.pagingEnabled = (array.count < ISSUES_PER_PAGE) ? false : true
            
            self.issues.append(contentsOf: array as! [Issue])
            self.tableView.reloadData()
            AKActivityView.remove(animated: true)
            self.isLoading = false
        }
    }
    
    func loadNext() {
        getIssues()
    }
    
    override func leftBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:  TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pagingEnabled ? issues.count + 1 : issues.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.tag == LoadingCell.cellTag {
            self.perform(#selector(loadNext), with: nil, afterDelay: 0.5)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        let idvc = self.storyboard?.instantiateViewController(withIdentifier: "IssueDetailsVC") as! IssueDetailsVC
        if indexPath.row < issues.count {
            idvc.issue = issues[indexPath.row]
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
