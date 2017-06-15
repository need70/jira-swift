//
//  BaseTableVC.swift
//  JIRA-Swift
//
//  Created by Andrey Kramar on 2/14/17.
//  Copyright © 2017 home. All rights reserved.
//

extension UIViewController {
    
func addLeftBarButton(image: String?, title: String?) {
    
    let item: UIBarButtonItem?
    if image == nil {
        item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(leftBarButtonPressed))
    } else {
        item = UIBarButtonItem(image: UIImage(named: image!), style: .plain, target: self, action: #selector(leftBarButtonPressed))
    }
    self.navigationItem.leftBarButtonItem = item
}

func leftBarButtonPressed() { }

func addRightBarButton(image: String?, title: String?) {
    
    let item: UIBarButtonItem?
    if image == nil {
        item = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonPressed))
    } else {
        item = UIBarButtonItem(image: UIImage(named: image!), style: .plain, target: self, action: #selector(rightBarButtonPressed))
    }
    self.navigationItem.rightBarButtonItem = item
}

func rightBarButtonPressed() { }


}
