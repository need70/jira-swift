
protocol CreateIssueViewModelProtocol {
    
    var isEpic: Bool { get }
    var projectString: String? { get }
    var projectIconUrl: String? { get }
    var issuetypeString: String? { get }
    var issuetypeIconUrl: String? { get }
    var priorityString: String? { get }
    var priorityIconUrl: String? { get }
    func numberOfRows(_ section: Int) -> Int
    func getCreateMeta(completition: @escaping responseHandler)
    func createIssue(completition: @escaping responseHandler)
}

class CreateIssueViewModel: CreateIssueViewModelProtocol {
    
    var projects: [Project] = []
    
    var project: Project?
    var issueType: IssueType?
    var summary: String = ""
    var description: String?
    var priority: IssuePriority?
    var epicName: String?
    
    var isEpic: Bool {
        guard issueType?.name == "Epic" else {
            return false
        }
        return true
    }
    
    var projectString: String? {
        guard let key = project?.key else {
            return ""
        }
        return key
    }
    
    var projectIconUrl: String? {
        guard let url = project?.iconUrl else {
            return nil
        }
        return url
    }
    
    var issuetypeString: String? {
        guard let name = issueType?.name else {
            return ""
        }
        return name
    }
    
    var issuetypeIconUrl: String? {
        guard let url = issueType?.iconUrl else {
            return nil
        }
        return url
    }
    
    var priorityString: String? {
        guard let name = priority?.name else {
            return ""
        }
        return name
    }
    
    var priorityIconUrl: String? {
        guard let url = priority?.iconUrl else {
            return nil
        }
        return url
    }
    
    func numberOfRows(_ section: Int) -> Int {
        if section == 0 {
            return isEpic ? 3 : 2
        }
        return 3
    }
    
    func getCreateMeta(completition: @escaping responseHandler) {
        
        request.send(method: .get, url: Api.createmeta.path, params: nil, completition: { (result) in
            
            switch result {
                
            case .success(let responseObj):
                
                let dict = responseObj as! [String : Any]
                
                if let array = dict["projects"] as? [Any] {
                    
                    var objects: [Project] = []
                    
                    for index in 0..<array.count {
                        let dict = array[index] as! [String: Any]
                        let obj = Project(JSON: dict)!
                        objects.append(obj)
                    }
                    self.projects = objects
                    completition(.success(nil))
                }

            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
    
    private func constructBody() -> [String : Any] {
        
        var dict = [String : Any]()

        let projectDict = ["id" : project?.projectId]
        let issueTypeDict = ["id" : self.issueType?.typeId]
        
        dict["project"] = projectDict
        dict["issuetype"] = issueTypeDict
        dict["summary"] = summary
        
        //check for description
        if let desc = description {
            dict["description"] = desc
        }
        
        //check for priority
        if let priorityId = priority?.priorityId {
            let priorityDict = ["id" : priorityId]
            dict["priority"] = priorityDict
        }
        
        //check for epic name
        if isEpic && epicName != nil {
            dict["customfield_10008"] = epicName
        }
        return ["fields" : dict]
    }
    
    func createIssue(completition: @escaping responseHandler) {
        
        let params = constructBody()
        
        Request().send(method: .post, url: Api.issueCreate.path, params: params, completition: { (result) in
      
            switch result {
                
            case .success(let responseObj):
                
                let dict = responseObj as! [String : Any]
                
                if let key = dict["key"] as? String {
                    print(dict)
                    completition(.success(key))
                }
                
            case .failed(let err):
                completition(.failed(err))
            }
        })
    }
}
