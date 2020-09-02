//
//  TrendingView.swift
//  TheMovie
//
//  Created by Huy on 8/10/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

protocol TrendingViewDelegate: class {
    func didTapOnCell(indexPathDotRow: Int)
}

class TrendingView: UICollectionReusableView {
    
    let movieService:MovieServiceType = MovieService()
    let realmService:LocalDBServiceType = RealmService()
    weak var delegate: TrendingViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifier = "TrendingView"
    static var trendingMovies:[Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
        getTrendingMovie()
        collectionView.reloadData()
        print("AWAKE FROM NIB")
        realmService.addObserver { (changes) in
            switch changes {
            case .success(_):
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func nib() -> UINib {
        return .init(nibName: identifier, bundle: nil)
    }
    

    func configureView() {

        self.collectionView.backgroundColor = .black
        self.collectionView.largeContentTitle = "Trending Movie"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    func getTrendingMovie() {
        movieService.getTrendingMovie { (result) in
            switch result {
            case .success(let res):
                TrendingView.trendingMovies = res.arrayMovie
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TrendingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("################## \(TrendingView.trendingMovies.count)")
        return TrendingView.trendingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = TrendingView.trendingMovies[indexPath.row]
        cell.configure(withMovie: movie)
        
        return cell
    }
}

extension TrendingView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 125, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.didTapOnCell(indexPathDotRow: indexPath.row)
        }
    }
    
}
