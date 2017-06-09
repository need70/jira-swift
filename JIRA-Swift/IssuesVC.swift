
class IssuesVC: BaseTableVC {
    
    var issues: [IssueObj] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        getIssues()
    }
    
    func setupUI() {
        self.addLeftBarButton(image: nil, title: "Exit")
    }
    
    func getIssues() {
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        kMainModel.getIssues(startAt: 0, count: 20) { (array) in
            self.issues = array as! [IssueObj]
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
            AKActivityView.remove(animated: true)
        }
    }
    
    override func leftBarButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

class IssueCell: UITableViewCell {
    
    @IBOutlet weak var lbKey: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var svgView: SVGImageView!
    var issue: IssueObj?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        if let issue = issue {
            lbKey.text = issue.key
            lbSummary.text = issue.summary
            svgView.loadUrl((issue.type?.iconUrl)!)
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
