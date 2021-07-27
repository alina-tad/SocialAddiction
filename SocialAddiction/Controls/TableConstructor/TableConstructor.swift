//
//  TableConstructor.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 26.07.2021.
//

import Foundation
import UIKit

class TableConstructor {
    
    class func createForm(form: TableConstructorProtocol, tableView: UITableView) -> [UITableViewCell] {
        
        var cells: [UITableViewCell] = []
        
        for form in form.cellTypes {
            
            var cell: UITableViewCell? = nil
            
            switch form {
            case .imageCell(let model, let postType, let tag):
                cell = createImageCell(model, postType, tag, tableView)
            case .videoCell(let model, let postType, let tag):
                cell = createImageCell(model, postType, tag, tableView) // There must be a custom cell for Video type content
            case .carouselCell(let model, let postType, let tag):
                cell = createImageCell(model, postType, tag, tableView) // There must be a custom cell for Carousel type content
            }
            
            if let cell = cell {
                cells.append(cell)
            }
        }
        return cells
        
    }
    
    class func createImageCell(_ model: UserMediaModel,_ postType: MediaTypes,_ tag: Int, _ tableView: UITableView) -> UITableViewCell {
        let cell = PostDetailTableViewCell.createForTableView(tableView) as! PostDetailTableViewCell
        cell.configure(model: model, postType: postType)
        cell.tag = tag
        return cell
    }
}
