//
//  ChangePasswordVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 7/25/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class ChangePasswordVC: UITableViewController {

    @IBOutlet weak var tfCurrentPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRightBarButton(image: nil, title: "Change")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfCurrentPassword.becomeFirstResponder()
    }
    
    override func rightBarButtonPressed() {
        print("change!")
    }
    
    @IBAction func switcherAction(_ sender: UISwitch) {
        setupUI()
    }
    
    func setupUI() {
        tfNewPassword.isSecureTextEntry = !switcher.isOn
        tableView.reloadData()
    }
    

}


class ChangePasswordViewModel {
    
    
    
    
}
