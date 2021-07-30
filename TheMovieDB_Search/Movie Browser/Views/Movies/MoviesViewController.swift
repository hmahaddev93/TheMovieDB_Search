//
//  ViewController.swift
//  Movie Browser
//
//  Created by Khatib Mahad H. on 7/18/21.
//

import UIKit

final class MoviesViewController: UIViewController {

    private let viewModel: MovieViewModel = MovieViewModel()
    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()

    lazy var movieView = MovieView()

    override func loadView() {
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieView.tableView.dataSource = self
        movieView.tableView.delegate = self
        movieView.searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapBg(sender:)))
        movieView.addGestureRecognizer(tapGesture)
    }
    
    private func searchMovie(query: String) {
        showSpinner()
        viewModel.fetchMovies(query: query) {[unowned self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.update()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.display(error: error)
                }
            }
            
        }
    }
    
    private func update() {
        movieView.tableView.reloadData()
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        movieView.activityIndicatorView.startAnimating()
    }
    
    private func hideSpinner() {
        self.movieView.activityIndicatorView.stopAnimating()
    }
    
    private func dismissKeyboard() {
        self.movieView.searchBar.resignFirstResponder()
    }
    
    @objc func onTapBg(sender: Any) {
        dismissKeyboard()
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.replacingOccurrences(of: " ", with: "").isEmpty {
            searchMovie(query: query)
        }
        else {
            viewModel.movies.removeAll()
            self.update()
        }
        searchBar.resignFirstResponder()
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movieCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell {
            let movie = viewModel.movies[indexPath.row]
            movieCell.movie = movie
            return movieCell
        }
        return UITableViewCell()
    }
}

extension MoviesViewController: UITableViewDelegate {
}


