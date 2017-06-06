
class IssuesVC: BaseTableVC {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getIssues()
    }
    
    func setupUI() {
        self.addLeftBarButton(image: nil, title: "Exit")
    }
    
    func getIssues() {
        LoadingView.add()
        MainModel().getIssues(startAt: 0, count: 10) { (array) in
            LoadingView.remove()
//            print(array!)
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "Cell number \(indexPath.row)"
        cell.detailTextLabel?.text = "detail text"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let idvc = self.storyboard?.instantiateViewController(withIdentifier: "IssueDetailsVC") as! IssueDetailsVC
        idvc.issueKey = NSNumber.init(value: indexPath.row)
        self.navigationController?.pushViewController(idvc, animated: true)
    }
}

