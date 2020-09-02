//
//  FavoriteMovieViewController.swift
//  TheMovie
//
//  Created by Huy on 8/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class FavoriteMovieViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let movieService: MovieServiceType = MovieService()
    private let realmService:LocalDBServiceType = RealmService()
    
    // MARK: View life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmService.loadData()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: Set up view
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    // MARK: Function
    func goToMovieDetails(movie: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailViewController.movie = movie
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: Collection view datasource
extension FavoriteMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFavoriteMovie == nil ? 0 : listFavoriteMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movieObject = listFavoriteMovie[indexPath.row]
        let movie = Movie(movieObject: movieObject)
        cell.configure(withMovie: movie)
        
        return cell
    }
}

// MARK: Collection view delegate
extension FavoriteMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieObject = listFavoriteMovie[indexPath.row]
        let movie = Movie(movieObject: movieObject)
        goToMovieDetails(movie: movie)
    }
    
    
}

// MARK: Collection view delegate flow layout
extension FavoriteMovieViewController: UICollectionViewDelegateFlowLayout {
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
