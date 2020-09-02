//
//  ListMovieCellGroup.swift
//  TheMovie
//
//  Created by Huy on 8/18/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class NowPlayingMovieCellGroup1: UICollectionViewCell {
    
    static let identifier = "PopularMoviesCellGroup"
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var movieService:MovieServiceType = MovieService()
    private var arrayMovie = [Movie]()
    private let movieType:MovieType = .popular
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUpCollectionView()
        requestPopularMovies(page: 1, type: movieType)
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
//        collectionView.showsHorizontalScrollIndicator = false
        
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    func requestPopularMovies(page: Int, type: MovieType) {
        movieService.getMovies(page: page, type: type) { (result) in
            switch result {
            case .success(let movieResult):
                let res = movieResult
                self.arrayMovie.append(contentsOf: res.arrayMovie)
                self.collectionView.reloadData()
                print("GET MOVIE SUCCESS")
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension NowPlayingMovieCellGroup1: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = arrayMovie[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
}

extension NowPlayingMovieCellGroup1: UICollectionViewDelegate {

}

extension NowPlayingMovieCellGroup1: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: widthOfCells, height: heightOfCells)
    }
}
