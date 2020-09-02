//
//  HeaderView.swift
//  TheMovie
//
//  Created by Dang Quoc Huy on 8/24/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didTapSeeAll(type: MovieType)
}

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    static let identifier = "HeaderView"
    weak var delegate:HeaderViewDelegate?
    private var movieType:MovieType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(withTitle title:String, movieType:MovieType) {
        self.headerTitleLabel.text = title
        self.movieType = movieType
    }
    
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.didTapSeeAll(type: movieType)
        }
    }
}
