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

    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarButton(image: nil, title: "Log Out")
        getCurrentUser()
    }
    
    func getCurrentUser() {
        AKActivityView.add(to: view)
        
        guard let username = UserDefaults.standard.value(forKey: "Username") else {
            AKActivityView.remove(animated: true)
            return
        }
        
        let name = username as! String
        viewModel.getUser(name: name, fBlock: {
            self.setupUI()
            AKActivityView.remove(animated: true)
            
            }, eBlock: { [weak self] (errString) in
                guard let weakSelf = self else { return }
                AKActivityView.remove(animated: true)
                weakSelf.alert(title: "Error", message: errString)
        })
    }
    
    func setupUI() {
        avatarImage.roundCorners()
        if let user = viewModel.currentUser {
            avatarImage.loadImage(url: user.avatarUrl!, placeHolder: UIImage(named: "tab_issue"))
            lbName.text = user.displayName
            lbEmail.text = user.emailAddress
        }
    }
    
    override func rightBarButtonPressed() {
        Utils.showActionSheet(items: ["Sure"], title: "Do You want to Log Out?", vc: self) { [weak self] (index) in
            guard let weakSelf = self else { return }
            if index == 0 {
                weakSelf.logOutAction()
            }
        }
    }
    
    func logOutAction() {
        
        let loginViewModel = LoginViewModel()
        let login = loginViewModel.getSavedLogin()
        let pass = loginViewModel.getSavedPassword()

        ToastView.show("Logging Out...")
        
        viewModel.logOut(userName: login, password: pass, fBlock: { 
            ToastView.hide(fBlock: {
                KeychainItemWrapper.resetKeychainItemAction() //remove saved login and pass
                self.dismiss(animated: true, completion: nil)
            })

        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            ToastView.errHide(fBlock: { 
                weakSelf.alert(title: "Error", message: errString)
            })
        }
    }
}
