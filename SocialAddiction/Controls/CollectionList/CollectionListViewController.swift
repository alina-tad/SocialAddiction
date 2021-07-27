//
//  CollectionListViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit
import ReactiveSwift

class CollectionListViewController: BaseViewController {
    
    // MARK: - Handlers
    public var actionHandler: ((_ index: Int) -> Void)? = nil
    public var action: ((_ index: Int) -> Void)? = nil
    public var refreshActionHandler: (()-> ())? = nil
    public var paginationActionHandler: (()-> ())? = nil
    
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    private var refreshControl = UIRefreshControl()
    public var listDirector = CollectionListDirector()
    public var data: [CollectionListViewModel] = []
    
    var paginationActivate = MutableProperty<Bool?>(nil)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .never
        configureCollectionView()
        paginationScrollActivate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    //MARK: - Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height + 80)  && scrollView.contentOffset.y > 65 && refreshControl.isRefreshing == false {
            paginationActivate.value = true
        } else { paginationActivate.value = false }

    }
    
    
    //MARK: - Configure
    private func paginationScrollActivate() {
        paginationActivate
            .producer
            .startWithValues({ value in
                if value == true {
                    self.paginationActionHandler?()
                }
            })
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = listDirector
        listDirector.collectionView = collectionView
        
        listDirector.actionHandler = { index in
            self.action?(index)
        }
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.alwaysBounceVertical = true
        
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
    }
    
    @objc func refreshData() {
        self.refreshControl.beginRefreshing()
        refreshActionHandler?()
        self.refreshControl.endRefreshing()
     }
    
    public func addModels() {
        let oldOffset = self.listDirector.collectionView.contentOffset
        self.listDirector.prepare(self.data, self.collectionView)
        self.listDirector.collectionView.reloadData()
        self.listDirector.collectionView.layoutIfNeeded()
        self.listDirector.collectionView.contentOffset = oldOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?(indexPath.item)
    }

}


//MARK: - UICollectionViewDelegateFlowLayout
extension CollectionListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


//MARK: - Instance
extension CollectionListViewController {
    class func instance() -> CollectionListViewController {
        let storyboad = UIStoryboard(name: "Collection", bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: "CollectionListViewController") as! CollectionListViewController
        return controller
    }
}
