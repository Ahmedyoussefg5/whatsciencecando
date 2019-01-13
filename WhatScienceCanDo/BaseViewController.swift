//
//  BaseViewController.swift
//  CafeSupreme
//
//  Created by Ahmed on 8/22/17.
//  Copyright © 2017 RKAnjel. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!


    lazy var errorView = ConnectionErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = true
        self.constructConnectionErrorView()
        getData()
        
        if self.revealViewController() != nil {
            revealViewController().rightViewController = nil
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            menuButton?.action = #selector(SWRevealViewController.revealToggle(_:))
        }

    }
    
    func getData() {
        self.errorView.isHidden = true
        self.activityIndicator?.startAnimating()
    }
    
    func constructConnectionErrorView() {
        if !self.view.subviews.contains(errorView){
            errorView.frame = self.view.frame
            self.view.addSubview(errorView)
            self.errorView.tryAgainBtn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
