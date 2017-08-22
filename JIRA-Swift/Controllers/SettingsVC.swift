//
//  SettingsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/7/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    @IBOutlet weak var avatarImage: ImageViewCache!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbVersionInfo: UILabel!

    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
    }
    
    func getCurrentUser() {
        AKActivityView.add(to: view)
        
        guard let username = UserDefaults.standard.value(forKey: "Username") else {
            AKActivityView.remove(animated: true)
            return
        }
        
        let name = username as! String
        viewModel.getUser(name: name, completition: { [weak self] (result) in
           
            switch result {
                
            case .success(_):
                self?.setupUI()
                AKActivityView.remove(animated: true)

            case .failed(let err):
                AKActivityView.remove(animated: true)
                self?.alert(title: "Error", message: err)

            }
        })
    }
    
    func setupUI() {
        avatarImage.roundCorners()
        if let user = viewModel.currentUser {
            avatarImage.loadImage(url: user.avatarUrl!, placeHolder: UIImage(named: "ic_no_avatar"))
            lbName.text = user.displayName
            lbEmail.text = user.emailAddress
        }
        lbVersionInfo.text = viewModel.appInfo
        
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        actionSheet(items: ["Sure"], title: "Do You want to Log Out?") { [weak self] (index) in
            if index == 0 {
                self?.logOutAction()
            }
        }

    }
    
    func logOutAction() {
        
        let loginViewModel = LoginViewModel()
        let login = loginViewModel.getSavedLogin()
        let pass = loginViewModel.getSavedPassword()

        ToastView.show("Logging Out...")
        
        viewModel.logOut(userName: login, password: pass, completition: { [weak self] (result) in
           
            switch result {
                
            case .success(_):
                ToastView.hide(fBlock: {
                    KeychainItemWrapper.resetKeychainItemAction() //remove saved login and pass
                    self?.dismiss(animated: true, completion: nil)
                })
                
            case .failed(let err):
                ToastView.errHide(fBlock: {
                    self?.alert(title: "Error", message: err)
                })
            }
        })
    }
}
