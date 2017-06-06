//
//  BaseTableVC.swift
//  SomeSwiftApp
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BaseTableVC: UITableViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func addLeftBarButton(image: String?, title: String?) {
        
        let item: UIBarButtonItem?
        if image == nil {
            item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(leftBarButtonPressed))
        } else {
            item = UIBarButtonItem(image: UIImage(named: image!), style: .plain, target: self, action: #selector(leftBarButtonPressed))
        }
        self.navigationItem.leftBarButtonItem = item
    }

    func leftBarButtonPressed() {}
}
