//
//  UserFeedViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 22.07.2021.
//

import UIKit
import SnapKit

class UserFeedViewController: BaseViewController {
    
    //MARK: - Constants
    let listController = CollectionListBuilder()
    private let authNetworkingManager = AuthNetworking.shared
    private let manager = UserFeedManager()
    private let mediaTypes = MediaTypes()
    
    
    //MARK: - Properties
    private var userData: UserModel?
    private var userMedia: [UserMediaModel] = []
    private var resultsMedia: ResultMediaModel? {
        didSet {
            if let resultsMedia = resultsMedia {
                userMedia.append(contentsOf: resultsMedia.data ?? [])
            }
        }
    }
    
    private var isLoading = false
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        fetchData()
        configureListController()
    }

    //MARK: - Configure
    func configureListController() {

        listController.attach(self.view)
        
        listController.actionHandler = { [weak self] (index) in
            guard let self = self else { return }
            self.navigator.navigate(to: .post(id: self.userMedia[index].id))
        }
        
        listController.refreshActionHandler = { [weak self] in
            guard let self = self else { return }
            self.resultsMedia = nil
            self.userMedia.removeAll()
            self.listController.updateModels([])
            self.fetchUserMediaPortion(type: .before, code: self.resultsMedia?.paging?.cursors?.before ?? "")
        }
        
        listController.paginationActionHandler = { [weak self] in
            guard let self = self else { return }
            if !self.isLoading {
                if self.userMedia.count != self.userData?.mediaCount {
                    self.startLoader()
                    self.fetchUserMediaPortion(type: .after, code: self.resultsMedia?.paging?.cursors?.after ?? "")
                }
            }
        }
    }
    
    private func configureModels() {
        let models: [CollectionListViewModel] = userMedia.map({ CollectionListViewModel(FeedCollectionCellModel(photoUrlString: $0.mediaUrl , mediaTypes.type(typeCode: $0.mediaType ))) })
        listController.updateModels(models)
        
        if models.isEmpty {
            showError("ErrorEmptyData")
        }
    }
    
    private func configureNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.bottom
        addRightNavItemText("Logout")
        addLeftNavItemText("Clean cache")
    }
    
    
    //MARK: - Networking
    private func fetchData() {
        
        manager.fetchUser() { [weak self] (resp, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("fetch_user_error: \(error.string)")
            }
            self.userData = resp
            
            DispatchQueue.main.async {
                self.title = resp.username
            }
            
        }
        
        fetchUserMedia()
    }
    
    private func fetchUserMedia() {
        startLoader()
        isLoading = true
        manager.fetchUserMedia() { [weak self] (resp, error) in
            guard let self = self else { return }
            
            self.isLoading = false

            if let error = error {
                switch error {
                case .validationTokenError: self.logout()
                default: self.showError("\(ConstantTitles.UserFeed.failedToLoadMedia) \(error.string)")
                }
            }

            self.resultsMedia = resp
            if resp.data?.isEmpty == false {
                self.configureModels()
            }

            DispatchQueue.main.async {
                self.stopLoader()
            }
        }
    }
    
    private func fetchUserMediaPortion(type: PagingTypes, code: String) {
        isLoading = true
        manager.fetchUserMediaNextPortion(type: type, code: code) { [weak self] (resp, error)in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                print("fetch_UserMedia_error: \(error.string)")
            }
            
            self.resultsMedia = resp
            self.configureModels()
            
            DispatchQueue.main.async { 
                self.stopLoader()
            }
        }
    }
    
    //MARK: - Actions
    
    override func rightItemAction(_ sender: Any) {
        logout()
    }
    
    override func leftItemAction(_ sender: Any) {
        KFManager.cleanCache()
    }
    
    private func logout() {
        authNetworkingManager.removeUserData()
        navigator.navigate(to: .webView(url: URL(string: Endpoints.AuthParams.redirectUri) ?? URL(fileURLWithPath: "")))
    }

}
