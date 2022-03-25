//
//  AuthViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    //MARK: - Properties
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants.Colors.systemTextColor, for: .normal)
        button.setTitle(ConstantTitles.Login.login, for: .normal)
        button.addTarget(self, action: #selector (loginButtonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        return button
    }()
    let urlString = Endpoints.Auth.authUrlString
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextStep(notification:)),
                                               name: Notification.Name(Constants.SecurityKeys.getCodeKey),
                                               object: nil)
        
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.addGradient()
    }
    
    
    //MARK: - Configure
    func configureButton() {
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.center.equalTo(self.view)
        }
    }
    
    
    // MARK: - Notifications
    @objc func nextStep(notification: NSNotification) {
        
        if let code = notification.userInfo?["code"] as? String {
            
            let accessCode = code.replacingOccurrences(of: "#_", with: "")
            
            AuthNetworking.shared.authCode = accessCode
            AuthNetworking.shared.getOauthToken(code: accessCode) { [weak self] (resp, error) in
                guard let self = self else { return }
                if resp?.accessToken != nil {
                    self.navigator.navigate(to: .userFeed)
                }
                
            }
        }
    }

    
    //MARK: - Actions
    @objc private func loginButtonTapped() {
        startLoader()
        showSafari()
    }
    
    func showSafari() {
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "") {
            self.navigator.navigate(to: .webView(url: url))
        }
        self.stopLoader()
    }
}
