//
//  TrailerViewController.swift
//  TheMovie
//
//  Created by Huy on 8/31/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {
    
    var movieId:Int!
    var trailerWebView = WKWebView()
    let movieService:MovieServiceType = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTrailer()
        setUpWebView()
    }
    
    init(movieId:Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestTrailer() {
        let queue = DispatchQueue(label: "queue")
        queue.async {
            self.movieService.getKeyMovieTrailer(movieId: self.movieId) { (result) in
                switch result {
                case .success(let response):
                    if response.results.count > 0 {
                        let keyVideo = response.results[0].key
                        let url = URL(string: "https://www.youtube.com/embed/\(keyVideo)")!
                        self.trailerWebView.load(URLRequest(url: url))
                        print("GET KEY SUCCESS")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func setUpWebView() {
        
        view.addSubview(trailerWebView)
        
        trailerWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailerWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            trailerWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            trailerWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            trailerWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
}
