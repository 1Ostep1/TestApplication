//
//  BaseViewController.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 27/7/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func loadView() {
        super.loadView()
        configureNavigationStyle()
    }
    
    func configureNavigationStyle(tintColor: UIColor = .black) {
        let backButtonImage = UIImage(named: "ic_left")
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtton
        self.navigationController?.view.tintColor = tintColor
        self.navigationController?.view.backgroundColor = .white

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController!.navigationBar.backIndicatorImage = backButtonImage
        self.navigationController!.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
}
