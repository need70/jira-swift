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
        navigationItem.leftBarButtonItem = item
    }
    
    func addRightBarButton(image: String?, title: String?) {
        
        let item: UIBarButtonItem?
        if image == nil {
            item = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonPressed))
        } else {
            item = UIBarButtonItem(image: UIImage(named: image!), style: .plain, target: self, action: #selector(rightBarButtonPressed))
        }
        navigationItem.rightBarButtonItem = item
    }
    
    func leftBarButtonPressed() { }
    
    func rightBarButtonPressed() { }
    
    func alert(title: String?, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
    
    func alert(title: String?, message: String?, block: @escaping () -> ()) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
            block()
        })
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
    
    func actionSheet(items: [String], title: String, block: @escaping (_ index: Int) -> ()) {
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for index in 0..<items.count {
            let action = UIAlertAction(title: items[index], style: .default, handler: { (action) in
                ac.dismiss(animated: true, completion: nil)
                block(index)
            })
            ac.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            ac.dismiss(animated: true, completion: nil)
        })
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }

}

