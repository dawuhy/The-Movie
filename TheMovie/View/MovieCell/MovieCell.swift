//
//  MyCollectionViewCell.swift
//  TheMovie
//
//  Created by Huy on 8/10/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit

let height = 200


class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickedFavoriteButton: UIButton!
    
    var movie:Movie?
    var people: People?
    static let identifier = "MovieCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(withMovie movie: Movie) {
        tickedFavoriteButton.isHidden = true
        self.movie = movie
        
        let queue = DispatchQueue(label: "queue")
        queue.async {
            do {
                let urlImage:URL!
                if movie.posterPath != nil {
                    urlImage = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")!
                } else {
                    urlImage = URL(string: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png")!
                }
                let data = try Data(contentsOf: urlImage)
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                    self.titleLabel.text = movie.title
                }
            } catch (let error) {
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                var favorite:Bool = false
                if listFavoriteMovie != nil {
                     favorite = listFavoriteMovie.contains { (movieObject) -> Bool in
                        movieObject.id == movie.id ? true : false
                    }
                }
                if favorite {
                    self.displayTickIcon()
                }
            }
        }
    }
    
    public func configure(withPeople people: People) {
        tickedFavoriteButton.isHidden = true
        self.people = people
        
        let queue = DispatchQueue(label: "queue")
        queue.async {
            do {
                let urlImage:URL!
                if people.profilePath != nil {
                    urlImage = URL(string: getStringURLImage(path: people.profilePath!))!
                } else {
                    urlImage = URL(string: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png")!
                }
                let data = try Data(contentsOf: urlImage)
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                    self.titleLabel.text = people.name
                }
            } catch (let error) {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = ""
    }
    
    func displayTickIcon() {
        tickedFavoriteButton.isHidden = false
    }
    
    @IBAction func tickFavoriteTapped(_ sender: Any) {
        
    }
    
    @IBAction func untickFavoriteTapped(_ sender: Any) {
        
    }
}
