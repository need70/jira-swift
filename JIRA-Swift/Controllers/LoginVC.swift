//
//  LoginVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

class LoginVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfLogin: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfJiraUrl: UITextField!
    @IBOutlet weak var switcher: UISwitch!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tryAutoLogin()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tfLogin.text = ""
        tfPassword.text = ""
    }

    @IBAction func loginAction(_ sender: Any) {
        view.endEditing(true)
        validate()
    }
    
    func validate() {
        
        if let login = tfLogin.text, let pass = tfPassword.text, let url = tfJiraUrl.text {
            if login.characters.count > 0, pass.characters.count > 0, url.characters.count > 0 {
                
                viewModel.saveJiraUrl(url: url) //save jira url
                
                ToastView.show("Logging In...")
                auth(login: login, pass: pass, url: url)
            } else {
                alert(title: "Alert", message: "Please, fill all fields!")
            }
        }
    }
    
    func auth(login: String, pass: String, url: String) {
        
        viewModel.logIn(userName: login, password: pass, fBlock: { [weak self] (dict) in
            guard let weakSelf = self else { return }
            
            if weakSelf.switcher.isOn {
                weakSelf.viewModel.saveLogin(login: login)
                weakSelf.viewModel.savePassword(pass: pass)
            }
            weakSelf.getCurrentUser()

        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            ToastView.errHide() {
                weakSelf.alert(title: "Error", message: errString)
            }
        }
    }
    
    func getCurrentUser() {
        viewModel.getCurrentUser(fBlock: {
            ToastView.hide() {
                self.performSegue(withIdentifier: "segueToTabbarController", sender: self)
            }
        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            ToastView.errHide() {
                weakSelf.alert(title: "Error", message: errString)
            }
        }
    }
    
    func tryAutoLogin() {
        
        tfJiraUrl.text = viewModel.baseURL
        
        if viewModel.shouldAutoLogin() {
            let login = viewModel.getSavedLogin()
            let pass = viewModel.getSavedPassword()
            let url = viewModel.baseURL
            
            tfLogin.text = login
            tfPassword.text = pass
            tfJiraUrl.text = url
            
            ToastView.show("Logging In...")
            auth(login: login, pass: pass, url: url)
        }
    }
    
    //MARK: tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    //MARK: textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
