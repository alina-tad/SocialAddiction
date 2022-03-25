//
//  WebViewViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    
    //MARK: - Properties
    fileprivate lazy var contentView = UIView()
    fileprivate lazy var webView = WKWebView()
    
    public var url: URL? = nil {
        didSet {
            configureContentView()
        }
    }

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    
    //MARK: - Configure
    fileprivate func configureContentView() {
        
        self.contentView = configureFilesViewer()
        self.contentView.backgroundColor = .systemBackground
        
        view.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.snp.makeConstraints { target in
            target.top.equalTo(60)
            target.left.equalTo(0)
            target.right.equalTo(0)
            target.bottom.equalTo(0)
        }
    }
    
    fileprivate func configureFilesViewer() -> UIView {
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.alpha = 1.0
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let _ = navigationAction.request.url?.path {
            if navigationAction.request.url?.absoluteString.contains("www.google.com/?code") == true {

                var components = URLComponents()
                components.scheme = navigationAction.request.url?.scheme
                components.host =  navigationAction.request.url?.host
                components.path =  navigationAction.request.url!.path

                if let code = navigationAction.request.url?.queryParameters?["code"] {
                    let parameter = ["code": code]
                    print("URL_code_parameter:  \(parameter)")
                    NotificationCenter.default.post(name: Notification.Name(Constants.SecurityKeys.getCodeKey), object: nil, userInfo: parameter)
                }
                self.dismiss(animated: true, completion: nil)
                decisionHandler(.cancel)
                
            }
            else if navigationAction.request.url?.absoluteString == "https://www.google.com/" {
                self.navigator.navigate(to: .login(effectTime: 0.3))
                decisionHandler(.cancel)
            }
            else {
                decisionHandler(.allow)
            }
        }
        
        else {
            decisionHandler(.allow)
        }
    }


}
