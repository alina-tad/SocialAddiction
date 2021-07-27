//
//  Navigator.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit
import SafariServices

class Navigator {
    
    // MARK: - Properties
    private weak var navigationController: UINavigationController?
    
    
    // MARK: - Types
    enum Destination {
        
        //  Auth
        case login(effectTime: Double)
        case userFeed
        
        //  Web
        case webView(url: URL)
        
        //Post
        case post(id: String)
        
    }
    
    
    // MARK: - Initialize
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    
    // MARK: - Public
    
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        
        switch destination {
        case .login(var effectTime):
            
            guard let window = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first else {
                return
            }
            
            let root = UINavigationController()
            root.viewControllers = [viewController]
            
            if #available(iOS 13.0, *) {
                effectTime = 0.0
            }
            
            UIView.transition(with: window,
                              duration: effectTime,
                              options: .transitionCrossDissolve,
                              animations: {
                                window.rootViewController = root
            })
            
            break
        case .userFeed:
            guard
                let window = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first,
                let root = UIStoryboard(name:"UserFeed",
                                        bundle:Bundle.main)
                    .instantiateViewController(withIdentifier: "NavigationMenuController") as? UINavigationController
                else { return }
            
            root.viewControllers = [viewController]
            
            if #available(iOS 13.0, *) {
                window.rootViewController = root
            } else {
                
                let transition = CATransition()
                transition.type = CATransitionType.fade
                
                UIView.transition(with: window,
                                  duration: 0.0,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    window.rootViewController = root
                })
            }
            
            break
        case .webView(_):
            let navController = UINavigationController(rootViewController: viewController)
            navigationController?.viewControllers.last?.present(navController, animated: true, completion: nil)
        default:
            navigationController?.pushViewController(viewController, animated: true)
            break
            
        }
    }
    
    // MARK: - Private

    fileprivate func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        
        // Auth
        case .login:
            let controller = LoginViewController()
            return controller
            
        case .userFeed:
            let controller = UserFeedViewController()
            return controller
            
            
        // WebView
        case .webView(let url):
            let controller = WebViewViewController()
            controller.url = url
            return controller
            
            
            //Post
        case .post(let id):
            let controller = PostDetailViewController()
            controller.id = id
            return controller
        }
        
    }
    
}
