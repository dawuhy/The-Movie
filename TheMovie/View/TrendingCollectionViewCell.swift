//
//  TrendingCollectionViewCell.swift
//  TheMovie
//
//  Created by Huy on 8/10/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {

    static let identifier = "trendingcell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(movie: Movie) {
        
    }
    
    static func nib() -> UINib {
        return .init(nibName: "TrendingCollectionViewCell", bundle: nil)
    }
}
