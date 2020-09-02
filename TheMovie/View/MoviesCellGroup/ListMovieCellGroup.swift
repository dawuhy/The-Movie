//
//  ListMovieCellGroup.swift
//  TheMovie
//
//  Created by Huy on 8/18/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class PopularMoviesCellGroup: UICollectionViewCell {
    
    static let height:CGFloat = 180
    static let width:CGFloat = height / 1.5
    static let identifier = "ListMovieCellGroup"
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var movieService:MovieServiceType = MovieService()
    private var arrayPopularMovie = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("HELLO")
        setUpCollectionView()
        requestPopularMovies(page: 1, type: .popular)
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MovieCell.nib(), forCellWithReuseIdentifier: MovieCell.identifier)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func requestPopularMovies(page: Int, type: TypeMovie) {
        movieService.getMovies(page: page, type: type) { (result) in
            switch result {
            case .success(let movieResult):
                let res = movieResult
                self.arrayPopularMovie.append(contentsOf: res.arrayMovie)
                self.collectionView.reloadData()
                print("GET MOVIE SUCCESS")
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PopularMoviesCellGroup: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPopularMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        let movie = arrayPopularMovie[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
}

extension PopularMoviesCellGroup: UICollectionViewDelegate {
    
}

extension PopularMoviesCellGroup: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: PopularMoviesCellGroup.width, height: PopularMoviesCellGroup.height)
    }
}
