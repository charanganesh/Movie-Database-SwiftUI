//
//  MovieDetailHeaderTableViewCell.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import UIKit
import SDWebImage

import UIKit

final class MovieDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    
    private var ratings: [(source: String, value: String)] = []

    // Closure to pass selected rating back
    var onRatingSelected: ((String?, String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingButton.addTarget(self, action: #selector(showRatingMenu), for: .touchUpInside)
    }

    func configure(with viewModel: MovieDetailHeaderCellViewModel) {
        movieTitleLabel.text = viewModel.title
        movieYearLabel.text = viewModel.year
        genreLabel.text = viewModel.genres
        movieLanguageLabel.text = viewModel.language
        self.ratings = viewModel.ratings

        if let initialRating = ratings.first {
            ratingButton.setTitle(initialRating.source, for: .normal)
            movieRatingLabel.text = "Rating: " + initialRating.value
        }

        if let url = viewModel.thumbnailURL {
            movieImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "movie-poster-placeholder"))
        }
    }

    @IBAction private func showRatingMenu() {
        let actions = ratings.map { rating in
            UIAction(title: rating.source) { [weak self] _ in
                self?.ratingButton.setTitle(rating.source, for: .normal)
                self?.movieRatingLabel.text = "Rating: " + rating.value
            }
        }

        let menu = UIMenu(title: "Select Rating Source", children: actions)
        ratingButton.menu = menu
        ratingButton.showsMenuAsPrimaryAction = true // Automatically shows the menu on tap
    }

}


final class MovieDetailHeaderCellViewModel: TableViewCellViewModelProtocol {

    typealias CellType = MovieDetailHeaderTableViewCell

    let title: String
    let year: String
    let ratings: [(source: String, value: String)]
    let thumbnailURL: URL?
    let genres: String
    let language: String
    var onRatingSelected: ((String?, String?) -> Void)?

    init(title: String, year: String, genres: String, language: String, thumbnailURL: URL?, ratings: [(source: String, value: String)]) {
        self.title = title
        self.year = year
        self.genres = genres
        self.language = language
        self.thumbnailURL = thumbnailURL
        self.ratings = ratings
    }

    func configureCell(_ cell: MovieDetailHeaderTableViewCell) {
        cell.configure(with: self)
    }
}



