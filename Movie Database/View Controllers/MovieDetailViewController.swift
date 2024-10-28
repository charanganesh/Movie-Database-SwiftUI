//
//  MovieDetailViewController.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import UIKit

final class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movie: Movie?
    var viewModel: MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            viewModel = MovieDetailViewModel(movie: movie)
        } else {
            fatalError("Movie object is required to display details.")
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        viewModel.registerCells(for: tableView)
    }
}
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.sections[indexPath.section].items[indexPath.row].cellInstance(tableView, indexPath: indexPath)
        return cell
    }
}
