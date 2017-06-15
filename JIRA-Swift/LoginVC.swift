//
//  LoginVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

class LoginVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfJiraUrl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
//        if DEVICE_IS_SIMULATOR {
            self.tfEmail.text = "andriy.kramar"
            self.tfPassword.text = "andmar33"
//        }
        self.tfJiraUrl.text = "https://onix-systems.atlassian.net"
    }

    @IBAction func loginAction(_ sender: Any) {
        checkForEmpty()
    }
    
    func checkForEmpty() {
        
        if let login = tfEmail.text, let pass = tfPassword.text, let url = tfJiraUrl.text {
            if login.characters.count > 0, pass.characters.count > 0, url.characters.count > 0 {
                
                //save url
                UserDefaults.standard.set(tfJiraUrl.text, forKey: "JiraUrl")
                UserDefaults.standard.synchronize()
                
                ToastView.show("Authing...")
                makeAuth(login: login, pass: pass, url: url)

            } else {
                let alert = UIAlertController(title: "Error", message: "Empty field!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func makeAuth(login: String, pass: String, url: String) {
        kMainModel.auth(userName: self.tfEmail.text!, password: self.tfPassword.text!) { (dict) in
            kMainModel.getCurrentUser() {
                ToastView.hide() {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarController") as! UITabBarController
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IssuesNavCon") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                }                
            }
        }
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

