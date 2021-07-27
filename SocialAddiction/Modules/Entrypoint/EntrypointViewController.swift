//
//  EntrypointViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit
import SafariServices

class EntrypointViewController: BaseViewController {
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        checkAuth()
        
    }
    
    //MARK: - Configure
    func checkAuth() {
        if UserManager.shared.userID == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigator.navigate(to: .login(effectTime: 0.3))
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigator.navigate(to: .userFeed)
            })
        }
    }

}

