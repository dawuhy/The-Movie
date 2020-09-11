//
//  MovieDetailViewController.swift
//  TheMovie
//
//  Created by Huy on 8/3/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewText: UITextView!
    //    @IBOutlet weak var trailerWKWebView: WKWebView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var heartButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewSimilarMovies: UICollectionView!
    @IBOutlet weak var viewSimilarMovies: UIView!
    
    var movie:Movie!
    let movieService:MovieServiceType = MovieService()
    let realmService: LocalDBServiceType = RealmService()
    var similarMovies:[Movie] = []
    
    
    //MARK- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmService.loadData()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpHeartButton()
    }
    
    deinit {
        print("deinit detail")
    }
    
    
    //MARK- Setups
    func setUpView() {
        title = movie.title
        titleLabel.text = movie.title
        releaseDateLabel.text = String(movie.releaseDate!.prefix(4))
        overviewText.text = movie.overview
        
        // Lazy load image
        let queue = DispatchQueue(label: "queue")
        queue.async {
            do {
                let urlString: String!
                
                if (self.movie.posterPath != nil) {
                    urlString = "https://image.tmdb.org/t/p/w500\(String(self.movie.posterPath!))"
                } else {
                    urlString = "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png"
                }
                
                let urlImage = URL(string: urlString)
                let data = try Data(contentsOf: urlImage!)
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: data)
                }
            } catch (let error) {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // Web view movie trailer
        setUpTrailerWebView()
        
        // Child view similar movies
        setUpSimilarMovies()
    }
    
    // MARK:- Set up view
    func setUpSimilarMovies() {
        let similarMoviesVC = SimilarMoviesViewController.initSimilarMovies(movieType: .similar, rootMovieID: movie.id)
        self.addChild(similarMoviesVC)
        self.viewSimilarMovies.addSubview(similarMoviesVC.view)
        similarMoviesVC.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            similarMoviesVC.view.leadingAnchor.constraint(equalTo: viewSimilarMovies.leadingAnchor, constant: 0),
            similarMoviesVC.view.trailingAnchor.constraint(equalTo: viewSimilarMovies.trailingAnchor, constant: 0),
            similarMoviesVC.view.topAnchor.constraint(equalTo: viewSimilarMovies.topAnchor, constant: 0),
            similarMoviesVC.view.bottomAnchor.constraint(equalTo: viewSimilarMovies.bottomAnchor, constant: 0)
        ])
    }
    
    func setUpTrailerWebView() {
        let trailerWebView = TrailerViewController(movieId: self.movie.id)
        addChild(trailerWebView)
        trailerView.addSubview(trailerWebView.view)
        didMove(toParent: self)
        
        trailerWebView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailerWebView.view.leadingAnchor.constraint(equalTo: trailerView.leadingAnchor, constant: 0),
            trailerWebView.view.trailingAnchor.constraint(equalTo: trailerView.trailingAnchor, constant: 0),
            trailerWebView.view.topAnchor.constraint(equalTo: trailerView.topAnchor, constant: 0),
            trailerWebView.view.bottomAnchor.constraint(equalTo: trailerView.bottomAnchor, constant: 0)
        ])
    }
    
    func setUpHeartButton() {
        var favorite:Bool = false
        if listFavoriteMovie != nil {
            favorite = listFavoriteMovie.contains { (movieObject) -> Bool in
                movieObject.id == movie.id ? true : false
            }
        }
        
        if favorite {
            heartButton.image = UIImage(systemName: "heart.fill")
        } else {
            heartButton.image = UIImage(systemName: "heart")
        }
        heartButton.tintColor = .systemPink
    }
    
    @IBAction func addOrRemoveFavoriteTapped(_ sender: Any) {
        let favorite:Bool = listFavoriteMovie.contains { (movieObject) -> Bool in
            movieObject.id == movie.id ? true : false
        }
        if favorite {
            heartButton.image = UIImage(systemName: "heart")
            realmService.deleteMovie(movie: movie)
        } else {
            heartButton.image = UIImage(systemName: "heart.fill")
            realmService.addMovie(movie: movie)
        }
    }
    
    func goToMovieDetail(movie: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailViewController.movie = movie
        
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    //MARK:- Request movie
    func getSimilarMovies() {
        self.movieService.getSimilarMovie(movieId: self.movie.id, page: 1) { (result) in
            switch result {
            case .success(let movieResult):
                self.similarMovies = movieResult.arrayMovie
                self.collectionViewSimilarMovies.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Collection view datasource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewSimilarMovies.dequeueReusableCell(withReuseIdentifier: MoviesCellGroup.identifier, for: indexPath) as! MoviesCellGroup
        
        cell.configure(arrayMovie: similarMovies, section: indexPath.section)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
            headerView.configure(withTitle: "Similar Movies", movieType: .similar)
            headerView.delegate = self
            return headerView
        default:
            fatalError("Invalid supplementary kind.")
        }
    }
}

// MARK: Collection view delegate
extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = similarMovies[indexPath.row]
        goToMovieDetail(movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if similarMovies.count > 0 {
            return .init(width: collectionView.bounds.width, height: 80)
        }
        return .init(width: 0, height: 0)
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionViewSimilarMovies.bounds.width, height: heightOfCells + 20)
    }
    
}

extension MovieDetailViewController: MoviesCellGroupDelegate {
    func goToMovieDetails(indexPathSection: Int, indexPathRow: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailVC.movie = similarMovies[indexPathRow]
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

extension MovieDetailViewController: HeaderViewDelegate {
    func didTapSeeAll(type: MovieType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moviesViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
        
        moviesViewController.typeMovie = type
        moviesViewController.movieId = self.movie.id
        let title = "Similar Movie"
        moviesViewController.title = title
        
        navigationController?.pushViewController(moviesViewController, animated: true)
    }
}
