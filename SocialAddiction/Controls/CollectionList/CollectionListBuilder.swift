//
//  CollectionListBuilder.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit
import SnapKit

class CollectionListBuilder {
    
    // MARK: - Handlers
    public var actionHandler: ((_ index: Int) -> Void)? = nil
    public var refreshActionHandler: (()-> ())? = nil
    public var paginationActionHandler: (()-> ())? = nil
    
    // MARK: - Properties
    fileprivate var controller: CollectionListViewController!
    
    
    // MARK: - Init
    init() {
        self.build()
    }
    
    
    // MARK: - Configure
    fileprivate func build() {
        controller = CollectionListViewController.instance()
        
        controller.action = { [weak self] index in
            guard let self = self else { return }
            self.actionHandler?(index)
        }
        
        controller.refreshActionHandler = { [weak self] in
            guard let self = self else { return }
            self.refreshActionHandler?()
        }
        
        controller.paginationActionHandler = { [weak self] in
            guard let self = self else { return }
            self.paginationActionHandler?()
        }
    }
    
    public func updateModels(_ models: [CollectionListViewModel]) {
        if controller.collectionView != nil {
            controller.data = models
            controller.addModels()
        }
    }
    
    public func attach(_ view: UIView) {

        view.addSubview(controller.view)
        
        controller?.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.snp.removeConstraints()
        controller.view.snp.makeConstraints { target in
            target.top.equalTo(0)
            target.left.equalTo(0)
            target.right.equalTo(0)
            target.bottom.equalTo(0)
        }
        
        controller.collectionView.reloadData()
    }
    
    public func detach() {
        controller.view.removeFromSuperview()
    }
}
