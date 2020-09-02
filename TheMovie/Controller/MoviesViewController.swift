//  ViewController.swift
//  TheMovie
//
//  Created by Huy on 7/27/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var movieService:MovieServiceType = MovieService()
    private let realmService:LocalDBServiceType = RealmService()
    private var arrayMovie = [Movie]()
    private var page = 1
    public var typeMovie: MovieType! = nil
    internal var movieId:Int?
    
    // MARK: View life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        if typeMovie == MovieType.similar {
            requestSimilarMovies(page: page)
        } else {
            requestMovies(page: page, type: typeMovie)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: Set up view
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
        realmService.loadData()
        
    }
    
    // MARK: Request API
    func requestMovies(page:Int, type: MovieType) {
        movieService.getMovies(page: page, type: type) { (result) in
            switch result {
            case .success(let movieResult):
                self.arrayMovie.append(contentsOf: movieResult.arrayMovie)
                self.collectionView.reloadData()
                self.page += 1
                print("GET MOVIE SUCCESS")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestSimilarMovies(page:Int) {
        movieService.getSimilarMovie(movieId: movieId!, page: page) { (result) in
            switch result {
            case .success(let movieResult):
                self.arrayMovie.append(contentsOf: movieResult.arrayMovie)
                self.collectionView.reloadData()
                self.page += 1
                print("GET MOVIE SUCCESS")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:- Navigation
    func goToMovieDetail(movie: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailViewController.movie = movie
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    
}

// MARK: Collection view flow layout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 10, right: 0)
    }
}

// MARK: Delegate
extension MoviesViewController: UICollectionViewDelegate {
    // Did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = arrayMovie[indexPath.row]
        goToMovieDetail(movie: movie)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height) {
            // MARK: Load more movie
            if typeMovie != MovieType.similar {
                requestMovies(page: page, type: typeMovie)
            } else {
                requestSimilarMovies(page: page)
            }
        }
    }
}

// MARK: DataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = arrayMovie[indexPath.row]
        cell.configure(withMovie: movie)
        
        return cell
    }
}
