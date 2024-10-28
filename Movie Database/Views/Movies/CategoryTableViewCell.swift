//
//  CategoryTableViewCell.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indentationWidth = 20
        indentationLevel = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }

    @IBAction func cellTapped() {
        onTap?()
    }
}

final class CategoryCellViewModel: TableViewCellViewModelProtocol {
    typealias CellType = CategoryTableViewCell

    var categoryName: String
    var onTap: (() -> Void)?
    var indentationLevel: Int
    
    init(categoryName: String, indentationLevel: Int = 0) {
        self.categoryName = categoryName
        self.indentationLevel = indentationLevel
    }
    
    func configureCell(_ cell: CategoryTableViewCell) {
        cell.titleLabel.text = categoryName
        cell.onTap = onTap
        switch indentationLevel {
        case 0:
            cell.backgroundColor = UIColor.systemBackground
        case 1:
            cell.backgroundColor = UIColor.secondarySystemBackground
        default:
            cell.backgroundColor = UIColor.systemBackground
        }
    }
}
