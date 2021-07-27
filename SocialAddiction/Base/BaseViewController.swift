//
//  BaseViewControllerViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    lazy var navigator = Navigator(navigationController: navigationController)
    var loaderView: UIActivityIndicatorView = {
        $0.style = .medium
        $0.isUserInteractionEnabled = false
        $0.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin]
        $0.transform = Constants.ProgressIndicator.transform
        $0.color = .gray
        return $0
    }(UIActivityIndicatorView.init(frame: .zero))
    
    var errorView: UILabel = {
        $0.textColor = Constants.Colors.systemTextColor
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
        $0.numberOfLines = 0
        return $0
    }(UILabel.init(frame: .zero))
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

    //MARK: - Configure
    func startLoader() {
        stopLoader()
        
        self.view.addSubview(loaderView)
        self.view.bringSubviewToFront(loaderView)
        
        loaderView.startAnimating()
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.snp.makeConstraints { target in
            target.width.equalTo(Constants.ProgressIndicator.size)
            target.height.equalTo(Constants.ProgressIndicator.size)
            target.center.equalTo(self.view)
        }
    }
    
    func stopLoader() {
        loaderView.stopAnimating()
        self.view.willRemoveSubview(loaderView)
    }
    
    func addRightNavItemText(_ title: String) {
        let item = UIButton()
        item.titleLabel?.font = UIFont(name: "System", size: 17)
        item.setTitle(title, for: .normal)
        // FIXME: Add Dark Mode Supporting
        item.setTitleColor(Constants.Colors.systemTextColor, for: .normal)
        item.addTarget(self, action: #selector(rightItemAction(_:)), for: .touchUpInside)
        item.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: item)
    }
    
    
    // MARK: - Error
    
    func showError(_ text: String) {
        stopLoader()
        
        errorView.text = text
        self.errorView.isHidden = false
        
        self.view.addSubview(errorView)
    
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.snp.makeConstraints { target in
            target.left.equalTo(16)
            target.right.equalTo(-16)
            target.center.equalTo(self.view)
        }
    }
    
    func hideError() {
        self.errorView.isHidden = true
        self.errorView.removeFromSuperview()
        self.view.willRemoveSubview(self.errorView)
    }

    
    //MARK: - Actions
    @objc func rightItemAction(_ sender: Any) {}
}
