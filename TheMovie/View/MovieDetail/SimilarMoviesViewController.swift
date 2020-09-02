//
//  SimilarMoviesViewController.swift
//  TheMovie
//
//  Created by Huy on 8/31/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class SimilarMoviesViewController: UIViewController {
    
    @IBOutlet weak var labelTitleMovie: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let movieService:MovieServiceType = MovieService()
    private var arrayMovie:[Movie] = []
    private var movieType:MovieType!
    private var rootMovieId:Int?
    
    static func initSimilarMovies(movieType: MovieType, rootMovieID: Int) -> SimilarMoviesViewController {
        let storyboard = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "SimilarMoviesViewController") as! SimilarMoviesViewController
        controller.movieType = movieType
        controller.rootMovieId = rootMovieID
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        requestMovie()
    }
    
    func requestMovie() {
        if movieType == MovieType.similar {
            getSimilarMovies()
        } else {
            // get another movies
        }
    }
    
    func getSimilarMovies() {
        self.movieService.getSimilarMovie(movieId: self.rootMovieId!, page: 1) { (result) in
            switch result {
            case .success(let movieResult):
                self.arrayMovie = movieResult.arrayMovie
                self.moviesCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setUpView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        labelTitleMovie.text = movieType.title()
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        moviesCollectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    
    
    //    init(movieType:MovieType) {
    //        super.init(nibName: nil, bundle: nil)
    //        self.movieType = movieType
    //    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moviesViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
        
        moviesViewController.typeMovie = movieType
        moviesViewController.movieId = rootMovieId
        let title = movieType?.title()
        moviesViewController.title = title
        
        navigationController?.pushViewController(moviesViewController, animated: true)
    }
    
}

extension SimilarMoviesViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = arrayMovie[indexPath.row]
        cell.configure(withMovie: movie)
        
        return cell
    }
}

extension SimilarMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailVC.movie = arrayMovie[indexPath.row]
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

extension SimilarMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: widthOfCells, height: heightOfCells)
    }
}
