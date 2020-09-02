//
//  SearchViewController.swift
//  TheMovie
//
//  Created by Dang Quoc Huy on 8/26/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionViewSearchResults: UICollectionView!
    @IBOutlet weak var buttonSearchMovie: UIButton!
    @IBOutlet weak var buttonSearchPeople: UIButton!
    
    private var movieSearchResults:[Movie] = []
    private var peopleSearchResults:[People] = []
    private var movieService:MovieServiceType = MovieService()
    private var searchType:SearchType = .movie
    
    // MARK: View life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewSearchResults.reloadData()
    }
    
    // MARK: Set up view
    func configureView() {
        searchBar.delegate = self
        highlightMovieButton()
        collectionViewSearchResults.dataSource = self
        collectionViewSearchResults.delegate = self
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionViewSearchResults.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    func searchMovie(movieName:String) {
        movieService.searchMovie(movieName: movieName) { (result) in
            switch result {
            case .success(let movieResponse):
                self.movieSearchResults = movieResponse.arrayMovie
                self.collectionViewSearchResults.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchPeople(peopleName: String) {
        movieService.searchPeople(peopleName: peopleName) { (result) in
            switch result {
            case .success(let peopleResponse):
                self.peopleSearchResults = peopleResponse.results!
                self.collectionViewSearchResults.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func changeSearchTypeToMovie(_ sender: Any) {
        highlightMovieButton()
        searchType = .movie
        collectionViewSearchResults.reloadData()
    }
    
    @IBAction func changeSearchTypeToPeople(_ sender: Any) {
        searchType = .people
        highlightPeopleButton()
        collectionViewSearchResults.reloadData()
    }
    
    func highlightMovieButton() {
        buttonSearchMovie.backgroundColor = .yellow
        buttonSearchPeople.backgroundColor = .white
    }
    
    func highlightPeopleButton() {
        buttonSearchMovie.backgroundColor = .white
        buttonSearchPeople.backgroundColor = .yellow
    }
}

// MARK: Collection view datasource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchType {
        case .movie:
            return movieSearchResults.count
        case .people:
            return peopleSearchResults.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch searchType {
        case .movie:
            let cell = collectionViewSearchResults.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let movie = movieSearchResults[indexPath.row]
            cell.configure(withMovie: movie)
            return cell
        case .people:
            let cell = collectionViewSearchResults.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
            let people = peopleSearchResults[indexPath.row]
            cell.configure(withPeople: people)
            return cell
        }
    }
}

// MARK: Collection view delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch searchType {
        case .movie:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let movieDetailViewController = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            movieDetailViewController.movie = movieSearchResults[indexPath.row]
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        case .people:
            print("...")
        }
    }
}

// MARK: Search bar delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            movieSearchResults = []
            peopleSearchResults = []
            collectionViewSearchResults.reloadData()
        } else {
            searchMovie(movieName: searchText)
            searchPeople(peopleName: searchText)
        }
    }
}

// MARK: Collection view delegate flow layout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numItemPerRow:CGFloat = 3
        let interSpacing:CGFloat = 1
        let width:CGFloat = (collectionView.frame.width - (numItemPerRow - 1) * interSpacing) / numItemPerRow
        let height = width * 1.5
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
