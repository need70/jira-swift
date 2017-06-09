
class ProjectsVC: BaseTableVC {
    
    var projects: [ProjectObj] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getProjects()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
    func getProjects() {
        tableView.separatorStyle = .none
        AKActivityView.add(to: view)
        kMainModel.getProjects() { (array) in
            print(array)
            self.projects = array as! [ProjectObj]
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            AKActivityView.remove(animated: true)
        }
    }

    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        if indexPath.row < projects.count {
            let item = projects[indexPath.row] as ProjectObj
            cell.project = item
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var iconImage: ImageViewCache!
    var project: ProjectObj?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    func setupUI() {
        
        if let project = project {
            lbTitle.text = project.name
            iconImage.loadImage(url: project.iconUrl, placeHolder: UIImage(named: "tab_project"))
        }
        
    }
}
