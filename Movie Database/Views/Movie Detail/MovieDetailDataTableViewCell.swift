//
//  MovieDetailDataTableViewCell.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import UIKit

final class MovieDetailDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

final class MovieDetailDataCellViewModel: TableViewCellViewModelProtocol {
    typealias CellType = MovieDetailDataTableViewCell
    
    var title: String?
    var data: String?
    
    init(title: String?, data: String?) {
        self.title = title
        self.data = data
    }
    func configureCell(_ cell: MovieDetailDataTableViewCell) {
        cell.titleLabel.text = title
        cell.dataLabel.text = data
    }
}
