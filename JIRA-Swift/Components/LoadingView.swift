//
//  AKLoadingView.swift
//  Created by Andriy Kramar on 2/21/17.
//

import UIKit

let loadingViewTag = 1860
let loadingViewAnimationDuration = 0.35
let bgColor: UIColor = .white
let circleIndicatorSize = 38.0
let useCircleIndicator = true

class LoadingView: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = bgColor
        self.tag = loadingViewTag
        
        if useCircleIndicator {
            let circleIndicator = CircleIndicatorView(frame: CGRect(x: 0, y: 0, width: circleIndicatorSize, height: circleIndicatorSize))
            circleIndicator.center = self.center
            self.addSubview(circleIndicator)
        } else {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.center = self.center
            self.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func add() {
        let topVC = LoadingView.topVC()
        let addToView = topVC.view!
        if (addToView.viewWithTag(loadingViewTag) != nil) { return }
        
        let view: LoadingView = LoadingView(frame: addToView.frame)
        view.alpha = 0
        addToView.addSubview(view)
        UIView.animate(withDuration: loadingViewAnimationDuration) {
            view.alpha = 1
        }
    }
    
    class func addToView(_ addToView: UIView) {
        if (addToView.viewWithTag(loadingViewTag) != nil) { return }
        let view: LoadingView = LoadingView(frame: addToView.frame)
        view.alpha = 0
        addToView.addSubview(view)

        UIView.animate(withDuration: loadingViewAnimationDuration) {
            view.alpha = 1
        }
    }
    
    class func remove() {
        let topVC = LoadingView.topVC()
        let addToView = topVC.view!
        let view = addToView.viewWithTag(loadingViewTag)
        
        if (view == nil) { return }
        
        UIView.animate(withDuration: loadingViewAnimationDuration, animations: {
            view?.alpha = 0
        }) { (finished) in
            view?.removeFromSuperview()
        }
    }
    
    //MARK: - Utils
    
    private class func topVC() -> UIViewController {
        if let window = UIApplication.shared.keyWindow {
            var alertVC : UIViewController = window.rootViewController!
            var done = false
            while (!done) {
                if let tabbar = alertVC as? UITabBarController {
                    if (tabbar.selectedIndex < tabbar.viewControllers!.count) {
                        alertVC = tabbar.viewControllers![tabbar.selectedIndex]
                    }
                } else if let navBar = alertVC as? UINavigationController {
                    alertVC = navBar.viewControllers.last!
                } else if (alertVC.presentedViewController != nil) {
                    alertVC = alertVC.presentedViewController!
                } else {
                    done = true
                }
            }
            return alertVC
        }
        return UIViewController()
    }
}
