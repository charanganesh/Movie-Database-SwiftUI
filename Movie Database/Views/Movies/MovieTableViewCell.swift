//
//  MovieTableViewCell.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import UIKit
import SDWebImage

final class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieThumbnail: UIImageView!
    
    var onTap: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func cellTapped() {
        onTap?()
    }
    
}

final class MovieCellViewModel: TableViewCellViewModelProtocol {
    
    typealias CellType = MovieTableViewCell
    
    let title: String
    let year: String
    let language: String
    let thumbnailURL: URL?
    var onTap: (() -> Void)?
    var indentationLevel: Int
    
    init(title: String, year: String, language: String, thumbnailURL: URL?, indentationLevel: Int = 0) {
        self.title = title
        self.year = year
        self.language = language
        self.thumbnailURL = thumbnailURL
        self.indentationLevel = indentationLevel
    }
    
    func configureCell(_ cell: MovieTableViewCell) {
        cell.movieTitle.text = title
        cell.movieYear.text = year
        cell.movieLanguage.text = language
        cell.onTap = onTap
        
        if let url = thumbnailURL {
            cell.movieThumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "movie-poster-placeholder"))
        }
        
        switch indentationLevel {
        case 0:
            cell.backgroundColor = UIColor.systemBackground
        case 1:
            cell.backgroundColor = UIColor.secondarySystemBackground
        case 2:
            cell.backgroundColor = UIColor.quaternarySystemFill
        default:
            cell.backgroundColor = UIColor.systemBackground
        }
    }
}
