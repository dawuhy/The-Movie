//
//  HomePageViewController.swift
//  TheMovie
//
//  Created by Huy on 8/18/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    private var sections:[MoviesSectionData] = []
    private var movieService:MovieServiceType = MovieService()
    private var popularMovies:[Movie] = []
    private var topRatedMovies:[Movie] = []
    private var nowPlayingMovies:[Movie] = []
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        requestPopularMovies(page: 1)
        requestTopRatedMovies(page: 1)
        requestNowPlayingMovies(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieCollectionView.reloadData()
    }
    
    // MARK: Request API
    func requestPopularMovies(page:Int) {
        movieService.getMovies(page: page, type: .popular) { (result) in
            switch result {
            case .success(let movieResult):
                self.popularMovies.append(contentsOf: movieResult.arrayMovie)
                let popularSectionData = MoviesSectionData(movieType: .popular, arrayMovie: self.popularMovies)
                self.sections.append(popularSectionData)
                self.movieCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestTopRatedMovies(page:Int) {
        movieService.getMovies(page: page, type: .top_rated) { (result) in
            switch result {
            case .success(let movieResult):
                self.topRatedMovies.append(contentsOf: movieResult.arrayMovie)
                let topRatedSectionData = MoviesSectionData(movieType: .top_rated, arrayMovie: self.topRatedMovies)
                self.sections.append(topRatedSectionData)
                self.movieCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestNowPlayingMovies(page:Int) {
        movieService.getMovies(page: page, type: .now_playing) { (result) in
            switch result {
            case .success(let movieResult):
                self.nowPlayingMovies.append(contentsOf: movieResult.arrayMovie)
                let nowPlayingSectionData = MoviesSectionData(movieType: .now_playing, arrayMovie: self.nowPlayingMovies)
                self.sections.append(nowPlayingSectionData)
                self.movieCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: Set up view
    func configureSectionData() {
        let popularSectionData = MoviesSectionData(movieType: .popular, arrayMovie: popularMovies)
        self.sections.append(popularSectionData)
        let nowPlayingSectionData = MoviesSectionData(movieType: .now_playing, arrayMovie: nowPlayingMovies)
        sections.append(nowPlayingSectionData)
        let topRatedSectionData = MoviesSectionData(movieType: .top_rated, arrayMovie: topRatedMovies)
        sections.append(topRatedSectionData)
        
    }
    
    func configureView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        let nib = UINib(nibName: MoviesCellGroup.identifier, bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: MoviesCellGroup.identifier)
        
        let nibHeaderView = UINib(nibName:HeaderView.identifier, bundle: nil)
        movieCollectionView.register(nibHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
}

// MARK: Datasource
extension HomePageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCellGroup.identifier, for: indexPath) as! MoviesCellGroup
        cell.delegate = self
        cell.configure(arrayMovie: sections[indexPath.section].arrayMovie, section: indexPath.section)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
            headerView.configure(withTitle: sections[indexPath.section].title, movieType: sections[indexPath.section].movieType)
            headerView.delegate = self
            
            return headerView
        default:
            fatalError("Invalid supplementary kind.")
        }
    }
}

// MARK: Delegate
extension HomePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 70)
    }
}

// MARK: Collectionview flow layout
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: heightOfCells + 20)
    }
}

extension HomePageViewController: HeaderViewDelegate {
    func didTapSeeAll(type: MovieType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moviesViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
        moviesViewController.typeMovie = type
        let section = sections.filter { $0.movieType == type}
        let title = section[0].title
        moviesViewController.title = title
        
        navigationController?.pushViewController(moviesViewController, animated: true)
    }
}

extension HomePageViewController: MoviesCellGroupDelegate {
    func goToMovieDetails(indexPathSection: Int, indexPathRow: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        movieDetailVC.movie = sections[indexPathSection].arrayMovie[indexPathRow]
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
