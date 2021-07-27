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
    private let manager = UserFeedManager.shared
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
        fetchUserMedia()
        configureListController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    //MARK: - Configure
    func configureListController() {
        
        let contentView = UIView()
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.removeConstraints()
        contentView.snp.makeConstraints { target in
            target.top.left.right.bottom.equalTo(0)
        }
        
        listController.attach(contentView)
        
        listController.actionHandler = { [weak self] (index) in
            guard let self = self else { return }
            self.navigator.navigate(to: .post(id: self.userMedia[index].id))
        }
        
        listController.refreshActionHandler = {
            self.resultsMedia = nil
            self.userMedia.removeAll()
            self.fetchUserMediaPortion(type: .before, code: self.resultsMedia?.paging?.cursors?.before ?? "")
        }
        
        listController.paginationActionHandler = {
            if !self.isLoading {
                if self.userMedia.count != self.userData?.mediaCount {
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

    }
    
    private func fetchUserMedia() {
        startLoader()
        isLoading = true
        manager.fetchUserMedia() { [weak self] (resp, error) in
            guard let self = self else { return }
            
            self.isLoading = false

            if let error = error {
                self.showError("\(ConstantTitles.UserFeed.faildToLoadMedia) \(error.localizedDescription)")
                
                /*
                 if the error is related to the expiration of the token's validity period, then send a request for the token:  AuthNetworking.shared.getOauthToken(code: accessCode) {}.
                 And call this method again
                 */
                
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
        startLoader()
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
        authNetworkingManager.removeUserData()
        navigator.navigate(to: .webView(url: URL(string: Endpoints.AuthParams.redirectUri) ?? URL(fileURLWithPath: "")))
    }

}
