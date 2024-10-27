//
//  ViewController.swift
//  Movie Database
//
//  Created by Charan Ganesh on 26/10/24.
//

import UIKit

final class MovieDatabaseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = MovieDatabaseViewModel(movieService: MovieService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movie Database"

        // table view methods
        tableView.register(cells: viewModel.registerableCells)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureSearchBar()
        configureViewModel()
    }
    
    private func configureSearchBar() {
        // search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies by title, genre, actor, director"
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureViewModel() {
        viewModel.fetchMovies()
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onTapMovie = { [weak self] movie in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
                vc.movie = movie
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension MovieDatabaseViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        return cell;
    }
}

extension MovieDatabaseViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterMovies(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch()
    }
}
