//
//  ListMovieCellGroup.swift
//  TheMovie
//
//  Created by Huy on 8/18/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

protocol MoviesCellGroupDelegate: class {
    func goToMovieDetails(indexPathSection: Int, indexPathRow: Int)
}

class MoviesCellGroup: UICollectionViewCell {
    
    static let identifier = "MoviesCellGroup"
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:MoviesCellGroupDelegate?
    
    private var indexPathSection:Int!
    private var arrayMovie = [Movie]()
    private var movieService:MovieServiceType = MovieService()
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    public func configure(arrayMovie:[Movie], section: Int) {
        setUpCollectionView()
        self.arrayMovie = arrayMovie
        self.indexPathSection = section
        collectionView.reloadData()
    }
    
    // MARK: Function request API
    func requestMovies(page:Int, type: MovieType) {
        movieService.getMovies(page: page, type: type) { (result) in
            switch result {
            case .success(let movieResult):
                self.arrayMovie.append(contentsOf: movieResult.arrayMovie)
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MoviesCellGroup: UICollectionViewDataSource {
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

extension MoviesCellGroup: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.goToMovieDetails(indexPathSection: self.indexPathSection, indexPathRow: indexPath.row)
        }
    }
}

extension MoviesCellGroup: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: widthOfCells, height: heightOfCells)
    }
}
