//
//  PostDetailViewController.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit

class PostDetailViewController: BaseViewController {
    
    //MARK: - Constants
    private let manager = UserFeedManager.shared
    
    var preview: PreviewPostDetail? {
        didSet {
            if let preview = preview {
                self.configureCells(form: preview)
            }
        }
    }
    
    //MARK: - Properties
    private var tableView: UITableView!
    private var tableCells: [UITableViewCell] = []

    public var id: String? {
        didSet {
            if let id = id {
                fetchDetailMedia(id)
            }
        }
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    

    //MARK: - Configure
    
    private func configureCells(form: TableConstructorProtocol) {
        tableCells = TableConstructor.createForm(form: form, tableView: self.tableView)
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (target) in
            target.left.equalTo(0)
            target.right.equalTo(0)
            target.top.equalTo(0)
            target.bottom.equalTo(0)
        }
    }
    
    
    //MARK: - Networking
    private func fetchDetailMedia(_ id: String) {
        startLoader()
        manager.fetchDetailMedia(id: id) { [weak self] (resp, error) in
            guard let self = self else { return }
            
            self.stopLoader()
            
            if let error = error {
                self.showError("\(ConstantTitles.UserFeed.faildToLoadMedia) \(error.localizedDescription)")
            }

            self.preview = PreviewPostDetail(resp)
            
            DispatchQueue.main.async {
                self.stopLoader()
            }
        }
        
    }

}


//MARK: - UITableViewDataSource
extension PostDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableCells[indexPath.row]
        return cell
    }

}
